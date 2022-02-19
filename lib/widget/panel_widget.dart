import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/screens/place_search_screen.dart';

import '../models/destination_choice.dart';
import '../screens/location_service.dart';

class PanelWidget extends StatefulWidget{
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidget({
      required this.controller,
      required this.panelController, Key? key}): super(key: key);

  @override
  PanelWidgetState createState() {
    return PanelWidgetState();
  }

}

class PanelWidgetState extends State<PanelWidget>{

  final StreamController<DynamicWidget> dynamicWidgets = StreamController.broadcast();
  Stream<DynamicWidget> get  dynamicWidgetsStream  => dynamicWidgets.stream;
  //List<DynamicWidget> listDynamic = [];


  addDynamic() {
   // listDynamic.add(DynamicWidget(TextEditingController()));
    dynamicWidgets.sink.add(DynamicWidget());
  }

  @override
  Widget build(BuildContext context){
    List<DynamicWidget> listOfDynamics = [];
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
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Text("From: ",  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, )),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextField(
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
                  print("Take me to the place search screen");
                },
                child:const Icon(Icons.keyboard_arrow_right_rounded, size: 50, color: Colors.green,),
              ),
            ],
          ),
        ),
        Column(
          children: [
            StreamBuilder<DynamicWidget>(builder: (_, snapshot){
              if(snapshot.data != null){
                listOfDynamics.add(snapshot.requireData);
              }

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
              print("START");
            },
            child: const Text("START", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),),
          ),

        ),

      ],
    );
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
    //late TextEditingController textController = TextEditingController();
    DynamicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const  Expanded(child:  TextField(
            enabled: true,
            //controller: textController,
            decoration: InputDecoration(
              hintText: 'Search',
            ),
          )),
          Expanded(child: IconButton(
            onPressed: () async{
              final result = await Navigator.of(context).push(MaterialPageRoute(builder:
                  (settings) => PlaceSearchScreen(LocationService())));
             // textController.text = result.toString();
              print("RESULT => $result");
            },
            icon: const Icon(Icons.keyboard_arrow_right_rounded),
          )),
        ],
      ),
    );
  }
}

