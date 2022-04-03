import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/screens/edit_profile_screen.dart';
import 'package:veloplan/helpers/new_scroll_behavior.dart';
import 'package:veloplan/screens/splash_screen.dart';
import 'package:veloplan/widgets/profile/profile_page_header.dart';

/// Screen for the profile of the current user
/// Author(s): Eduard Ragea k20067643
class Profile extends StatefulWidget {
  final String userID;
  static const routeName = '/user';

  const Profile(this.userID, {Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final DatabaseManager _databaseManager = DatabaseManager();

  /// Build custom appbar with link to edit profile.
  /// Update the page after closing edit profile page.
  PreferredSizeWidget _buildAppBar(context, data) {
    return AppBar(
      centerTitle: true,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          data['username'],
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfile(data)));
              setState(() {});
            },
            child: const Icon(
              Icons.edit,
              size: 26.0,
              color: Colors.green,
            ),
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = _databaseManager.getCurrentUser()!.uid;
    return FutureBuilder<DocumentSnapshot>(
      future: _databaseManager.getByKey('users', widget.userID),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: _buildAppBar(context, data),
            /// Let the user refresh the profile so they can see
            /// an update in statistics.
            body: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: DefaultTabController(
                length: 2,
                child: ScrollConfiguration(
                  behavior: NewScrollBehavior(),
                  child: ExtendedNestedScrollView(
                    onlyOneScrollInBody: true,
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            ProfilePageHeader(
                                data, _currentUser == widget.userID),
                          ]),
                        )
                      ];
                    },
                    body: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: ScrollConfiguration(
                            behavior: NewScrollBehavior(),
                            child: TabBar(
                              indicatorColor: Colors.green,
                              indicatorSize: TabBarIndicatorSize.label,
                              tabs: const [
                                Tab(
                                  text: 'About',
                                ),
                                Tab(
                                  text: 'Groups',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: ScrollConfiguration(
                          behavior: NewScrollBehavior(),
                          child: const TabBarView(children: [
                            Material(
                              child: Center(
                                child: Text('About'),
                              ),
                            ),
                            Material(
                              child: Center(
                                child: Text('Groups'),
                              ),
                            ),
                          ]),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const SplashScreen();
      },
    );
  }
}
