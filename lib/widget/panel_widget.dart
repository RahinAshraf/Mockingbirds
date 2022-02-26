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
      {
        required this.selectionMap,
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

  addDynamic() {
    widget.listDynamic.add(DynamicWidget(
      selectedCords: widget.selectedCords,
    ));


    widget.dynamicWidgets.sink.add(widget.listDynamic);
  }

  @override void initState(){
    position = -1;
    final selectedCords =  widget.selectedCords;

    selectionMap = widget.selectionMap;
    widget.address.listen((event) {

      final dynamicWidget = DynamicWidget(
          selectedCords:selectedCords
      );

      dynamicWidget.textController.text = event.address ??"";
      widget.listDynamic.add(dynamicWidget);
      print("pos: $position");


      selectedCords.insert(position,  [event.cords?.latitude,  event.cords?.longitude]);

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
    var response = await locService.reverseGeoCode(currentLocation.latitude,currentLocation.longitude);
    sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    double LatitudeOfPlace = response['location'].latitude;
    double LongitudeOfPlace = response['location'].longitude;
    List<double?> currentLocationCoords = [LatitudeOfPlace,LongitudeOfPlace];
    widget.selectedCords.insert(0, currentLocationCoords);
    widget.textEditingController.text = place;
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
                controller: widget.textEditingController,
                enabled: false,
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
                    suffixIcon: TextButton(
                        onPressed: _useCurrentLocationButtonHandler,
                        //padding: const EdgeInsets.all(10),
                        //constraints: const BoxConstraints(),
                        child:const Icon(Icons.my_location, size: 20, color: Colors.blue,),) ,
                    ),
                  ),
                ),
              ),
          //SizedBox(width: 10),
          TextButton(
            onPressed: () {
              _handleSearchClick(context);
              print("Take me to the place search screen");
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
        const SizedBox(height: 12),
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
                  itemBuilder: (_, index) => listOfDynamics[index],
                  itemCount: listOfDynamics.length,
                  physics: const NeverScrollableScrollPhysics(),
                );
              },
              stream: dynamicWidgetsStream,
            )
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
              if(widget.listDynamic.isEmpty){
                showAtLeastOneDestinationSnackBar(context);
              }
              print("ALL_COORDINATES => ${widget.selectedCords}");
              getCoordinatesForJourney();
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

  void _handleSearchClick(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (settings) => PlaceSearchScreen(LocationService())));
    final feature = result as Feature?;
    if (feature != null) {
      widget.textEditingController.text = feature.placeName ?? "N/A";

      //swap (lng,lat) to (lat,lng)
      List<double?> latlngs = [];
      double? lat = feature.geometry?.coordinates.last;
      double? lng = feature.geometry?.coordinates.first;
      latlngs.add(lat);
      latlngs.add(lng);
      print("HERE:");
      print(latlngs);
      widget.selectedCords.add(latlngs);

      //print("MapOfList => ${feature.geometry?.coordinates}");
      print("MapOfList => ${latlngs}");
      print("MapOfListss => ${widget.selectedCords}");
    }
    print("RESULT => $result");
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
      content: Text(text, style: TextStyle(fontSize: 17),),
      backgroundColor: Colors.red,

    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    position = -1;
    super.dispose();
  }

  void showWhereToTextFieldsMustNotBeEmptySnackBar(BuildContext context) {
    const text = "Please specify locations for all destinations of the journey. Otherwise, remove any empty choices";
    const snackBar = SnackBar(
      content: Text(text, style: TextStyle(fontSize: 17),),
      backgroundColor: Colors.red,

    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



//void togglePanel() => panelController.isPanelOpen ? panelController.close() : panelController.open();
}

int position = -1;
class DynamicWidget extends StatelessWidget {
  late TextEditingController textController = TextEditingController();
  List< List<double?>?>? selectedCords;



  DynamicWidget({Key? key , required this.selectedCords}) : super(key: key){
    position++;
  }


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
                print("This should remove the location (and its widgets from the list and screen respectively)");
              },
              child: const Icon(
                Icons.close_outlined ,
                size: 35,
                color: Colors.red,
              ),
            ),
          //),
          Expanded(
            child: TextField(
              enabled: false,
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
                _handleSearchClick(context, position);
                print("TakeMYPOSITION => me to the place search screen $position");
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
    final feature = result as Feature?;
    if (feature != null) {
      textController.text = feature.placeName ?? "N/A";

      selectedCords?[position] = feature.geometry?.coordinates;

      print("MapOfList => $position");
    }
    print("RESULT => $result");
  }
}
