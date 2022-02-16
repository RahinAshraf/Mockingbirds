import 'package:flutter/material.dart';
import '../widget/custom_carousel.dart';

class Favourite extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites'),
      ),
      body: Center(
        child: Text("Favourite page!"),
      ),
    );
  }
}
