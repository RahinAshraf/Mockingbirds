import 'package:flutter/material.dart';

//THIS WILL NOT BE A PAGE - IT WILL BE A SIDE-MENU BAR AS PER PDF DESIGN. THIS IS A 
//PLACEHOLDER FOR TIME BEING. 

class Journey extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More page'),
      ),
      body: Center(
        child: Text("More page!"),
      ),
    );
  }
}
