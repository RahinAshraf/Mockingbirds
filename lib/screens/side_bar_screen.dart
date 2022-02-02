import 'package:flutter/material.dart';

//THIS WILL NOT BE A PAGE - IT WILL BE A SIDE-MENU BAR AS PER PDF DESIGN. THIS IS A
//PLACEHOLDER FOR TIME BEING.

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIDEBAR'),
      ),
      body: Center(
        child: Text("SIDEBAR"),
      ),
    );
  }
}
