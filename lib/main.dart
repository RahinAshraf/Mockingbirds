import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'navbar.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => Login(), '/map': (context) => Navbar()},
  ));
}

// import 'package:flutter/material.dart';
// import 'package:favorite_button/favorite_button.dart';

// // importing dependencies
// void main() {
//   runApp(

//       /**Our App Widget Tree Starts Here**/
//       MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('GeeksforGeeks'),
//         backgroundColor: Colors.greenAccent[400],
//         centerTitle: true,
//       ), //AppBar
//       body: SingleChildScrollView(
//         padding: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
//         child: Center(
//           /** Card Widget **/
//           child: Column(
//             children: [
//               //Card 1
//               Card(
//                 elevation: 50,
//                 shadowColor: Colors.black,
//                 color: Colors.greenAccent[100],
//                 child: SizedBox(
//                   width: 310,
//                   height: 510,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Colors.green[500],
//                           radius: 108,
//                           child: CircleAvatar(
//                             backgroundImage: NetworkImage(
//                                 "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"),
//                             //NetworkImage
//                             radius: 100,
//                           ), //CircleAvatar
//                         ), //CirclAvatar
//                         SizedBox(
//                           height: 10,
//                         ), //SizedBox
//                         Text(
//                           'GeeksforGeeks',
//                           style: TextStyle(
//                             fontSize: 30,
//                             color: Colors.green[900],
//                             fontWeight: FontWeight.w500,
//                           ), //Textstyle
//                         ), //Text
//                         SizedBox(
//                           height: 10,
//                         ), //SizedBox
//                         Text(
//                           'HI',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.green[900],
//                           ), //Textstyle
//                         ), //Text
//                         SizedBox(
//                           height: 10,
//                         ), //SizedBox
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 100,
//                               child: RaisedButton(
//                                 onPressed: () => null,
//                                 color: Colors.green,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(4.0),
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.touch_app),
//                                       Text('Visit'),
//                                     ],
//                                   ), //Row
//                                 ), //Padding
//                               ), //RaisedButton
//                             ),

//                             // Favourite Button
//                             FavoriteButton(
//                               isFavorite: false,
//                               valueChanged: (_isFavorite) {
//                                 print('Is Favorite : $_isFavorite');
//                               },
//                             ),
//                           ],
//                         ), //SizedBox
//                       ],
//                     ), //Column
//                   ), //Padding
//                 ), //SizedBox
//               ),
//               SizedBox(
//                 height: 20,
//               ),

//               // Card 2
//               Card(
//                 elevation: 50,
//                 shadowColor: Colors.black,
//                 color: Colors.yellowAccent[100],
//                 child: SizedBox(
//                   width: 310,
//                   height: 510,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Colors.yellow[700],
//                           radius: 108,
//                           child: CircleAvatar(
//                             backgroundImage: NetworkImage(
//                                 "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"),
//                             //NetworkImage
//                             radius: 100,
//                           ), //CircleAvatar
//                         ), //CirclAvatar
//                         SizedBox(
//                           height: 10,
//                         ), //SizedBox
//                         Text(
//                           'GeeksforGeeks',
//                           style: TextStyle(
//                             fontSize: 30,
//                             color: Colors.yellow[900],
//                             fontWeight: FontWeight.w500,
//                           ), //Textstyle
//                         ), //Text
//                         SizedBox(
//                           height: 10,
//                         ), //SizedBox
//                         Text(
//                           'HI',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.yellow[900],
//                           ), //Textstyle
//                         ), //Text
//                         SizedBox(
//                           height: 10,
//                         ), //SizedBox
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 100,
//                               child: RaisedButton(
//                                 onPressed: () => null,
//                                 color: Colors.yellow[600],
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(4.0),
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.touch_app),
//                                       Text('Visit'),
//                                     ],
//                                   ), //Row
//                                 ), //Padding
//                               ), //RaisedButton
//                             ),

//                             // Favourite Button
//                             FavoriteButton(
//                               isFavorite: true,
//                               valueChanged: (_isFavorite) {
//                                 print('Is Favorite : $_isFavorite');
//                               },
//                             ),
//                           ],
//                         ), //SizedBox
//                       ],
//                     ), //Column
//                   ), //Padding
//                 ), //SizedBox
//               ),
//             ],
//           ), //Card
//         ),
//       ), //Center
//     ), //Scaffold
//   ) //MaterialApp
//       );
// }
