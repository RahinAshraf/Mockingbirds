import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/helpers/database_helpers/schedule_helper.dart';
import 'package:veloplan/alerts.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/widgets/dynamic_widget.dart';
import 'package:veloplan/widgets/panel_widget/panel_widgets_base.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:veloplan/popups.dart';
import 'package:veloplan/helpers/database_helpers/history_helper.dart';
import 'package:veloplan/widgets/panel_widget/panel_widget_exts.dart';
import '../../helpers/database_helpers/database_manager.dart';

/// Renders [PanelWidget] used in [JourneyPlanner] screen.
///
/// It is an interactive panel the user can slide up or down,
/// when wanting to input their desired locations for the journey.
/// Author: Rahin
/// Contributor(s): Nicole, Eduard, Fariha, Marija, Tayyibah
class PanelWidget extends PanelWidgetBase {
  late Map<int, DockingStation> dockingStationMap;
  PanelWidget(
      {Key? key,
      required Map<String, List<double?>> selectionMap,
      required Stream<MapPlace> address,
      required ScrollController scrollController,
      required StreamController<List<DynamicWidget>> dynamicWidgets,
      required List<DynamicWidget> listDynamic,
      required List<List<double?>?> selectedCoords,
      required Map<String, List<double?>> staticListMap,
      required TextEditingController toTextEditController,
      required int numberOfCyclists,
      required TextEditingController fromTextEditController,
      required PanelController panelController,
      required this.dockingStationMap,
      required bool isScheduled,
      required DateTime journeyDate})
      : super(
            selectionMap: selectionMap,
            address: address,
            scrollController: scrollController,
            dynamicWidgets: dynamicWidgets,
            listDynamic: listDynamic,
            selectedCoords: selectedCoords,
            staticListMap: staticListMap,
            toTextEditController: toTextEditController,
            fromTextEditController: fromTextEditController,
            panelController: panelController,
            numberOfCyclists: numberOfCyclists,
            isScheduled: isScheduled,
            journeyDate: journeyDate);
  @override
  PanelWidgetState createState() {
    return PanelWidgetState();
  }

  ///Handle when the user presses a TextField to input a location. The [textEditingController] is the TextField that the
  ///user pressed on to search for a location. [onAddressAdded] are the coordinates of the address the user selects to add
  ///to their journey
  void handleOnSearchClick(
      BuildContext context,
      TextEditingController textEditingController,
      Function(List<double?>) onAddressAdded) {
    handleSearchClick(this, context, textEditingController, onAddressAdded);
  }
}

class PanelWidgetState extends State<PanelWidget> {
  Stream<List<DynamicWidget>> get dynamicWidgetsStream =>
      widget.dynamicWidgets.stream;
  final locService = LocationService();
  late Map<String, List<double?>> selectionMap;
  late Map<String, List<double?>> staticListMap;
  late Map response;
  final dockingStationManager _stationManager = dockingStationManager();
  final TextEditingController editDockTextEditController =
      TextEditingController();
  static const String fromLabelKey = "From";
  final Alerts alert = Alerts();
  late Map<int, DockingStation> dockMap;

  ///Adds a new dynamic widget to the list of destinations for the journey
  addDynamic() {
    final hasEmptyField = widget.listDynamic
        .any((element) => element.placeTextController.text.isEmpty);

    if (hasEmptyField) {
      alert.showSnackBarErrorMessage(
          context, alert.cannotHaveEmptySearchLocationsMessage);
      return;
    }

    widget.listDynamic.add(DynamicWidget(
      selectedCoords: widget.selectedCoords,
      coordDataMap: response,
      latLngMap: dockMap,
      isFrom: false,
      isScheduled: widget.isScheduled,
      numberOfCyclists: widget.numberOfCyclists,
    ));
    widget.dynamicWidgets.sink.add(widget.listDynamic);
  }

  /// Imports the docking stations from the TFL API.
  void importDockStation() async {
    await _stationManager.importStations();
  }

  /// Initialises variables and listens for user interaction to act on.
  @override
  void initState() {
    dockMap = widget.dockingStationMap;
    staticListMap = widget.staticListMap;
    selectionMap = widget.selectionMap;
    LatLng currentLocation = getLatLngFromSharedPrefs();
    locService
        .reverseGeoCode(currentLocation.latitude, currentLocation.longitude)
        .then((value) {
      setState(() {
        if (mounted) {
          response = value;
        }
      });
    });
    _listToMapClick();
    importDockStation();
    super.initState();
  }

  ///Listens to the map and adds the place that the user taps on the map, to the Journey Planner as a new location.
//TODO what do we do with isFrom here?
  void _listToMapClick() {
    final selectedCoords = widget.selectedCoords;

    widget.address.listen((event) {
      final dynamicWidget = DynamicWidget(
        selectedCoords: selectedCoords,
        coordDataMap: response,
        latLngMap: dockMap,
        isFrom: false,
        isScheduled: widget.isScheduled,
        numberOfCyclists: widget.numberOfCyclists,
      );

      //Cannot add by click of the map if there exists non-specified locations
      final list = widget.listDynamic;
      if (list.any((element) => element.placeTextController.text.isEmpty)) {
        alert.showSnackBarErrorMessage(
            context, alert.cannotHaveEmptySearchLocationsMessage);
        return;
      }

      //Set the location tapped on from the map, as the place specified in the destination TextController
      dynamicWidget.placeTextController.text = event.address ?? "";
      dynamicWidget.position = widget.listDynamic.length;
      widget.listDynamic.add(dynamicWidget);

      if (dynamicWidget.position > selectedCoords.length) {
        selectedCoords.add([event.coords?.latitude, event.coords?.longitude]);
      } else {
        selectedCoords.insert(dynamicWidget.position,
            [event.coords?.latitude, event.coords?.longitude]);
      }

      dynamicWidget.checkInputLocation(position: dynamicWidget.position);
      widget.dynamicWidgets.sink.add(widget.listDynamic);
    });
  }

  ///When called, this function sets the first location of the journey to the users current location
  _useCurrentLocationButtonHandler(TextEditingController controller, String key,
      bool isFrom, int numberCyclists) async {
    sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    double latitudeOfPlace = response['location'].latitude;
    double longitudeOfPlace = response['location'].longitude;
    List<double?> currentLocationCoords = [latitudeOfPlace, longitudeOfPlace];
    controller.text = place;
    staticListMap[key] = currentLocationCoords;

    PanelExtensions.of().checkInputLocation(controller,
        editDockTextEditController, dockMap, -1, isFrom, numberCyclists);
  }

  ///Builds the static row of components which are displayed permanently. Statically built, as every journey
  ///needs to specify a starting point. [controller] is the TextField used to input and display the destination the user is
  ///to start their journey from. [hintText] is the text to describe the purpose of each TextField to the user.
  Widget _buildStatic(TextEditingController controller,
      {String? hintText,
      required BuildContext context,
      required String label,
      required bool isFrom,
      required int numberCyclists,
      required Function(List<double?>) onAddressAdded}) {
    return Column(
      children: [
        TextField(
          readOnly: true,
          onTap: () {
            widget.handleOnSearchClick(context, controller, onAddressAdded);
          },
          onEditingComplete: () {
            PanelExtensions.of(context: context).checkInputLocation(
                controller,
                editDockTextEditController,
                dockMap,
                -1,
                true,
                widget.numberOfCyclists);
          },
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: circularInputBorder(),
            enabledBorder: circularInputBorder(),
            disabledBorder: circularInputBorder(),
            errorBorder: circularInputBorder(),
            focusedBorder:
                circularInputBorder(width: 2.0, color: CustomColors.green),
            suffixIcon: IconButton(
              key: Key("myLocation"),
              onPressed: () {
                _useCurrentLocationButtonHandler(
                    controller, label, isFrom, numberCyclists);
              },
              icon:
                  Icon(Icons.my_location, size: 20, color: CustomColors.green),
            ),
          ),
        ),
        PanelExtensions.of(context: context).buildDefaultClosestDock(
            editDockTextEditController,
            controller,
            dockMap,
            isFrom,
            numberCyclists,
            widget.isScheduled),
      ],
    );
  }

  ///Given a coordinate, [newCord], it sets the 'From' location as the place specified by the coordinates passed in
  void addCordFrom(List<double?> newCord) {
    staticListMap[fromLabelKey] = newCord;
    final ext = PanelExtensions.of(context: context);
    ext.fillClosestDockBubble(newCord[0], newCord[1],
        editDockTextEditController, dockMap, -1, true, widget.numberOfCyclists);
  }

  ///Callback for when the user reorders items in the list of locations. It rearranges the order of the
  ///coordinates according to the reordering of the listItems. [oldIndex] is where the item used to be located in the
  ///draggable list, and [newIndex] is where the item has been moved to by the user.
  void _updateItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = widget.listDynamic.removeAt(oldIndex);
    widget.listDynamic.insert(newIndex, item);

    if (oldIndex < widget.selectedCoords.length) {
      final itemCoords = widget.selectedCoords[oldIndex];
      widget.selectedCoords.removeAt(oldIndex);
      widget.selectedCoords.insert(newIndex, itemCoords);

      final newLatLng = widget.dockingStationMap[newIndex];
      final oldCordList = widget.dockingStationMap[oldIndex];

      if (newLatLng != null && oldCordList != null) {
        widget.dockingStationMap[oldIndex] = newLatLng;
        widget.dockingStationMap[newIndex] = oldCordList;
      }
    }
  }

  /// Creates the panel itself.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_back,
                  key: Key("back"),
                  size: 25,
                  color: Colors.green,
                ),
              ),
              Text(
                "Explore London",
                style: CustomTextStyles.infoTextStyle,
              ),
              Tooltip(
                message:
                    'Please specify the starting location of your trip and add destinations by clicking the + button. Tapping on the location in the map is another way of adding a stop to your trip! Ensure there are no blank destinations when you do so. You can also reorder your destinations. Simply hold and drag menu button. When you are done, click START/SAVE.',
                child: const Icon(Icons.info_outline_rounded,
                    size: 25.0, color: Colors.green),
              ),
            ],
          ),
        ),
        SizedBox(height: 7.0),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: 10.0),
            controller: widget.scrollController,
            children: [
              _buildStatic(widget.fromTextEditController,
                  hintText: "Where from?",
                  label: "From",
                  context: context,
                  onAddressAdded: addCordFrom,
                  isFrom: true,
                  numberCyclists: widget.numberOfCyclists),
              Column(
                children: [
                  StreamBuilder<List<DynamicWidget>>(
                    builder: (_, snapshot) {
                      List<DynamicWidget> listOfDynamics = snapshot.data ?? [];

                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ReorderableListView.builder(
                          itemExtent: 120,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            final dynamicWidget = listOfDynamics[index];
                            dynamicWidget.position = index;
                            dynamicWidget.removeDynamic((p0) {
                              widget.listDynamic.removeAt(index);
                              widget.dynamicWidgets.sink
                                  .add(widget.listDynamic);
                            });
                            return Container(
                                key: ValueKey(index), child: dynamicWidget);
                          },
                          itemCount: listOfDynamics.length,
                          physics: const NeverScrollableScrollPhysics(),
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              _updateItems(oldIndex, newIndex);
                            });
                          },
                        ),
                      );
                    },
                    stream: dynamicWidgetsStream,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: buildFloatingActionButton(onPressed: addDynamic),
              ),
            ],
          ),
        ),
        SizedBox(child: Divider(), width: MediaQuery.of(context).size.width),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
              key: Key("start"),
              onPressed:
                  widget.isScheduled ? _handleSaveClick : _handleStartClick,
              child: widget.isScheduled ? Text("SAVE") : Text("START"),
            ),
          ),
        ),
      ],
    );
  }

  ///The function to deal with the user pressing the START button. Applies the constraints for a journey.
  ///For all the coordinates of the locations the user specified, creates a new list - this new list is a list of all the
  ///closest docking stations for the locations the user specified. This new list is then passed onto MapRoutePage.
  Future<void> _handleSaveClick() async {
    if (breaksConstraints()) {
      return;
    }
    await Future.delayed(const Duration(seconds: 2));
    List<List<double?>?> tempList = [];
    tempList.addAll(staticListMap.values);
    tempList.addAll(widget.selectedCoords);
    ScheduleHelper helper = ScheduleHelper();
    helper.createScheduleEntry(
        widget.journeyDate, tempList, widget.numberOfCyclists);
    // Navigate back to the previous screen, useful for tbt
    Navigator.of(context).pop(true);
    var popup = Popups();
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            popup.buildPopupDialogJourneySaved(context, widget.journeyDate));
  }

  /// Deals with the user pressing the START button. Applies the constraints for a journey.
  /// For all the coordinates of the locations the user specified, creates a new list - this new list is a list of all the
  /// closest docking stations for the locations the user specified. This new list is then passed onto [MapRoutePage].
  Future<void> _handleStartClick() async {
    if (breaksConstraints()) {
      return;
    }
    await Future.delayed(const Duration(seconds: 2));
    List<List<double?>?> tempList = [];
    tempList.addAll(staticListMap.values);
    tempList.addAll(widget.selectedCoords);
    List<LatLng>? points = convertListDoubleToLatLng(tempList);
    HistoryHelper historyHelper = HistoryHelper(DatabaseManager());
    List<DockingStation> selectedDocks = dockMap.values.toList();
    Itinerary _itinerary = new Itinerary.navigation(
        selectedDocks, points, widget.numberOfCyclists);
    historyHelper
        .createJourneyEntry(selectedDocks); //save the journey into the database
    //go to the summary of journey screen
    final response =
        await context.push(SummaryJourneyScreen(_itinerary, false));
    if (response || response == null) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop();
    }
  }

  ///Checks if the user has any blank destinations
  bool hasUnspecifiedDestinations() {
    final hasEmptyField = widget.listDynamic
        .any((element) => element.placeTextController.text.isEmpty);
    return hasEmptyField;
  }

  ///Checks if the user has specified a journey where the next docking station of the journey is the previous docking station
  bool hasAdjacentDocks() {
    List<DockingStation> closestDockList = dockMap.values.toList();
    if (closestDockList.isEmpty) {
      return false;
    }
    for (int i = 0; i < closestDockList.length - 1; i++) {
      if (closestDockList[i].lat == closestDockList[i + 1].lat &&
          closestDockList[i].lon == closestDockList[i + 1].lon) {
        return true;
      }
    }
    return false;
  }

  ///Checks if the user has specified a journey where the next destination of the journey is the previous destination
  bool hasAdjacentDestinations() {
    List<List<double?>?> tempList = [];
    tempList.addAll(staticListMap.values);
    tempList.addAll(widget.selectedCoords);
    return hasAdjacent(tempList);
  }

  ///Given a list of coordinates as doubles, checks if the list contains an adjacent within the list
  bool hasAdjacent(List<List<double?>?> listOfPoints) {
    if (listOfPoints.isEmpty) {
      return false;
    }
    for (int i = 0; i < listOfPoints.length - 1; i++) {
      if (listOfPoints[i]?.first == listOfPoints[i + 1]?.first &&
          listOfPoints[i]?.last == listOfPoints[i + 1]?.last) {
        return true;
      }
    }
    return false;
  }

  ///The logic to restrict the user from being able to start a journey without a starting point in the
  ///[textEditingController].
  bool startLocationMustBeSpecified() {
    if (widget.fromTextEditController.text.isEmpty) {
      alert.showSnackBarErrorMessage(
          context, alert.startPointMustBeDefinedMessage);
      return true;
    }
    return false;
  }

  ///The logic to restrict the user from being able to start a journey without defining at least one destination for the journey
  bool oneDestinationMustBeSpecified() {
    if (widget.listDynamic.isEmpty) {
      alert.showSnackBarErrorMessage(
          context, alert.chooseAtLeastOneDestinationMessage);
      return true;
    }
    return false;
  }

  ///Applies all the constraints needed for the panel widget. If any constraints are broken, program execution terminates
  ///and  displays necessary error message to the user. [fromEditingController] and the [toEditingController] are the
  ///controllers where the user specifies the destination to start their journey from and where to go respectively.
  bool breaksConstraints() {
    if (startLocationMustBeSpecified()) {
      alert.showSnackBarErrorMessage(
          context, alert.startPointMustBeDefinedMessage);
      return true;
    }
    if (oneDestinationMustBeSpecified()) {
      alert.showSnackBarErrorMessage(
          context, alert.chooseAtLeastOneDestinationMessage);
      return true;
    }
    if (hasUnspecifiedDestinations()) {
      alert.showSnackBarErrorMessage(
          context, alert.cannotHaveEmptySearchLocationsMessage);
      return true;
    }
    if (hasAdjacentDestinations()) {
      alert.showSnackBarErrorMessage(context, alert.noAdjacentLocationsAllowed);
      return true;
    }
    if (hasAdjacentDocks()) {
      alert.showSnackBarErrorMessage(
          context, alert.adjacentClosestDocksMessage);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
