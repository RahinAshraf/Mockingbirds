import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloplan/services/favourite_service.dart';
import 'package:veloplan/widgets/docking_station_card.dart';
import 'package:veloplan/models/favourite.dart';
import '../styles/styling.dart';

// import 'dart:async';
import '../providers/connectivity_provider.dart';
import '../utilities/connectivityStatusEnum.dart';
import '../widgets/connection_error_widget.dart';


//Loads cards of all of the users favourited docking station
class Favourite extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<FavouriteDockingStation> favourites = [];
  var helper = FavouriteHelper();

  @override
  void initState() {
    FavouriteHelper.getUserFavourites().then((data) {
      setState(() {
        favourites = data;
      });
    });

  //   ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  //   _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);

  //   super.initState();
   }



  // void connectionChanged(dynamic hasConnection) {
  //   setState(() {
  //     isOffline = !hasConnection;
  //   });
  //}



  @override
  Widget build(BuildContext build) {
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, child) {
      return Scaffold(
      body:  connectivityProvider.connectionStatus != ConnectivityStatus.Offline 
      ? 
      favourites.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Center(
                child: Text("You haven't added any favourites."),
              ),
            )
          : Stack(
              children: [
                ListView.builder(
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      return dockingStationCard(
                        favourites[index].station_id,
                        favourites[index].name,
                        favourites[index].nb_bikes,
                        favourites[index].nb_empty_docks,
                      );
                    }),
              ],
            ) : ConnectionError(),
         
      appBar: AppBar(
        title: const Text('My favourites'),
        backgroundColor: appBarColor,
      ),
       
    );});
  }
}


// @override
//   Widget build(BuildContext context) {
//     return Consumer<ConnectivityProvider>(
//         builder: (context, connectivityProvider, child) {
//       return Scaffold(
//         backgroundColor: LoadedAppData.appColors.pageBg,
//         appBar: AppBar(
//           backgroundColor: LoadedAppData.appColors.headerBg,
//           title: Text("App Builder"),
//           titleTextStyle: TextStyle(
//             color: LoadedAppData.appColors.headerText,
//           ),
//         ),
//         body: connectivityProvider.networkState != ConnectivityStatus.Offline
//             ? Consumer<PostsProvider>(
//                 builder: (context, postsProvider, child) {
//                   return postsProvider.viewState == ViewState.Done
//                       ? postsProvider.posts.isNotEmpty
//                           ? ListView.builder(
//                               itemCount: postsProvider.posts.length,
//                               itemBuilder: (context, index) =>
//                                   CardWidget(post: postsProvider.posts[index]),
//                             )
//                           : Center(
//                               child: Text(
//                                   "No data, you can choose item from side menu"),
//                             )
//                       : Center(
//                           child: CircularProgressIndicator(
//                             color: LoadedAppData.appColors.textColor,
//                           ),
//                         );
//                 },
//               )
//             : ConnectionError(),
//       );
//     });
//   }
// }