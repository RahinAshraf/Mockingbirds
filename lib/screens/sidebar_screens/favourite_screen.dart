import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/widgets/docking_station_card.dart';
import '../../providers/docking_station_manager.dart';
import 'package:veloplan/screens/splash_screen.dart';

///Loads users favourited docking stations and displays them in a list view.
///@author Tayyibah Uddin
class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  late List<DockingStation> favourites;
  var _helper = FavouriteHelper(DatabaseManager());

  @override
  void initState() {
    super.initState();
  }

  Future<List<DockingStation>> gething() async {
    this.favourites = await _helper.getUserFavourites();
    return favourites;
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: FutureBuilder<List<DockingStation>>(
        future: gething(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SplashScreen(); //replace with our splash screen

          }
          return favourites.isEmpty
              ? const Center(child: Text("You haven't added any favourites."))
              : Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ListView.builder(
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      return DockingStationCard.station(favourites[index]);
                    },
                  ),
                );
        },
      ),
      appBar: AppBar(
        title: const Text('My favourites'),
      ),
    );
  }
}
// class _FavouriteState extends State<Favourite> {
//   late Future<List<DockingStation>>? favourites;
//   var _helper = FavouriteHelper(DatabaseManager());

//   @override
//   void initState() {
//     _helper.getUserFavourites().then((data) {
//       setState(() {
//         //  favourites = data;

//         final Future<List<DockingStation>> favourites =
//             Future<List<DockingStation>>.delayed(
//           const Duration(seconds: 2),
//           () => data,
//         );

//         //print("lengthoflist" + favourites.length.toString());
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext build) {
//     return Scaffold(
//       body:    FutureBuilder<List<DockingStation>>(
//         future:  _helper.getUserFavourites().then((data){
//           favourites = data;
//         }, 
//         builder: (BuildContext context, AsyncSnapshot<List<DockingStation>> snapshot) {
//            List<Widget> children;
//           if (snapshot.hasData) {
//            favourites!.isEmpty
//           ?  Center(child: Text("You haven't added any favourites."))
//           : Padding(
//               padding: const EdgeInsets.only(top: 12.0),
//               child: ListView.builder(
//                 itemCount: favourites.length,
//                 itemBuilder: (context, index) {
//                   return DockingStationCard.station(favourites![index]);
//                 },
//               ),
//             );
//           } else if (snapshot.hasError) {
//             children = <Widget>[
//               const Icon(
//                 Icons.error_outline,
//                 color: Colors.red,
//                 size: 60,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 16),
//                 child: Text('Error: ${snapshot.error}'),
//               )
//             ];
//           } else {
//             children =  <Widget>[
//               SizedBox(
//                 width: 60,
//                 height: 60,
//                 child: CircularProgressIndicator(),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 16),
//                 child: Text('Awaiting result...'),
//               )
//             ];
      
//           }  },
//       )
//     ,
//       appBar: AppBar(
//         title: const Text('My favourites'),
//       ),
//     );
//   }
// }


//   favourites.isEmpty
//           ? const Center(child: Text("You haven't added any favourites."))
//           : Padding(
//               padding: const EdgeInsets.only(top: 12.0),
//               child: ListView.builder(
//                 itemCount: favourites.length,
//                 itemBuilder: (context, index) {
//                   return DockingStationCard.station(favourites[index]);
//                 },
//               ),
//             ),
            
