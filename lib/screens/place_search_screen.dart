import 'package:flutter/material.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/styles/colors.dart';

///Screen for users to specify a location for the journey through the use of a search bar.
///As the user types for a location, a drop down list of relevant matches to what the user searches for is displayed
/// Author(s): Rahin
class PlaceSearchScreen extends StatefulWidget {
  late LocationService locService;
  bool? isPop;

  PlaceSearchScreen(this.locService, {Key? key, this.isPop = false})
      : super(key: key);

  @override
  PlaceSearchScreenState createState() {
    return PlaceSearchScreenState();
  }
}

class PlaceSearchScreenState extends State<PlaceSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.arrow_back_rounded,
                        key: Key("back"), color: CustomColors.green),
                    onPressed: () {
                      if (widget.isPop ?? false) {
                        Navigator.pop(context);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JourneyPlanner()));
                      }
                    },
                  ),
                  hintText: "Search for a London location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: CustomColors.green, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: CustomColors.green, width: 2.0),
                  ),
                ),
                onChanged: (value) {
                  Future.delayed(const Duration(milliseconds: 100), () {
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
                              leading: SizedBox(
                                height: double.infinity,
                                child: CircleAvatar(
                                  backgroundColor: CustomColors.green,
                                  child: Icon(Icons.location_pin,
                                      color: Colors.white),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop(place);
                              },
                              title: Text(address,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87)),
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
