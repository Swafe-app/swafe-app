import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class CameraIdentity extends StatefulWidget {
  @override
  _CameraIdentityState createState() => _CameraIdentityState();
}

class _CameraIdentityState extends State<CameraIdentity> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      CameraDescription(
        name: "0",
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 0,
      ),
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _initializeCamera().then((value) => detectFacesAndCapture());
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    return _controller.initialize();
  }

  Future<void> detectFacesAndCapture() async {
    try {
      await _initializeControllerFuture;

      // Create a FaceDetector instance.
      final faceDetector = FaceDetector(options: FaceDetectorOptions(enableContours: true));

      // Get the camera image.
      _controller.startImageStream((CameraImage availableImage) async {
        // Convert the CameraImage to InputImage format
        final inputImage = InputImage.fromBytes(
          bytes: availableImage.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(availableImage.width.toDouble(),
                availableImage.height.toDouble()),
            rotation: InputImageRotation.rotation0deg,
            format: InputImageFormat.nv21,
            bytesPerRow: availableImage.planes[0].bytesPerRow,
          ),
        );
        final faces = await faceDetector.processImage(inputImage);

        // Check if any face is within the overlay.
        for (final face in faces) {
          if (isFaceInOverlay(face)) {
            return;
          }
          else{
          }
        }

        // If no face is within the overlay, show a message to the user.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please position your face within the overlay.')),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  bool isFaceInOverlay(Face face) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: <Widget>[
                CameraPreview(_controller),
                Positioned(
                  top: 100, // adjust these values as needed
                  left: 100,
                  right: 100,
                  bottom: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 3.0,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: detectFacesAndCapture,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}