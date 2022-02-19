import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/screens/location_service.dart';
import 'journey_planner_screen.dart';

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
            Padding(
              padding: const EdgeInsets.only(left: 20,top:20,right: 20),
              child: TextField(
                decoration:  InputDecoration(
                    prefixIcon:  IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.green),
                      onPressed: () {
                          print("PREFIX");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const JourneyPlanner()));
                        },
                    ),
                    hintText: "Search for a London location",

                    //Textfield front-end customization
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.green, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.green, width: 1.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.green, width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.green, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.green, width: 1.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.green, width: 1.0),
                    ),
                ),
                onChanged: (value) {
                  // Call get place function
                  Future.delayed(const Duration(milliseconds: 100), (){
                    widget.locService.getPlaceFeatures(value);
                  });
                },
              ),
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
                          Navigator.of(context).pop(address);
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
