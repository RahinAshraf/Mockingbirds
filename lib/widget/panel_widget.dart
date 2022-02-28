import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import '../main.dart';
import '../models/destination_choice.dart';
import '../screens/location_service.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

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

  addDynamic() {
    widget.listDynamic.add(DynamicWidget(
      selectedCords: widget.selectedCords,
    ));

    widget.dynamicWidgets.sink.add(widget.listDynamic);
  }


  @override
  void initState() {
   // position = -1;
    final selectedCords = widget.selectedCords;
    selectionMap = widget.selectionMap;
    widget.address.listen((event) {
      final dynamicWidget = DynamicWidget(selectedCords: selectedCords);
      dynamicWidget.textController.text = event.address ?? "";
      dynamicWidget.position =  widget.listDynamic.length;
      widget.listDynamic.add(dynamicWidget);
      print("pos: ${dynamicWidget.position}");
      selectedCords
          .insert(dynamicWidget.position, [event.cords?.latitude, event.cords?.longitude]);
      widget.dynamicWidgets.sink.add(widget.listDynamic);
    });
    super.initState();
  }

  // //FUNCTION NEEDS TO BE CALLED
  // void setLiveLocationInListAsFirstByDefault(){
  //   print("HERE");
  //   if(widget.textEditingController.text.isEmpty){
  //     List<double> liveLocCoords =  [];
  //     liveLocCoords.add(getLatLngFromSharedPrefs().latitude);
  //     liveLocCoords.add(getLatLngFromSharedPrefs().longitude);
  //
  //     widget.selectedCords?.insert(0, liveLocCoords);
  //   }
  // }

  _useCurrentLocationButtonHandler() async {
    print("HELLO");
    LatLng currentLocation = getLatLngFromSharedPrefs();
    var response = await locService.reverseGeoCode(
        currentLocation.latitude, currentLocation.longitude);
    sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    double LatitudeOfPlace = response['location'].latitude;
    double LongitudeOfPlace = response['location'].longitude;
    List<double?> currentLocationCoords = [LatitudeOfPlace, LongitudeOfPlace];
    widget.textEditingController.text = place;
    widget.selectedCords.insert(0, currentLocationCoords);
    print(widget.selectedCords);
  }

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
                onTap: (){
                  _handleSearchClick(context);
                },
                controller: widget.textEditingController,
                //enabled: true,
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
                  // suffixIcon: IconButton(
                  //   padding: EdgeInsets.zero,
                  //   //onPressed: _useCurrentLocationButtonHandler,
                  //   onPressed: () {
                  //     print("LIL Mosey");
                  //     //_useCurrentLocationButtonHandler();
                  //   },
                  //   icon: const Icon(
                  //     Icons.search,
                  //     size: 25,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  suffixIcon: IconButton(
                    //onPressed: _useCurrentLocationButtonHandler,
                    onPressed: () {
                      print("SUFFIX ICON");
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
    //widget. listDynamic.add(DynamicWidget(selectedCords: widget.selectedCords,));

    return ListView(
      controller: widget.controller,
      //padding: EdgeInsets.only(left:20, bottom: 20, right: 20),
      children: <Widget>[
        //const SizedBox(height: 12),
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

                /*

    widget.listDynamic.removeAt(index);
    widget.selectedCords.removeAt(index);
    widget.dynamicWidgets.sink.add(widget.listDynamic);
                 */

                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_, index){
                    final dynamicWidget = listOfDynamics[index];
                    dynamicWidget.position = index;
                    dynamicWidget.removeDynamic((p0) {
                      widget.listDynamic.removeAt(index);
                    //  widget.selectedCords.removeAt(index);
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
            const SizedBox(height: 50,),
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
              if (widget.listDynamic.isEmpty) {
                showAtLeastOneDestinationSnackBar(context);
              }
              // for(int i =0; i<=widget.selectedCords.length;i++){
              //   if(widget.selectedCords[i] == []){
              //     showWhereToTextFieldsMustNotBeEmptySnackBar(context);
              //   }
              // }

              // if(widget.selectedCords.isNotEmpty) {
              //   widget.selectedCords.removeAt(0);
              //   widget.selectedCords.insert(0, staticList);
              // }
              print("WE");
              print(widget.listDynamic.length);
              print("OUR");
              print(widget.selectedCords.length);
              
              List<List<double?>?> tempList = [];

              if(staticList != null){
                tempList.add(staticList);
                tempList.addAll(widget.selectedCords);

                print("ALL_COORDINATES => $tempList");



                getCoordinatesForJourney();
                aSearchBarCannotBeEmpty();
                startLocationMustBeSpecified();
              }else{
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

  void aSearchBarCannotBeEmpty(){
    if(widget.listDynamic.length > widget.selectedCords.length){
      showWhereToTextFieldsMustNotBeEmptySnackBar(context);
    }
  }

  void startLocationMustBeSpecified(){
    if(widget.textEditingController.text.isEmpty){
      showStartLocationMustNotBeEmptySnackBar(context);
    }
  }

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

  void showAtLeastOneDestinationSnackBar(BuildContext context) {
    const text = "Choose at least one destination to create your journey";
    const snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //position = -1;
    super.dispose();
  }

  void showWhereToTextFieldsMustNotBeEmptySnackBar(BuildContext context) {
    const text =
        "Please specify locations for all destinations of the journey. Otherwise, remove any empty choices";
    const snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showStartLocationMustNotBeEmptySnackBar(BuildContext context) {
    const text =
        "Please specify the starting location of the journey";
    const snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleSearchClick(BuildContext context) async {
    final selectedCords = widget.selectedCords;
    final tempPosition = selectedCords.length;
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (settings) => PlaceSearchScreen(LocationService())));
    print("Navigator_Navigator_Navigator => $tempPosition");
    final feature = result as Feature?;
    if (feature != null) {
      widget.textEditingController.text = feature.placeName ?? "N/A";

      staticList = feature.geometry?.coordinates;
    }
  }

//void togglePanel() => panelController.isPanelOpen ? panelController.close() : panelController.open();
}


class DynamicWidget extends StatelessWidget {
  late TextEditingController textController = TextEditingController();
  List<List<double?>?>? selectedCords;

  Function(int)? onDelete;


  int position = -1;

  void setIndex(index){
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
              selectedCords?.removeAt(position);
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
                print("SUIIIIII");
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

  void _handleSearchClick(BuildContext context, int position) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (settings) => PlaceSearchScreen(LocationService())));
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

  /*

    widget.listDynamic.removeAt(index);
    widget.selectedCords.removeAt(index);
    widget.dynamicWidgets.sink.add(widget.listDynamic);
   */
}
