import 'dart:io';
import 'package:MetnaVadq/features/posts/screens/create_post_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPostPage extends ConsumerStatefulWidget {
  const CameraPostPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CameraPostPage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late File _image;
  bool isFlashOn = false;
  bool isFrontCamera = false;

  @override
  void initState() {
    _initializeControllerFuture = _initializeCamera(0);
    super.initState();
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    final cameras = await availableCameras();

    _cameraController = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.ultraHigh,
    );

    return _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    if (!_cameraController.value.isInitialized ||
        _cameraController.value.isTakingPicture) {
      return;
    }

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        return;
      }
    }

    await _cameraController
        .setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
    final image = await _cameraController.takePicture();
    await _cameraController.setFlashMode(FlashMode.off);

    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            title: const Center(child: Text('Metna-vadq')),
            automaticallyImplyLeading: false,
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(255, 255, 255, .7),
        shape: const CircleBorder(),
        onPressed: () async {
          await takePicture();
          Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (BuildContext context) {
            return CreatePostPage(
              image: _image,
            );
          }));
        },
        child: const Icon(
          Icons.camera_alt,
          size: 40,
          color: Colors.black87,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 100,
                      child: CameraPreview(_cameraController),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFlashOn = !isFlashOn;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(50, 0, 0, 0),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: isFlashOn
                                ? const Icon(
                                    Icons.flash_on,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.flash_off,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFrontCamera = !isFrontCamera;
                        });
                        int cameraIndex = isFrontCamera ? 1 : 0;
                        _initializeControllerFuture =
                            _initializeCamera(cameraIndex);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(50, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: isFrontCamera
                              ? const Icon(
                                  Icons.camera_rear,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.camera_front,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
