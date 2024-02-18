import 'dart:convert';
import 'dart:io';
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
  late final String imagePath;
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
          return Stack(
            children: [
              CameraPreview(_controller),
              Positioned(
                bottom: 16.0,
                left: 16.0,
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
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }

  Widget _buildPicturePage() {
    return Column(children: [
      const Text('Display the Picture'),
      Expanded(child: Image.file(File(imagePath))),
      FloatingActionButton(
        onPressed: () async {
          await _sendFileToServer();
          setResponsePage();
        },
        child: const Icon(Icons.send),
      ),
    ]);
  }

  Widget _buildLandingPage() {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/land_back.png"), fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          Text('Hello'),
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
    );
  }

  Widget _buildResponsePage() {
    return response == Null ? Text('response') : Text(response);
  }
}
