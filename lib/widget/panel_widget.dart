import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelWidget extends StatelessWidget{
  final ScrollController controller;
  final PanelController panelController;

    const PanelWidget({
      Key? key,
      required this.controller,
      required this.panelController,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
    controller: controller,
    padding: EdgeInsets.zero,
    children: <Widget>[
      const SizedBox(height: 12),
      buildDragHandle(),
      const SizedBox(height: 6),
      const Center(
        child: Text("Explore London", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 35),),
      ),
    ],
  );

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