import 'package:compas/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  var appState;

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
    appState = context.watch<MyAppState>();
    setState(() {
      appState.toggelPreference(_searchList);
    });
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

  void _toggleEditPreferences(bool isVisible) {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'My Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ClipOval(
                    child: Image.asset(
                      'assets/brutus_buckeye.jpeg', // Assuming the image is stored in the assets folder
                      width: 80, // Adjust the width as needed
                      height: 80, // Adjust the height as needed
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, brutus_buckeye!',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: !_isVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Allergies:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 100, // Set the desired fixed height
                          child: ListView.builder(
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              if (_checkedList[index]) {
                                return ListTile(
                                  title: Text(_list[index]),
                                );
                              } else {
                                return SizedBox
                                    .shrink(); // Hide if preference is not true
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _toggleEditPreferences(_isVisible);
                          },
                          child: Column(
                            children: [Text('Edit Preferences')],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            appState.logout();
                          },
                          child: Row(
                            children: [
                              Text('Logout'),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Visibility(
                    visible: _isVisible,
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: _searchList.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Text(_searchList[index]),
                            value: _checkedList[index],
                            onChanged: (bool? value) {
                              _toggleCheckbox(index);
                              // if (_checkedList[index]) {
                              //   // appState.toggelPreference(_searchList[index]);
                              //   // setState(() {
                              //   //   appState.toggelPreference(_searchList[index]);
                              //   // });
                              // }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
