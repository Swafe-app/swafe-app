import 'dart:io';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/components/IconButton/icon_button.dart';

class CameraIdentity extends StatefulWidget {
  const CameraIdentity({super.key});

  @override
  CameraIdentityState createState() => CameraIdentityState();
}

class CameraIdentityState extends State<CameraIdentity> {
  late Future<void> _initializeCamera;
  ValueNotifier<String> indicatormessage =
      ValueNotifier("Prenez une photo de \n vous-même");
  ValueNotifier<bool> autoCapture = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _initializeCamera = FaceCamera.initialize();
  }

  bool isFaceInOval(Face face, Size size) {
    Rect faceRect = face.boundingBox;

    // We define the oval's dimensions
    final ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2.5),
      width: size.width * 0.65, // adjust the width to suit your needs
      height: size.height * 0.65, // adjust the height to suit your needs
    );

    // Check if we are within the oval
    bool isWithinOval =
        ovalRect.contains(Offset(faceRect.left, faceRect.top)) &&
            ovalRect.contains(Offset(faceRect.right, faceRect.top)) &&
            ovalRect.contains(Offset(faceRect.right, faceRect.bottom)) &&
            ovalRect.contains(Offset(faceRect.left, faceRect.bottom));

    return isWithinOval;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _initializeCamera,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  SmartFaceCamera(
                    captureControlBuilder: (context, detectedFace) {
                      if (autoCapture.value) {
                        // We define the widget of the capture button
                        return Container(
                            color: Colors.transparent,
                            height: 50,
                            child: Center(
                              child: CustomIconButton(
                                type: IconButtonType.outlined,
                                isDisabled: autoCapture.value,
                                size: IconButtonSize.L,
                                icon: Icons.camera,
                                iconColor: MyColors.defaultWhite,
                              ),
                            ),
                        );
                      }
                      else {
                        //We return an empty widget if we are not in the oval
                        return const SizedBox(height: 0, width: 0,);
                      }
                    },
                    messageBuilder: (context, detectedFace) {
                      // We define the message of the widget
                      return Positioned(
                        height: (MediaQuery.of(context).size.height * 1.05),
                        width: (MediaQuery.of(context).size.width * 1),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 110.0, right: 110.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: 1,
                                child: Container(
                                  color: Colors.transparent, // Add this line
                                  child: Text(
                                    indicatormessage.value,
                                    style: TextStyle(
                                        color: MyColors.defaultWhite
                                            .withOpacity(1.0),
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 1,
                                child: Container(
                                  color: Colors.transparent, // Add this line
                                  child: Text(
                                    "Tenez votre appareil droit devant vous ou demandez à un ami de vous prendre en photo. Assurez-vous que l'ensemble de votre visage est visible.",
                                    style: TextStyle(
                                        color: MyColors.defaultWhite
                                            .withOpacity(1.0),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    //We define what we'll do with the picture we took
                    onCapture: (File? image) {
                      if (image != null) {
                        Navigator.pop(context, image);
                      }
                    },
                    //We define the front lens
                    defaultCameraLens: CameraLens.front,
                    indicatorBuilder: (context, isFocused, size) {
                      //We check if the face of the user is in the oval
                      if (isFocused!.face != null && isFaceInOval(isFocused.face!, size!)) {
                        indicatormessage.value = "Ne bougez plus";
                        autoCapture.value = true;
                      } else {
                        indicatormessage.value =
                            "Prenez une photo de \n vous-même";
                        autoCapture.value = false;
                      }
                      //We draw the shape of the displayed oval
                      return CustomPaint(
                        painter: FaceShapePainter(),
                        child: Center(
                          child: Container(
                            height: 200,
                            width: 100,
                            color: Colors.transparent,
                          ),
                        ),
                      );
                    },
                    showCaptureControl: true,
                    //We hide the flash and the lens control
                    showCameraLensControl: false,
                    showFlashControl: false,
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class FaceShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var borderPaint = Paint()
      ..color = Colors.white // Change this to the color you want for the border
      ..strokeWidth = 4.0 // Increase this to make the border thicker
      ..style = PaintingStyle.stroke;

    // Define the overlay's dimensions
    final overlayRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2.5),
      width: size.width * 0.5, // adjust the width to suit your needs
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
