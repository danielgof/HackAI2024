import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late TextEditingController _searchController;
  List<String> _list = [
    'Apple',
    'Banana',
    'Orange',
    'Grapes',
    'Watermelon',
    'Pineapple',
    'Mango',
    'Strawberry',
  ];
  late List<String> _searchList;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchList = _list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterList(String searchText) {
    searchText = searchText.toLowerCase();
    setState(() {
      _searchList = _list
          .where((item) => item.toLowerCase().contains(searchText))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 200,
            child: Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('profile page'),
                    Icon(Icons.account_circle_rounded),
                    ElevatedButton(
                      onPressed: () {
                        appState.logout();
                      },
                      child: Column(
                        children: [Text('Logout'), Icon(Icons.arrow_forward)],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterList,
              decoration: InputDecoration(
                labelText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   var appState = context.watch<MyAppState>();
  //   return SafeArea(
  //       child: Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Card(
  //         child: Column(children: [
  //           Text('profile page'),
  //           Icon(Icons.account_circle_rounded),
  //           ElevatedButton(
  //               onPressed: () {
  //                 appState.logout();
  //               },
  //               child: Column(
  //                 children: [Text('Logout'), Icon(Icons.arrow_forward)],
  //               ))
  //         ]),
  //       ),
  //     ],
  //   ));
  // }
}
