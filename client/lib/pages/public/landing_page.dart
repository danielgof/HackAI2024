import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

enum PageType {
  LandingPage,
  CameraPage,
  PicutrePage,
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
  late final String response;

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
              "text":
                  "Answer first question as 1 or 0. Is this food? Are there potential sources of allregies? What are they?"
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
      // Request successful, parse the response body
      setResult(jsonDecode(response.body)['choices'][0]['message']['content']
          .substring(2));
      print(
          'Response body: ${jsonDecode(response.body)['choices'][0]['message']['content'].substring(2)}');
    } else {
      // Request failed with an error code
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
    return SafeArea(
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (state) {
      case PageType.LandingPage:
        return _buildLandingPage();
      case PageType.CameraPage:
        return _buildCameraPreview();
      case PageType.PicutrePage:
        return _buildPicturePage();
      case PageType.ResponsePage:
        return _buildResponsePage();
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
            child: Stack(
              children: [
                CameraPreview(_controller),
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
        const Text('Display the Picture'),
        Stack(children: [
          Expanded(child: Image.file(File(imagePath))),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                await _sendFileToServer();
                setResponsePage();
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
        child: Column(children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(0.2), // Adjust opacity for the glass effect
              borderRadius:
                  BorderRadius.circular(20), // Adjust border radius as needed
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2), // Adjust shadow color
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            // child: Center(
            //   child: Text(
            //     'Glassmorphism',
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            // Apply the backdrop filter for blurring
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Same as the container
              color: Colors.white
                  .withOpacity(0.1), // Adjust opacity for the glass effect
            ),
            // Backdrop filter to create the blur effect
            // Adjust the filter quality and blur sigma as needed
            // This may impact performance
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withOpacity(0), // Transparent color
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
                            'Take a picture of any kind of food to learn more about it.')),
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

  Widget _buildResponsePage() {
    return response == Null ? Text('response') : Text(response);
  }
}
