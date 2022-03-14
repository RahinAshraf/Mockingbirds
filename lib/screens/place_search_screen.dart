import 'package:flutter/material.dart';
import 'package:veloplan/providers/location_service.dart';
import 'journey_planner_screen.dart';

/*
  @author - Rahin Ashraf
 */

class PlaceSearchScreen extends StatefulWidget {
  late LocationService locService;

  bool? isPop;

  PlaceSearchScreen(this.locService, {Key? key, this.isPop = false}) : super(key: key);

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
              padding: const EdgeInsets.only(left: 20,top:30,right: 20),
              child: TextField(
                decoration:  InputDecoration(
                    prefixIcon:  IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.green),
                      onPressed: () {
                          print("PREFIX");
                          if(widget.isPop ?? false){
                            Navigator.pop(context);
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => JourneyPlanner()));
                          }
                        },
                    ),
                    hintText: "Search for a London location",

                    //Textfield front-end customization
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.green, width: 2.0),
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
                      String? address = place?.placeName ;
                      return address == null
                          ? const SizedBox(
                              height: 0,
                              width: 0,
                            )
                          : ListTile(
                          leading: const SizedBox(
                          height: double.infinity,
                          child: CircleAvatar(backgroundColor: Colors.green,child: Icon(Icons.location_pin, color: Colors.white,))),
                        onTap: (){
                          Navigator.of(context).pop(place);
                        },
                              title: Text(address, style: const TextStyle(fontWeight: FontWeight.bold)),
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
