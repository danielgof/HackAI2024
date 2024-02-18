import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late TextEditingController _searchController;
  List<String> _list = [
    'Milk',
    'Eggs',
    'Fish (e.g., bass, flounder, cod)',
    'Crustacean shellfish (e.g., crab, lobster, shrimp)',
    'Tree Nuts (e.g., almonds, walnuts, pecans)',
    'Peanuts',
    'Wheat',
    'Soybeans',
    'Sesame seeds',
    'Mustard',
    'Sulfites',
    'Celery',
    'Lupin',
    'Mollusks (e.g., clams, mussels, oysters)',
    'Gluten-containing grains (e.g., barley, rye)',
  ];
  late List<String> _searchList;
  late List<bool> _checkedList;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchList = _list;
    _checkedList = List.generate(_list.length, (index) => false);
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

  void _toggleCheckbox(int index) {
    setState(() {
      _checkedList[index] = !_checkedList[index];
    });
  }

  void _toggleEditPrefrences(bool isVisible) {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return SafeArea(
      child: Column(
        children: <Widget>[
          Text(
            'My Account',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Column(
            children: [
              Icon(
                Icons.account_circle_rounded, //PROFILE PICTURE GOES HERE
                size: 80,
              ),
            ],
          ),
          Text(
            'Welcome, USERNAME!',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _toggleEditPrefrences(_isVisible);
                },
                child: Column(
                  children: [Text('Edit Prefrences')],
                ),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  appState.logout();
                },
                child: Row(
                  children: [Text('Logout'), Icon(Icons.arrow_forward)],
                ),
              ),     
            ]
          ),
          Visibility(
            visible: _isVisible,
            child: 
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterList,
                      decoration: InputDecoration(
                        labelText: 'I am allergic to...',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child:  ListView.builder(
                    itemCount: _searchList.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(_searchList[index]),
                        value: _checkedList[index],
                        onChanged: (bool? value) {
                          _toggleCheckbox(index);
                        },
                      );
                    },
                    ),
                  )
                ]
              ),
            
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: _searchController,
          //     onChanged: _filterList,
          //     decoration: InputDecoration(
          //       labelText: 'I am allergic to...',
          //       fillColor: Colors.white,
          //       filled: true,
          //       border: OutlineInputBorder(),
          //     ),
          //   ),
          // ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: _searchList.length,
          //     itemBuilder: (context, index) {
          //       return CheckboxListTile(
          //         title: Text(_searchList[index]),
          //         value: _checkedList[index],
          //         onChanged: (bool? value) {
          //           _toggleCheckbox(index);
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
