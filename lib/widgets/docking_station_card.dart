import 'package:flutter/material.dart';
import '/models/docking_station.dart';
import '/services/favourite_service.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.
///Author: Tayyibah, Hristina

class DockingStationCard extends StatefulWidget {
  late final String iD;
  late final String stationName;
  late final int numberOfBikes;
  late final int numberOfEmptyDocks;

  DockingStationCard(
    this.iD,
    this.stationName,
    this.numberOfBikes,
    this.numberOfEmptyDocks,
  );

  DockingStationCard.station(DockingStation station) {
    iD = station.stationId;
    stationName = station.name;
    numberOfBikes = station.numberOfBikes;
    numberOfEmptyDocks = station.numberOfEmptyDocks;
    //print(this.iD);
  }

  @override
  _DockingStationCardState createState() => _DockingStationCardState();
}

class _DockingStationCardState extends State<DockingStationCard> {
  final _helper = FavouriteHelper(); //change name
  List<DockingStation> _favourites = [];
  bool isVisible = true;

  @override
  void initState() {
    FavouriteHelper.getUserFavourites().then((data) {
      setState(() {
        _favourites = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shadowColor: Colors.green[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 30.0),
            IconButton(
              icon: _helper.isFavouriteStation(widget.iD, _favourites)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite,
                      color: Colors.grey,
                    ),
              onPressed: () async {
                List<DockingStation> updatedFavourites =
                    await FavouriteHelper.getUserFavourites();
                _helper.toggleFavourite(
                  widget.iD,
                  widget.stationName,
                  widget.numberOfBikes,
                  widget.numberOfEmptyDocks,
                );

                setState(() {
                  _favourites = updatedFavourites;
                });
              },
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stationName,
                    style: const TextStyle(
                      fontSize: 25.0,
                      color: Color(0xFF99D2A9),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Divider(
                    color: Color(0xFF99D2A9),
                    thickness: 5,
                  ),
                  Row(children: [
                    SizedBox(width: 30.0),
                    Icon(
                      Icons.event_available,
                      color: Color(0xFF99D2A9),
                      size: 18.0,
                    ),
                    Text(
                      'Total bikes: ${widget.numberOfBikes.toString()}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF99D2A9),
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ]),
                  Row(children: [
                    SizedBox(width: 30.0),
                    ImageIcon(
                      AssetImage("assets/images/logo.png"),
                      color: Color(0xFF99D2A9),
                      size: 18,
                    ),
                    Text(
                      'Available bikes: ${widget.numberOfEmptyDocks.toString()}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF99D2A9),
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
