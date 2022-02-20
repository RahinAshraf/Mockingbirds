import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/screens/place_search_screen.dart';

import '../models/destination_choice.dart';
import '../screens/location_service.dart';

class PanelWidget extends StatefulWidget{
  final ScrollController controller;
  final PanelController panelController;
  final   StreamController<List<DynamicWidget>> dynamicWidgets;
  final List<DynamicWidget> listDynamic;
  final List<List<double?>?> selectedCords;
  final TextEditingController textEditingController;

  const PanelWidget({
      required this.controller,
    required this.dynamicWidgets,
    required this.listDynamic,
    required this.selectedCords,
    required this.textEditingController,
      required this.panelController, Key? key}): super(key: key);

  @override
  PanelWidgetState createState() {
    return PanelWidgetState();
  }

}

class PanelWidgetState extends State<PanelWidget>{

  Stream<List<DynamicWidget>> get  dynamicWidgetsStream  => widget.dynamicWidgets.stream;

  addDynamic() {
   widget. listDynamic.add(DynamicWidget(selectedCords: widget.selectedCords,));
    widget.dynamicWidgets.sink.add(widget.listDynamic);
  }


  Widget _buildStatic(){
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Text("From: ",  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, )),
          const SizedBox(width: 20),
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: widget.textEditingController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Search',
                  focusedBorder:OutlineInputBorder(
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
          ),
          //SizedBox(width: 10),
          TextButton(
            onPressed: () {
              _handleSearchClick(context);
              print("Take me to the place search screen");
            },
            child:const Icon(Icons.keyboard_arrow_right_rounded, size: 50, color: Colors.green,),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    //widget. listDynamic.add(DynamicWidget(selectedCords: widget.selectedCords,));

    return ListView(
      controller: widget.controller,
      padding: EdgeInsets.zero,
      children: <Widget>[
        const SizedBox(height: 12),
        buildDragHandle(),
        const SizedBox(height: 6),
        const Center(
          child: Text("Explore London", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 35),),
        ),
        _buildStatic(),
        Column(
          children: [
            StreamBuilder<List<DynamicWidget>>(builder: (_, snapshot){
              List<DynamicWidget> listOfDynamics = snapshot.data ?? [];

              print("DynamicWidget => ${listOfDynamics.length}");
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
          child: const Icon(Icons.add),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              primary: Colors.white,
            ),
            onPressed: () {
              print("ALL_COORDINATES => ${widget.selectedCords}");
            },
            child: const Text("START", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),),
          ),

        ),

      ],
    );
  }

  void _handleSearchClick(BuildContext context) async{
    final result = await Navigator.of(context).push(MaterialPageRoute(builder:
        (settings) => PlaceSearchScreen(LocationService())));
    final feature = result as Feature?;
    if(feature != null){
      widget.textEditingController.text = feature.placeName ?? "N/A";
      widget.selectedCords.add(feature.geometry?.coordinates);

      print("MapOfList => ${feature.geometry?.coordinates}");
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

  //void togglePanel() => panelController.isPanelOpen ? panelController.close() : panelController.open();
}

class DynamicWidget extends StatelessWidget {
    late TextEditingController textController = TextEditingController();
    List<List<double?>?>? selectedCords;
    DynamicWidget({Key? key, required this.selectedCords}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Expanded(child:  TextField(
            enabled: true,
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Search',
            ),
          )),
          Expanded(child: IconButton(
            onPressed: () {
              _handleSearchClick(context);
            },
            icon: const Icon(Icons.keyboard_arrow_right_rounded),
          )),
        ],
      ),
    );
  }

  void _handleSearchClick(BuildContext context) async{
    final result = await Navigator.of(context).push(MaterialPageRoute(builder:
        (settings) => PlaceSearchScreen(LocationService())));
    final feature = result as Feature?;
    if(feature != null){
      textController.text = feature.placeName ?? "N/A";
      selectedCords?.add(feature.geometry?.coordinates);

      print("MapOfList => ${feature.geometry?.coordinates}");
    }
    print("RESULT => $result");
  }
}

