import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';

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
    WidgetsFlutterBinding.ensureInitialized();
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
      final faceDetector =
          FaceDetector(options: FaceDetectorOptions(enableContours: true));

      // Get the camera image.
      _controller.takePicture().then((XFile file) async {
        final image = InputImage.fromFilePath(file.path);
        final faces = await faceDetector.processImage(image);

        // Check if any face is within the overlay.
        for (final face in faces) {
          if (isFaceInOverlay(face)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('THERE IS A FACE.')),
            );
          } else {}
        }

        // If no face is within the overlay, show a message to the user.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please position your face within the overlay.')),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  bool isFaceInOverlay(Face face) {
    Rect faceRect = face.boundingBox;

    // Define the overlay's dimensions
    final overlayRect = Rect.fromLTRB(
      100, // left
      100, // top
      MediaQuery.of(context).size.width - 100, // right
      MediaQuery.of(context).size.height - 100, // bottom
    );

    // Check if the face's bounding box is within the overlay
    bool isWithinOverlay =
        overlayRect.contains(Offset(faceRect.left, faceRect.top)) &&
            overlayRect.contains(Offset(faceRect.right, faceRect.top)) &&
            overlayRect.contains(Offset(faceRect.right, faceRect.bottom)) &&
            overlayRect.contains(Offset(faceRect.left, faceRect.bottom));

    return isWithinOverlay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: FaceCamera.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: <Widget>[
                SmartFaceCamera(
                  autoCapture: true,
                  onCapture: (File? image) {
                    if (image != null) {
                      print("Image captured");
                    }
                  },
                  defaultCameraLens: CameraLens.front,
                  onFaceDetected: (Face? face) {
                    if (face != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Face detected.')));
                    }
                  },
                  messageBuilder: (context, detectedFace) {
                    return Positioned(
                        height: (MediaQuery.of(context).size.height * 1.05),
                        width: (MediaQuery.of(context).size.width * 1),
                        child: const Padding(padding: EdgeInsets.only(left: 110.0, right: 110.0),child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Prennez une photo de \n vous-même",
                              style: TextStyle(color: MyColors.defaultWhite,fontWeight: FontWeight.w700),textAlign: TextAlign.center,
                            ),
                            Text(
                              "Tenez votre appareil droit devant vous ou demandez à un ami de vous prendre en photo. Assurez-vous que l'ensemble de votre visage est visible.",
                              style: TextStyle(color: MyColors.defaultWhite, fontSize: 12, fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),));
                  },
                  showControls: false,
                  indicatorBuilder: (context, isFocused, size) {
                    return CustomPaint(painter: FaceShapePainter());
                  },
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class FaceShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    var borderPaint = Paint()
      ..color = Colors.white // Change this to the color you want for the border
      ..strokeWidth = 2.0 // Change this to control the thickness of the border
      ..style = PaintingStyle.stroke;

    // Draw the background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Define the overlay's dimensions
    final overlayRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2.5),
      width: size.width * 0.6, // adjust the width to suit your needs
      height: size.height * 0.5, // adjust the height to suit your needs
    );

    // Draw the border
    canvas.drawOval(overlayRect, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
