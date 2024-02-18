import 'dart:convert';
import 'dart:io';
import 'package:compas/state.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

enum PageType {
  LandingPage,
  CameraPage,
  PicutrePage,
  WaitPage,
  ResponsePage;
}

class LandingPage extends StatefulWidget {
  const LandingPage({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  PageType state = PageType.LandingPage;
  late String imagePath;
  late String response;
  bool isClicked = false;

  Future<void> _sendFileToServer() async {
    File imageFile = File(imagePath);
    List<int> imageData = await imageFile.readAsBytes();
    // Convert bytes to base64
    String base64Image = base64Encode(imageData);
    // print(base64Image);

    var url = Uri.parse('https://api.openai.com/v1/chat/completions');
    var requestBody = {
      "model": "gpt-4-vision-preview",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": "OUTPUT PARAMETERS: HEADER - bolded, DESCRIPTION - italic, BRACKETS - description of what to write, CURLY BRACKETS - as written"
                      "Is it food? IF NO RESPOND: {DO NOT EAT THAT [OBJECT]}" +
                  "IF FOOD RESPOND:" +
                  "HEADER[Food Name]" +
                  "DESCRIPTION[brief decription no more then 10 words]" +
                  "HEADER{Potential Allergens:}" +
                  "BULLET POINTS - [bullet point specific food items or contents it is made out of that may cause allergies]" +
                  "HEADER{Estimated Caloric Content:}" +
                  "BULLET POINTS[Number of same food items if countable and estimated calloriesfor each]" +
                  "HEADER{Total Calories:}" +
                  "BULLET POINT[Estimate total calories of the all the foods]" +
                  "DESCRIPTION[Potential health beneifts and risks of the foods no more then 50 words]"
            },
            {
              "type": "image_url",
              "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
            }
          ]
        }
      ],
      "max_tokens": 300
    };

    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer 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',
    };

    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setResult(jsonDecode(response.body)['choices'][0]['message']['content']);
      print(
          'Response body: ${jsonDecode(response.body)['choices'][0]['message']['content']}');
      setResponsePage();
    } else {
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  }

  void setPicutrePage() {
    setState(() {
      state = PageType.PicutrePage;
    });
  }

  void setLandingPage() {
    setState(() {
      state = PageType.LandingPage;
    });
  }

  void setCameraPage() {
    setState(() {
      state = PageType.CameraPage;
    });
  }

  void setResponsePage() {
    setState(() {
      state = PageType.ResponsePage;
    });
  }

  void setWaitPage() {
    setState(() {
      state = PageType.WaitPage;
    });
  }

  void setResult(String res) {
    setState(() {
      response = res;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // var pair = appState.current;
    return SafeArea(
      child: _buildContent(appState),
    );
  }

  Widget _buildContent(MyAppState appState) {
    switch (state) {
      case PageType.LandingPage:
        return _buildLandingPage();
      case PageType.CameraPage:
        return _buildCameraPreview();
      case PageType.PicutrePage:
        return _buildPicturePage();
      case PageType.ResponsePage:
        return _buildResponsePage(appState);
      case PageType.WaitPage:
        return _buildWaitPage();
      default:
        return Container();
    }
  }

  Widget _buildCameraPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Take a picture here',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20.0), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: CameraPreview(_controller),
                    ),
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: FloatingActionButton(
                        onPressed: () async {
                          try {
                            await _initializeControllerFuture;
                            final image = await _controller.takePicture();
                            if (!context.mounted) return;
                            setState(() {
                              imagePath = image.path;
                              setPicutrePage(); // Switch to other page after taking picture
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      child: FloatingActionButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              // imagePath = image.path;
                              setLandingPage(); // Switch to other page after taking picture
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }

  Widget _buildPicturePage() {
    return SafeArea(
      child: Column(children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'If you\'re ready, submit picture',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Stack(children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Expanded(
              child: Image.file(
                File(imagePath),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                setWaitPage();
                await _sendFileToServer();
              },
              child: const Icon(Icons.send),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                imagePath = '';
                setCameraPage();
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _buildLandingPage() {
    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/land_back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(alignment: Alignment.topCenter, children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Welcome to See Food',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        'Take a picture of any kind of food to learn more about it.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          setCameraPage();
                        });
                      },
                      child: Icon(Icons.camera_alt_outlined),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildResponsePage(MyAppState state) {
    IconData icon;
    var pair;
    var appState = state;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return response == Null
        ? Center(child: Text('No data found'))
        : SingleChildScrollView(
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20.0), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.file(
                              height: 200.0,
                              File(imagePath),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                appState.toggleFavorite(response);
                              },
                              child: Icon(
                                icon,
                                size: 50.0,
                              ),
                              // label: Text('Like'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Expanded(
                      child: Stack(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  response,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: FloatingActionButton(
                        onPressed: () async {
                          setLandingPage();
                        },
                        child: const Icon(Icons.home),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildWaitPage() {
    return Center(child: CircularProgressIndicator.adaptive());
  }
}
