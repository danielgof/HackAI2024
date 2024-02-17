import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:camera/camera.dart';
import 'package:compas/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dart_openai/dart_openai.dart';

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

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  Future<void> _sendFileToServer() async {
    final String apiUrl = 'https://api.openai.com/v1/completions';
    final Uri uri = Uri.parse(apiUrl);
    print('++++++++++++++++++++++++++++++++++++');
    File imageFile = File(imagePath);
    List<int> imageData = await imageFile.readAsBytes();
    // Convert bytes to base64
    String base64Image = base64Encode(imageData);
    print(base64Image);

    // var request = http.MultipartRequest('POST', uri)
    //   ..headers['Authorization'] =
    //       'Bearer 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'
    //   ..headers['Content-Type'] = 'application/json'
    //   ..files.add(await http.MultipartFile.fromPath('image', imagePath));

    // try {
    //   var response = await request.send();

    //   if (response.statusCode == 200) {
    //     var responseBody = await response.stream.bytesToString();
    //     print(json.decode(responseBody)['response']);
    //   } else {
    //     print('Error: Unable to process the file.');
    //   }
    // } catch (error) {
    //   print('error');
    // }
  }
  // Future<void> sendApiRequest() async {
  //   final apiUrl = 'https://api.openai.com/v1/completions';

  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization':
  //           'Bearer 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'
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       "model": "davinci-002",
  //       "prompt": "how are you doing",
  //       "max_tokens": 250,
  //       "temperature": 0,
  //       "top_p": 1
  //     }),
  //   );
  //   print('++++++++++++++++++++++++++++++++++++++++++++');
  //   print(response.body);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _sendFileToServer();
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
