import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import '../main.dart';
import '../providers/location_service.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/alerts.dart';

/*
When rendered, the journey_planner_screen will have this panel_widget at the bottom. It is an interactive panel the user can
slide up or down, when wanting to input their desired locations for the journey.
 */
extension BuildContextExt on BuildContext {
  Future<dynamic> openSearch() {
    return Navigator.of(this).push(MaterialPageRoute(
        builder: (settings) =>
            PlaceSearchScreen(LocationService(), isPop: true)));
  }
}

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  final StreamController<List<DynamicWidget>> dynamicWidgets;
  final List<DynamicWidget> listDynamic;
  final List<List<double?>?> selectedCords;
  final TextEditingController textEditingController;
  final Stream<MapPlace> address;
  final Map<String, List<double?>> selectionMap;

  const PanelWidget(
      {required this.selectionMap,
      required this.address,
      required this.controller,
      required this.dynamicWidgets,
      required this.listDynamic,
      required this.selectedCords,
      required this.textEditingController,
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
  List<double?>? staticList;
  final Alerts alert = Alerts();

  //creates a new dynamic widget and adds this to the list of destinations for the journey
  addDynamic() {
    widget.listDynamic.add(DynamicWidget(
      selectedCords: widget.selectedCords,
    ));
    widget.dynamicWidgets.sink.add(widget.listDynamic);
  }

  //Initialises variables and listens for user interaction to act on
  @override
  void initState() {
    final selectedCords = widget.selectedCords;
    selectionMap = widget.selectionMap;
    widget.address.listen((event) {
      final dynamicWidget = DynamicWidget(selectedCords: selectedCords);
      dynamicWidget.textController.text = event.address ?? "";
      dynamicWidget.position = widget.listDynamic.length;
      widget.listDynamic.add(dynamicWidget);
      print("pos: ${dynamicWidget.position}");
      selectedCords.insert(dynamicWidget.position,
          [event.cords?.latitude, event.cords?.longitude]);
      widget.dynamicWidgets.sink.add(widget.listDynamic);
    });
    super.initState();
  }

  //When called, this function sets the first location of the journey to the users current location
  _useCurrentLocationButtonHandler() async {
    LatLng currentLocation = getLatLngFromSharedPrefs();
    var response = await locService.reverseGeoCode(
        currentLocation.latitude, currentLocation.longitude);
    sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    double latitudeOfPlace = response['location'].latitude;
    double longitudeOfPlace = response['location'].longitude;
    List<double?> currentLocationCoords = [latitudeOfPlace, longitudeOfPlace];
    widget.textEditingController.text = place;
    staticList = currentLocationCoords;
  }

  /*
  Function which builds the static row of components which are displayed permanently. Statically built, as every journey
  needs to specify a starting point
  */
  Widget _buildStatic() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        children: [
          const Text("From: ",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20,
              )),
          const SizedBox(width: 20),
          Expanded(
            child: SizedBox(
              child: TextField(
                readOnly: true,
                onTap: () {
                  _handleSearchClick(context);
                },
                controller: widget.textEditingController,
                decoration: InputDecoration(
                  hintText: 'Where from?',
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      _useCurrentLocationButtonHandler();
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
            onPressed: () {
              print("Link carasoul stuff here");
            },
            child: const Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 50,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller,
      children: <Widget>[
        buildDragHandle(),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            "Explore London",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 35),
          ),
        ),
        _buildStatic(),
        Column(
          children: [
            StreamBuilder<List<DynamicWidget>>(
              builder: (_, snapshot) {
                List<DynamicWidget> listOfDynamics = snapshot.data ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    final dynamicWidget = listOfDynamics[index];
                    dynamicWidget.position = index;
                    dynamicWidget.removeDynamic((p0) {
                      widget.listDynamic.removeAt(index);
                      widget.dynamicWidgets.sink.add(widget.listDynamic);
                    });
                    return dynamicWidget;
                  },
                  itemCount: listOfDynamics.length,
                  physics: const NeverScrollableScrollPhysics(),
                );
              },
              stream: dynamicWidgetsStream,
            ),
            const SizedBox(
              height: 50,
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
              const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              primary: Colors.white,
            ),
            onPressed: () {
              startLocationMustBeSpecified();
              oneDestinationMustBeSpecified();
              aSearchBarCannotBeEmpty(widget.listDynamic);

              List<List<double?>?> tempList = [];
              if (staticList != null) {
                tempList.add(staticList);
                tempList.addAll(widget.selectedCords);
                print("ALL_COORDINATES => $tempList");
              } else {
                print("ALL_COORDINATES => $tempList");
              }
            },
            child: const Text(
              "START",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  //Returns all the coordinates for the locations the user specifies
  List<List<double?>?> getCoordinatesForJourney() {
    return widget.selectedCords;
  }

  //The logic to restrict the user from being able to start a journey, with blank location fields
  void aSearchBarCannotBeEmpty(List<DynamicWidget>? list) {
    bool isFieldNotEmpty = true;
    if (list == null) {
      alert.showWhereToTextFieldsMustNotBeEmptySnackBar(context);
      return;
    }
    for (var element in list) {
      if (element.textController.text.isEmpty) {
        isFieldNotEmpty = false;
        break;
      }
    }
    if (!isFieldNotEmpty) {
      alert.showWhereToTextFieldsMustNotBeEmptySnackBar(context);
    }
  }

  //The logic to restrict the user from being able to start a journey without a starting point
  void startLocationMustBeSpecified() {
    if (widget.textEditingController.text.isEmpty) {
      alert.showStartLocationMustNotBeEmptySnackBar(context);
    }
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

  void _handleSearchClick(BuildContext context) async {
    final selectedCords = widget.selectedCords;
    final tempPosition = selectedCords.length;
    final result = await context.openSearch();
    print("Navigator_Navigator_Navigator => $tempPosition");
    final feature = result as Feature?;
    if (feature != null) {
      widget.textEditingController.text = feature.placeName ?? "N/A";

      staticList = feature.geometry?.coordinates;
    }
  }

  //The logic to restrict the user from being able to start a journey without defining at least one destination for the journey
  void oneDestinationMustBeSpecified() {
    if (widget.listDynamic.isEmpty) {
      alert.showAtLeastOneDestinationSnackBar(context);
    }
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
  late TextEditingController textController = TextEditingController();
  List<List<double?>?>? selectedCords;
  Function(int)? onDelete;
  int position = -1;

  //setter for the position index
  void setIndex(index) {
    position = index;
  }

  DynamicWidget({Key? key, required this.selectedCords}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: double.maxFinite,
      //height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 33),
          //Expanded(
          TextButton(
            onPressed: () {
              int len = selectedCords?.length ?? 0;
              if (position < len) {
                selectedCords?.removeAt(position);
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
            child: TextField(
              readOnly: true,
              onTap: () {
                _handleSearchClick(context, position);
              },
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Where to?',
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
              ),
            ),
          ),
          //Expanded(
          TextButton(
            onPressed: () {
              print("Link carasoul stuff here");
            },
            child: const Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 50,
              color: Colors.green,
            ),
          ),
          //),
        ],
      ),
    );
  }

  //Executed when the user presses on a search TextField
  void _handleSearchClick(BuildContext context, int position) async {
    final result = await context.openSearch();
    print("Navigator_Navigator_Navigator => $position");
    final feature = result as Feature?;
    if (feature != null) {
      final len = selectedCords?.length ?? 0;
      textController.text = feature.placeName ?? "N/A";

      if (position > ((selectedCords?.length) ?? 0) - 1 ||
          (selectedCords?.isEmpty ?? true)) {
        selectedCords?.add(feature.geometry?.coordinates);
      } else {
        selectedCords?[position] = feature.geometry?.coordinates;
      }
    }
    print("RESULT => $result");
  }

  void removeDynamic(Function(int) onDelete) {
    this.onDelete = onDelete;
  }
}
