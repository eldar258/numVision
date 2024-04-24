import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/material.dart';
import 'package:test_drive/service/session_service.dart';

late List<CameraDescription> _cameras;

void init() async {
  _cameras = await availableCameras();
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  int length = service.getCurrent().getLength();
  int curIndex = service.getCurrent().getLength();
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  bool _isProcessing = false;
  String _detectedText = '';
  late Timer timer;
  late List<List<String>> _pairs;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    _startCapturingPhotos();
  }

  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Лист: ${curIndex + 1}"),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned.fill(child: CameraPreview(_controller)),
                if (_isProcessing) Center(child: CircularProgressIndicator()),
                if (_detectedText.isNotEmpty)
                  Positioned(
                    top: 16.0,
                    left: 16.0,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.black54,
                      child: Text(
                        _detectedText,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (curIndex != length)
                  Positioned(
                    top: 16.0,
                    right: 16.0,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.white54,
                      child: Text(
                        service.getPageToString(curIndex),
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
                        onPressed: () {
                          setState(() {
                            curIndex = (curIndex + length) % (length + 1);
                          });
                        },
                        child: const Icon(Icons.arrow_left)// Icon(Icons.camera),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
                        onPressed: () {
                          setState(() {
                            service.addPairs(_pairs, curIndex);
                            if (curIndex == length) {
                              curIndex++;
                            }
                            length = service.getCurrent().getLength();
                          });
                        },
                        child: const Icon(Icons.camera_alt)// Icon(Icons.camera),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
                        onPressed: () {
                          setState(() {
                            curIndex = (curIndex + 1) % (length + 1);
                          });
                        },
                        child: const Icon(Icons.arrow_right)// Icon(Icons.camera),
                    ),
                  ],
                ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _startCapturingPhotos() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!_isProcessing) {
        _takePhoto();
      }
    });
  }

  void _takePhoto() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final image = await _controller.takePicture();
      _processImage(image);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processImage(XFile inputImage) async {
    setState(() {_isProcessing = true;});
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognisedText = await textRecognizer.processImage(InputImage.fromFilePath(inputImage.path));


    var detectedText = detectText(recognisedText.blocks);

    setState(() {
      _isProcessing = false;
      _detectedText = detectedText;
    });
  }

  String detectText(List<TextBlock> blocks) {
    RegExp idRg = RegExp(r'\d+-\d{4}-\d');
    RegExp codeRg = RegExp(r'^\d{4}$');
    List<List<String>> pairs = [];
    for (TextBlock block in blocks) {
      for (var line in block.lines) {
        if (idRg.hasMatch(line.text)) {
          pairs.add([line.text.split('-').first]);
        } else if (codeRg.hasMatch(line.text)) {
          pairs.last.add(line.text);
        }
      }
    }
    _pairs = pairs;
    String res = "";
    for (List<String> pair in pairs) {
      res += "id:${pair.first} code:${pair.last}";
      res += "\n";
    }
    return res;
  }
}