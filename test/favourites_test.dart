// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';

// const FavouriteCollection = 'favourites';

// void main() async {
//   FavouriteHelper favouriteHelper = FavouriteHelper();
//   final instance = FakeFirebaseFirestore();
//   await instance.addFavourite("id", "station1", 6, 2);
//   final snapshot = await instance.collection('users').get();
//   print(snapshot.docs.length); // 1
//   print(snapshot.docs.first.get('username')); // 'Bob'
//   print(instance.dump());
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:firestore_example/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// const MessagesCollection = 'messages';

// void main() {
//   testWidgets('shows messages', (WidgetTester tester) async {
//     // Populate the fake database.
//     final firestore = FakeFirebaseFirestore();
//     await firestore.collection(MessagesCollection).add({
//       'message': 'Hello world!',
//       'created_at': FieldValue.serverTimestamp(),
//     });

//     // Render the widget.
//     await tester.pumpWidget(MaterialApp(
//         title: 'Firestore Example', home: MyHomePage(firestore: firestore)));
//     // Let the snapshots stream fire a snapshot.
//     await tester.idle();
//     // Re-render.
//     await tester.pump();
//     // // Verify the output.
//     expect(find.text('Hello world!'), findsOneWidget);
//     expect(find.text('Message 1 of 1'), findsOneWidget);
//   });
// }

// // Prints out:
// // {
// //   "users": {
// //     "z": {
// //       "name": "Bob"
// //     }
// //   }
// // }

// void main() {
//   testWidgets('shows messages', (WidgetTester tester) async {
//     // Populate the mock database.
//     final firestore = FakeFirebaseFirestore();
//     await firestore.collection(FavouriteCollection).add({
//       'message': 'Hello world!',
//       'created_at': FieldValue.serverTimestamp(),
//     });

//     // Render the widget.
//     await tester.pumpWidget(MaterialApp(
//         title: 'Firestore Example', home: MyHomePage(firestore: firestore)));
//     // Let the snapshots stream fire a snapshot.
//     await tester.idle();
//     // Re-render.
//     await tester.pump();
//     // // Verify the output.
//     expect(find.text('Hello world!'), findsOneWidget);
//     expect(find.text('Message 1 of 1'), findsOneWidget);
//   });

//   testWidgets('adds messages', (WidgetTester tester) async {
//     // Instantiate the mock database.
//     final firestore = FakeFirebaseFirestore();

//     // Render the widget.
//     await tester.pumpWidget(MaterialApp(
//         title: 'Firestore Example', home: MyHomePage(firestore: firestore)));
//     // Verify that there is no data.
//     expect(find.text('Hello world!'), findsNothing);

//     // Tap the Add button.
//     await tester.tap(find.byType(FloatingActionButton));
//     // Let the snapshots stream fire a snapshot.
//     await tester.idle();
//     // Re-render.
//     await tester.pump();

//     // Verify the output.
//     expect(find.text('Hello world!'), findsOneWidget);
//   });
// }
