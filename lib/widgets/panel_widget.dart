import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/screens/navigation/map_with_route_screen.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversion_helpers.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/alerts.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/screens/dock_sorter_screen.dart';

/*
When rendered, the journey_planner_screen will have this panel_widget at the bottom. It is an interactive panel the user can
slide up or down, when wanting to input their desired locations for the journey.

@author - Rahin Ashraf
 */

extension BuildContextExt on BuildContext {
  Future<dynamic> openSearch() {
    return Navigator.of(this).push(MaterialPageRoute(
        builder: (settings) =>
            PlaceSearchScreen(LocationService(), isPop: true)));
  }
}

class PanelWidget extends StatefulWidget {
  final ScrollController scrollController;
  final PanelController panelController;
  final StreamController<List<DynamicWidget>> dynamicWidgets;
  final List<DynamicWidget> listDynamic;
  final List<List<double?>?> selectedCoords;
  final TextEditingController fromTextEditController;
  final TextEditingController toTextEditController;
  final Stream<MapPlace> address;
  final Map<String, List<double?>> selectionMap;
  final Map<String, List<double?>> staticListMap;

  const PanelWidget(
      {required this.selectionMap,
      required this.address,
      required this.scrollController,
      required this.dynamicWidgets,
      required this.listDynamic,
      required this.selectedCoords,
      required this.staticListMap,
      required this.toTextEditController,
      required this.fromTextEditController,
      required this.panelController,
      Key? key})
      : super(key: key);

  @override
  PanelWidgetState createState() {
    return PanelWidgetState();
  }
}

class PanelWidgetState extends State<PanelWidget> {
  Stream<List<DynamicWidget>> get dynamicWidgetsStream =>
      widget.dynamicWidgets.stream;
  final locService = LocationService();
  late Map<String, List<double?>> selectionMap;
  late TextEditingController firstTextEditingController =
      TextEditingController();
  late Map<String, List<double?>> staticListMap;
  late Map response;
  late List<DockingStation> dockingStationList;
  final dockingStationManager _stationManager = dockingStationManager();

  static const String fromLabelKey = "From";
  static const String toLabelKey = "To";

  final Alerts alert = Alerts();

  //creates a new dynamic widget and adds this to the list of destinations for the journey
  addDynamic() {
    widget.listDynamic.add(DynamicWidget(
      selectedCoords: widget.selectedCoords,
      coordDataMap: response,
    ));
    widget.dynamicWidgets.sink.add(widget.listDynamic);
  }

  // void importDockStation() async {
  //   await _stationManager.importStations();
  // }

  void importDockStation() async {
    await _stationManager.importStations();
    print(_stationManager.stations.length.toString() +
        "this is the length of the stationManager");
  }

  //Initialises variables and listens for user interaction to act on
  @override
  void initState() {
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

  void _listToMapClick() {
    final selectedCoords = widget.selectedCoords;

    widget.address.listen((event) {
      final dynamicWidget = DynamicWidget(
        selectedCoords: selectedCoords,
        coordDataMap: response,
      );

      final list = widget.listDynamic;
      if (list.any((element) => element.placeTextController.text.isEmpty)) {
        alert.showWhereToTextFieldsMustNotBeEmptySnackBar(context);
        return;
      }

      dynamicWidget.placeTextController.text = event.address ?? "";
      dynamicWidget.checkInputLocation();
      dynamicWidget.position = widget.listDynamic.length;
      widget.listDynamic.add(dynamicWidget);
      print(
          "DynamicWidget_pos: ${dynamicWidget.position} ${selectedCoords.length} _${widget.listDynamic.length}");

      if (dynamicWidget.position > selectedCoords.length) {
        selectedCoords.add([event.coords?.latitude, event.coords?.longitude]);
      } else {
        selectedCoords.insert(dynamicWidget.position,
            [event.coords?.latitude, event.coords?.longitude]);
      }
      widget.dynamicWidgets.sink.add(widget.listDynamic);
    });
  }

  //When called, this function sets the first location of the journey to the users current location
  _useCurrentLocationButtonHandler(
      TextEditingController controller, String key) async {
    sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    double latitudeOfPlace = response['location'].latitude;
    double longitudeOfPlace = response['location'].longitude;
    List<double?> currentLocationCoords = [latitudeOfPlace, longitudeOfPlace];
    controller.text = place;
    staticListMap[key] = currentLocationCoords;
    // TODO: W
  }

  /*
  Function which builds the static row of components which are displayed permanently. Statically built, as every journey
  needs to specify a starting point
  */
  Widget _buildStatic(TextEditingController controller,
      {String? hintText,
      required String label,
      required Function(List<double?>) onAddressAdded}) {
    // widget.textEditingController
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Container(
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
          child: SizedBox(
            child: TextField(
              readOnly: true,
              onTap: () {
                _handleSearchClick(context, controller, onAddressAdded);
              },
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
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
        ),
        //SizedBox(width: 10),
        TextButton(
          onPressed: () async {
            print("Link carasoul stuff here");
            // List temp = await locService.getPlaceCoords(controller.text);
            // print(temp);
          },
          child: const Icon(
            Icons.keyboard_arrow_right_rounded,
            size: 50,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  void addCordFrom(List<double?> newCord) {
    staticListMap[fromLabelKey] = newCord;
  }

  void addCordTo(List<double?> newCord) {
    staticListMap[toLabelKey] = newCord;
  }

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
          //buildDragHandle(),
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
              onAddressAdded: addCordFrom),
          // _buildStatic(widget.toTextEditController,
          //     hintText: "Where to?", label: "To", onAddressAdded: addCordTo),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<List<DynamicWidget>>(
                builder: (_, snapshot) {
                  List<DynamicWidget> listOfDynamics = snapshot.data ?? [];

                  return ReorderableListView.builder(
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
                      return //ListTile(key: ValueKey(index), leading:
                          Container(
                              key: ValueKey(index),
                              child:
                                  dynamicWidget); //, trailing: Icon(Icons.menu),);
                    },
                    itemCount: listOfDynamics.length,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        _updateItems(oldIndex, newIndex);
                      });
                    },
                  );
                },
                stream: dynamicWidgetsStream,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          FloatingActionButton(
            onPressed: addDynamic,
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                primary: Colors.white,
              ),
              onPressed: () {
                final hasEmptyField = widget.listDynamic
                    .any((element) => element.placeTextController.text.isEmpty);

                applyConstraints(
                    widget.fromTextEditController, widget.toTextEditController);

                if (hasEmptyField) {
                  alert.showWhereToTextFieldsMustNotBeEmptySnackBar(context);
                  //return;
                } else if (areAdjacentCoords(widget.selectedCoords)) {
                  alert.showCantHaveAdjacentSnackBar(context);
                  //return;
                } else {
                  List<List<double?>?> tempList = [];
                  tempList.addAll(staticListMap.values);
                  tempList.addAll(widget.selectedCoords);
                  print("ALL_COORDINATES => $tempList");
                  List<LatLng>? points = convertListDoubleToLatLng(tempList);
                  if (points == null) {
                    //! show something went wrong allert
                    print("hello");
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapRoutePage(points)),
                    );
                  }
                }
              },
              child: const Text(
                "START",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void applyConstraints(TextEditingController fromEditingController,
      TextEditingController toEditingController) {
    if (startLocationMustBeSpecified(fromEditingController) ||
        startLocationMustBeSpecified(toEditingController)) {
      return;
    }

    if (oneDestinationMustBeSpecified()) {
      return;
    }

    if (aSearchBarCannotBeEmpty(widget.listDynamic)) {
      return;
    }
  }

  //Returns all the coordinates for the locations the user specifies
  List<List<double?>?> getCoordinatesForJourney() {
    return widget.selectedCoords;
  }

  bool areAdjacentCoords(List<List<double?>?> myList) {
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

  //The logic to restrict the user from being able to start a journey, with blank location fields
  bool aSearchBarCannotBeEmpty(List<DynamicWidget>? list) {
    bool isFieldNotEmpty = true;
    if (list == null) {
      alert.showWhereToTextFieldsMustNotBeEmptySnackBar(context);
      return false;
    }
    for (var element in list) {
      if (element.placeTextController.text.isEmpty) {
        isFieldNotEmpty = false;
        return true; //true if there is a textfield that is empty
      }
    }
    if (!isFieldNotEmpty) {
      alert.showWhereToTextFieldsMustNotBeEmptySnackBar(context);
      return false;
    }
    return false;
  }

  //The logic to restrict the user from being able to start a journey without a starting point
  bool startLocationMustBeSpecified(
      TextEditingController textEditingController) {
    if (widget.fromTextEditController.text.isEmpty) {
      alert.showStartLocationMustNotBeEmptySnackBar(context);
      return true;
    }
    return false;
  }

  //The grey handle bar, displayed at the very top of the panel_widget, to display to the user to swipe up on the panel
  Widget buildDragHandle() => GestureDetector(
        child: Center(
          child: Container(
            height: 5,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        //onTap: togglePanel,
      );

  @override
  void dispose() {
    super.dispose();
  }

  //When triggered, redirects the user to the place_search_Screen in order for them to specify a location to visit
  //for the journey

  void _handleSearchClick(
      BuildContext context,
      TextEditingController textEditingController,
      Function(List<double?>) onAddressAdded) async {
    final selectedCoords = widget.selectedCoords;
    final tempPosition = selectedCoords.length;
    final result = await context.openSearch();
    print("Navigator_Navigator_Navigator => $tempPosition");
    final feature = result as Feature?;
    if (feature != null) {
      textEditingController.text = feature.placeName ?? "N/A";
      final featureCord = feature.geometry?.coordinates;
      if (featureCord != null) {
        onAddressAdded.call(featureCord);
      }
      // staticList = feature.geometry?.coordinates;
    }
  }

  //The logic to restrict the user from being able to start a journey without defining at least one destination for the journey
  bool oneDestinationMustBeSpecified() {
    if (widget.listDynamic.isEmpty) {
      alert.showAtLeastOneDestinationSnackBar(context);
      return true;
    }
    return false;
  }

//void togglePanel() => panelController.isPanelOpen ? panelController.close() : panelController.open();
}

/*
 The widgets the user dynamically creates during runtime, for them to specify the locations of the journey.
 Each dynamic widget is a row which comes with a row of children:
    - red cross, to delete a location from the journey planner list
    - TextField , to insert a location to the journey planner list
    - green > icon, to allow users to specify specific docks (if they wish) of the locations user specifies in the TextField
 */
class DynamicWidget extends StatelessWidget {
  final TextEditingController placeTextController = TextEditingController();
  final TextEditingController editDockTextEditController =
      TextEditingController();
  List<List<double?>?>? selectedCoords;
  Function(int)? onDelete;
  int position = -1;
  final locationService = LocationService();
  final Map? coordDataMap;
  // final dockingStationManager _stationManager = dockingStationManager();

  //setter for the position index
  void setIndex(index) {
    position = index;
  }

  @override
  void initState() {
    //importDockStation();
    placeTextController.addListener(() {
      checkInputLocation();
    });
  }

  // void importDockStation() async {
  //   await _stationManager.importStations();
  //   print(_stationManager.stations.length.toString() + "this is the length of the stationManager");
  // }

  DynamicWidget({Key? key, required this.selectedCoords, this.coordDataMap})
      : super(key: key);

  void checkInputLocation() async {
    print("THIS IS CLOSET DOCK");
    if (placeTextController.text.isEmpty) {
      print("Nothing specified");
    } else {
      print("REACHED METHOD GETCLOSETDOCK");
      List coordPlace = await locationService.getPlaceCoords(
          placeTextController.text); //getting coord of the place [lat,lng]
      getClosetDock(coordPlace.first, coordPlace.last);
      //TO-DO
      // - change to get closet dock with available bikes after getting num of cyclist
    }
  }

  void getClosetDock(double? lat, double? lng) async {
    // List coordPlace = await locationService.getPlaceCoords(placeTextController.text); //getting coord of the place [lat,lng]
    LatLng latlngPlace = LatLng(lat!, lng!); //coverting list to latlng
    dockingStationManager _stationManager = dockingStationManager();
    await _stationManager.importStations();
    print(latlngPlace);
    DockingStation closetDock = _stationManager.getClosestDock(latlngPlace);
    print("closet dock ${closetDock.name}");
    editDockTextEditController.text = closetDock.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //const SizedBox(height: 17),
              //Expanded(
              TextButton(
                onPressed: () {
                  int len = selectedCoords?.length ?? 0;
                  if (position < len) {
                    selectedCoords?.removeAt(position);
                  }
                  onDelete?.call(position);
                },
                child: const Icon(
                  Icons.close_outlined,
                  size: 35,
                  color: Colors.red,
                ),
              ),
              //),
              Expanded(
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    // onChanged: (placeTextController) { //called when you type
                    //   print("ONCHANGED");
                    //   checkInputLocation();
                    // },
                    onEditingComplete: () {
                      print("ONCHANGED");
                      checkInputLocation();
                    },
                    readOnly: true,
                    onTap: () {
                      _handleSearchClick(context, position);
                    },
                    controller: placeTextController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (coordDataMap == null) return;
                          _useCurrentLocationButtonHandler(
                              coordDataMap!, placeTextController);
                        },
                        icon: const Icon(
                          Icons.my_location,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      suffixIconColor: Colors.blue,
                      hintText: 'Where to?',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
              Icon(Icons.menu),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.subdirectory_arrow_right),
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(),
            //       borderRadius: BorderRadius.circular(20)),
            //   child: Text("Default closest dock"),
            // ),
            Expanded(
              child: TextField(
                enabled: false,
                controller: editDockTextEditController,
                decoration: InputDecoration(
                  hintText: "Default closest dock",
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  List temp = await locationService
                      .getPlaceCoords(placeTextController.text);
                  checkInputLocation();
                  LatLng locationInLatLng = LatLng(temp.first, temp.last);
                  print(locationInLatLng);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DockSorterScreen(locationInLatLng)));
                },
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.navigate_next_outlined,
                )),
          ],
        ),
      ],
    );
  }

  //Executed when the user presses on a search TextField
  void _handleSearchClick(BuildContext context, int position) async {
    final result = await context.openSearch();
    print("Navigator_Navigator_Navigator => $position");
    final feature = result as Feature?;
    if (feature != null) {
      final len = selectedCoords?.length ?? 0;
      placeTextController.text = feature.placeName ?? "N/A";

      if (position > ((selectedCoords?.length) ?? 0) - 1 ||
          (selectedCoords?.isEmpty ?? true)) {
        selectedCoords?.add(feature.geometry?.coordinates);
      } else {
        selectedCoords?[position] = feature.geometry?.coordinates;
      }
      getClosetDock(feature.geometry?.coordinates.first,
          feature.geometry?.coordinates.last);
    }
    print("RESULT => $result");
  }

  void removeDynamic(Function(int) onDelete) {
    this.onDelete = onDelete;
  }

  //When called, this function sets the first location of the journey to the users current location
  _useCurrentLocationButtonHandler(
      Map response, TextEditingController controller) async {
    sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    double latitudeOfPlace = response['location'].latitude;
    double longitudeOfPlace = response['location'].longitude;
    List<double?> currentLocationCoords = [latitudeOfPlace, longitudeOfPlace];
    controller.text = place;

    checkInputLocation();

    if (position > ((selectedCoords?.length) ?? 0) - 1 ||
        (selectedCoords?.isEmpty ?? true)) {
      selectedCoords?.add(currentLocationCoords);
    } else {
      selectedCoords?[position] = currentLocationCoords;
    }
  }
}
