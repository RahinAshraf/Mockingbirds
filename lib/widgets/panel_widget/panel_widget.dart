import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/screens/navigation/map_with_route_screen.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/widgets/panel_widget/panel_widget_exts.dart';
import 'package:veloplan/widgets/panel_widget/panel_widgets_base.dart';
import '../../helpers/navigation_helpers/navigation_conversion_helpers.dart';
import '../../models/docking_station.dart';
import '../../providers/location_service.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/alerts.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/models/docking_station.dart';
import '../dynamic_widget.dart';

///When rendered, the journey_planner_screen will have this panel_widget at the bottom. It is an interactive panel the user can
///slide up or down, when wanting to input their desired locations for the journey.
///@author: Rahin Ashraf - k20034059

class PanelWidget extends PanelWidgetBase {
  late Map<int, LatLng> dockList;
   PanelWidget({Key? key, required Map<String, List<double?>> selectionMap, required Stream<MapPlace> address,
     required ScrollController scrollController, required StreamController<List<DynamicWidget>> dynamicWidgets,
     required List<DynamicWidget> listDynamic, required List<List<double?>?> selectedCoords,
     required Map<String, List<double?>> staticListMap, required TextEditingController toTextEditController,
     required int numberOfCyclists,
     required TextEditingController fromTextEditController, required PanelController panelController,
     required this.dockList})
       : super(selectionMap: selectionMap, address: address, scrollController: scrollController,
       dynamicWidgets: dynamicWidgets, listDynamic: listDynamic, selectedCoords: selectedCoords,
       staticListMap: staticListMap, toTextEditController: toTextEditController,
       fromTextEditController: fromTextEditController, panelController: panelController,
       numberOfCyclists: numberOfCyclists);
  @override
  PanelWidgetState createState() {
    return PanelWidgetState();
  }

  ///Returns whether or not the user has specified a destination. If not, displays an [alert]
  bool hasSpecifiedOneDestination(BuildContext context, Alerts alert) => oneDestinationMustBeSpecified(this, context, alert);

  ///Handle when the user presses a TextField to input a location. The [textEditingController] is the TextField that the
   ///user pressed on to search for a location. [onAddressAdded] are the coordinates of the address the user selects to add
   ///to their journey
  void handleOnSearchClick(BuildContext context,
      TextEditingController textEditingController,
      Function(List<double?>) onAddressAdded){
    handleSearchClick(this, context, textEditingController, onAddressAdded);
  }
}

class PanelWidgetState extends State<PanelWidget> {
  Stream<List<DynamicWidget>> get dynamicWidgetsStream => widget.dynamicWidgets.stream;
  final locService = LocationService();
  late Map<String, List<double?>> selectionMap;
  late Map<String, List<double?>> staticListMap;
  late Map response;
  final dockingStationManager _stationManager = dockingStationManager();
  final TextEditingController editDockTextEditController = TextEditingController();
  static const String fromLabelKey = "From";
  static const String toLabelKey = "To";
  final Alerts alert = Alerts();
  late Map<int, LatLng> dockList;

  ///Adds a new dynamic widget to the list of destinations for the journey
  addDynamic() {
    final hasEmptyField = widget.listDynamic
        .any((element) => element.placeTextController.text.isEmpty);

    if (hasEmptyField) {
      alert.showSnackBarErrorMessage(context, alert.cannotHaveEmptySearchLocationsMessage);
      return;
    }

    widget.listDynamic.add(DynamicWidget(
      selectedCoords: widget.selectedCoords,
      coordDataMap: response,
      latLngMap: dockList,
    ));
    widget.dynamicWidgets.sink.add(widget.listDynamic);
  }

  ///imports the docking stations from the TFL api
  void importDockStation() async {
    await _stationManager.importStations();
  }

  ///Initialises variables and listens for user interaction to act on
  @override
  void initState() {
    dockList = widget.dockList;
    staticListMap = widget.staticListMap;
    selectionMap = widget.selectionMap;
    print("PanelWidgetState => ${widget.numberOfCyclists}"); //access number of cyclist like this
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
  void _listToMapClick() {
    final selectedCoords = widget.selectedCoords;

    widget.address.listen((event) {
      final dynamicWidget = DynamicWidget(
        selectedCoords: selectedCoords,
        coordDataMap: response,   latLngMap: dockList,
      );

      //Cannot add by click of the map if there exists non-specified locations
      final list = widget.listDynamic;
      if (list.any((element) => element.placeTextController.text.isEmpty)) {
        alert.showSnackBarErrorMessage(context, alert.cannotHaveEmptySearchLocationsMessage);
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

  ///This function sets the [controller] to the users current location.
  _useCurrentLocationButtonHandler(
      TextEditingController controller, String key) async {
    sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    double latitudeOfPlace = response['location'].latitude;
    double longitudeOfPlace = response['location'].longitude;
    List<double?> currentLocationCoords = [latitudeOfPlace, longitudeOfPlace];
    controller.text = place;
    staticListMap[key] = currentLocationCoords;

    PanelExtensions.of().checkInputLocation(controller, editDockTextEditController,  dockList,-1);
  }

  ///Builds the static row of components which are displayed permanently. Statically built, as every journey
  ///needs to specify a starting point. [controller] is the TextField used to input and display the destination the user is
  ///to start their journey from. [hintText] is the text to describe the purpose of each TextField to the user.
  Widget _buildStatic(TextEditingController controller,
      {String? hintText,
        required BuildContext context,
      required String label,
      required Function(List<double?>) onAddressAdded}) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 50,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    )),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        widget.handleOnSearchClick(context, controller, onAddressAdded);
                      },
                      onEditingComplete: () {
                        PanelExtensions.of(context:context).checkInputLocation(controller, editDockTextEditController,   dockList,-1);
                      },
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hintText,
                        focusedBorder: circularInputBorder(width: 2.0),
                        border: circularInputBorder(),
                        enabledBorder: circularInputBorder(),
                        disabledBorder: circularInputBorder(),
                        errorBorder: circularInputBorder(),
                        focusedErrorBorder: circularInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _useCurrentLocationButtonHandler(controller, label);
                          },
                          icon: const Icon(
                            Icons.my_location,
                            size: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        PanelExtensions.of(context: context).buildDefaultClosestDock(editDockTextEditController,
            controller,  dockList,),
      ],
    );
  }

  ///Given a coordinate, [newCord], it sets the 'From' location as the place specified by the coordinates passed in
  void addCordFrom(List<double?> newCord) {
    staticListMap[fromLabelKey] = newCord;
    final ext = PanelExtensions.of(context:context);
    //ext.setPosition(position);
    ext.getClosetDock(newCord[0],
        newCord[1], editDockTextEditController,  dockList, -1);
  }

  ///Given a coordinate, [newCord], it sets the 'To' location as the place specified by the coordinates passed in
  void addCordTo(List<double?> newCord) {
    staticListMap[toLabelKey] = newCord;
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

      final newLatLng = widget.dockList[newIndex];
      final oldCordList = widget.dockList[oldIndex];

      if(newLatLng != null && oldCordList != null){
        widget.dockList[oldIndex] = newLatLng;
        widget.dockList[newIndex] = oldCordList;
      }
      print("dockList keys => ${widget.dockList.keys}");

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              "Explore London",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 35),
            ),
          ),
          const SizedBox(height: 8),
          _buildStatic(widget.fromTextEditController,
              hintText: "Where from?",
              label: "From",
              context: context,
              onAddressAdded: addCordFrom),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('TO'),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  StreamBuilder<List<DynamicWidget>>(
                    builder: (_, snapshot) {
                      List<DynamicWidget> listOfDynamics = snapshot.data ?? [];

                      return SizedBox(
                        width: 300,
                        child: ReorderableListView.builder( //user can reorder the listItems
                          itemExtent: 74,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            final dynamicWidget = listOfDynamics[index];
                            dynamicWidget.position = index;
                            dynamicWidget.removeDynamic((p0) {
                              widget.listDynamic.removeAt(index);
                              widget.dynamicWidgets.sink.add(widget.listDynamic);
                            });
                            return Container(
                                    key: ValueKey(index),
                                    child:
                                        dynamicWidget);
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
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
          //The default is a + icon
          buildFloatingActionButton(onPressed: addDynamic),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                primary: Colors.white,
              ),
              onPressed: _handleStartClick,
              child: text("START"),
            ),
          ),
        ],
      ),
    );
  }

  ///The function to deal with the user pressing the START button. Applies the constraints for a journey.
  ///For all the coordinates of the locations the user specified, creates a new list - this new list is a list of all the
  ///closest docking stations for the locations the user specified. This new list is then passed onto MapRoutePage.
  ///THIS FUNCTION NEEDS TO BE REFACTORED FURTHER
  void _handleStartClick(){
    List<LatLng> closestDockList = dockList.values.toList();
    print("ALREADY EXISTS ==> $closestDockList");

    final hasEmptyField = widget.listDynamic
        .any((element) => element.placeTextController.text.isEmpty);

    applyConstraints(
        widget.fromTextEditController, widget.toTextEditController);

    if (hasEmptyField) {
      alert.showSnackBarErrorMessage(context, alert.cannotHaveEmptySearchLocationsMessage);
      return;
    } else if (areAdjacentCoords(widget.selectedCoords)) {
      alert.showSnackBarErrorMessage(context, alert.noAdjacentLocationsAllowed);
      return;
    } else {
      List<List<double?>?> tempList = [];
      tempList.addAll(staticListMap.values);
      tempList.addAll(widget.selectedCoords);
      print("ALL_COORDINATES => $tempList");
      List<LatLng>? points = convertListDoubleToLatLng(tempList);


      ///REMOVE THIS TO USE EDIT DOCK CONTROLLERS - DO NOT RECALCULATE IT /////////////////////////////////////////
      List<LatLng> closestDockList = dockList.values.toList();
      print("ALREADY EXISTS ==> $closestDockList");
      
      List<LatLng> closestDocksWithNoAdjancents = [];
      for(int i=0; i < closestDockList.length - 1; i++){
        if(closestDockList[i].latitude == closestDockList[i+1].latitude && closestDockList[i].longitude == closestDockList[i+1].longitude){
          if(closestDocksWithNoAdjancents.contains(closestDockList[i])){
            print("ALREADY EXISTS");
          }
          else{
            closestDocksWithNoAdjancents.add(closestDockList[i]);
          }
        }
      }
      print("CLOSESTDOCKS WITH NO ADJACENTS");
      print(closestDocksWithNoAdjancents);

      print("CLOSESTDOCKLIST");
      print(closestDockList);

      if(closestDocksWithNoAdjancents.length == 1){
        alert.showSnackBarErrorMessage(context, alert.adjacentClosestDocksMessage);
        return;
      }

      if (points == null) {
        //! show something went wrong allert
        print("hello");
      } else {
        context.push(MapRoutePage(closestDockList));
      }
    }
  }

  ///Applies all the constraints needed for the panel widget. If any constraints are broken, program execution terminates
  ///and  displays necessary error message to the user. [fromEditingController] and the [toEditingController] are the
  ///controllers where the user specifies the destination to start their journey from and where to go respectively.
  void applyConstraints(TextEditingController fromEditingController,
      TextEditingController toEditingController) {
    if (startLocationMustBeSpecified(fromEditingController) ||
        startLocationMustBeSpecified(toEditingController)) {
      return;
    }

    if (widget.hasSpecifiedOneDestination( context, alert)) {
      return;
    }

    if (aSearchBarCannotBeEmpty(widget.listDynamic)) {
      return;
    }
  }

  ///The logic to restrict the user from being able to start a journey with 2 locations in the journey being
  ///one after the other. [myList] is the list of coordinates for the journey, produced from the destinations
  ///the user selects to visit.
  bool areAdjacentCoords(List<List<double?>?> myList) {
    if(myList.isEmpty){
      return true;
    }
    for (int i = 0; i < myList.length - 1; i++) {
      if (myList[i]?.first == myList[i + 1]?.first &&
          myList[i]?.last == myList[i + 1]?.last) {
        print("Adjacents exist");
        return true;
      }
    }
    if (myList[0]?.first == staticListMap[fromLabelKey]?.first &&
        myList[0]?.last == staticListMap[fromLabelKey]?.last) {
      print("Adjacents exist2");
      return true;
    }
    print("Adjacents do not exist");
    return false;
  }

  ///The logic to restrict the user from being able to start a journey, with blank location fields. [list] is the list of
  ///dynamic widgets, where the user has inputted the destinations they wish to visit on their trip.
  bool aSearchBarCannotBeEmpty(List<DynamicWidget>? list) {
    bool isFieldNotEmpty = true;
    if (list == null) {
      alert.showSnackBarErrorMessage(context, alert.cannotHaveEmptySearchLocationsMessage);
      return false;
    }
    for (var element in list) {
      if (element.placeTextController.text.isEmpty) {
        isFieldNotEmpty = false;
        return true; //true if there is a textfield that is empty
      }
    }
    if (!isFieldNotEmpty) {
      alert.showSnackBarErrorMessage(context, alert.cannotHaveEmptySearchLocationsMessage);
      return false;
    }
    return false;
  }

  ///The logic to restrict the user from being able to start a journey without a starting point in the
  ///[textEditingController].
  bool startLocationMustBeSpecified(
      TextEditingController textEditingController) {
    if (widget.fromTextEditController.text.isEmpty) {
      alert.showSnackBarErrorMessage(context, alert.startPointMustBeDefinedMessage);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }

}

