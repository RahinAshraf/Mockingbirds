import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/screens/location_service.dart';

class PlaceSearchScreen extends StatefulWidget {
  late LocationService locService;

  PlaceSearchScreen(this.locService, {Key? key}) : super(key: key);

  @override
  PlaceSearchState createState() {
    return PlaceSearchState();
  }
}

class PlaceSearchState extends State<PlaceSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  hintText: "Search location",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
              onChanged: (value) {
                // Call get place function
               Future.delayed(const Duration(seconds: 1), (){
                 widget.locService.getPlaceFeatures(value);
               });
              },
            ),
            Expanded(
                child: Card(
              child: StreamBuilder<List<Feature>?>(
                builder: (context, snapshot) {
                  final placeModels = snapshot.data;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final place = placeModels?[index];
                      String? address = place?.placeName;
                      return address == null
                          ? const SizedBox(
                              height: 0,
                              width: 0,
                            )
                          : ListTile(
                        onTap: (){
                          print("Delcare your action here!!");
                        },
                              title: Text(address),
                            );
                    },
                    itemCount: placeModels == null ? 0 : placeModels.length,
                  );
                },
                stream: widget.locService.feature,
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.locService.close();
    super.dispose();
  }
}
