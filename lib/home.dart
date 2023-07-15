import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File? _image;
  List? _output;
  final picker = ImagePicker();

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: 'asset/model_unquant.tflite', labels: 'asset/labels.txt');
  }

  @override
  void initState() {
    super.initState();

    loadmodel().then((value) {
      setState(() {});
    });
  }

  pickCameraImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image!);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffaea999),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 120),
                Text(
                  'FlutWorld',
                  style: TextStyle(
                      color: Color(0xff4169e1),
                      fontWeight: FontWeight.bold,
                      fontSize: 30), // TextStyle
                ), // Text
                SizedBox(height: 20),
                Text(
                  'Cats and Dogs Dectector App',
                  style: TextStyle(
                      color: Color(0xff4b4031),
                      fontWeight: FontWeight.w500,
                      fontSize: 30), // TextStyle
                ), // Text
                SizedBox(height: 50),
                Center(
                  child: _loading
                      ? Container(
                          width: 300,
                          child: Column(children: <Widget>[
                            Image.asset('asset/catDog.png'),
                            SizedBox(height: 50),
                          ]),
                        )
                      : Container(
                          child: Column(
                            children: [
                              Container(
                                width: 250,
                                child: Image.file(_image!),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              _output != null
                                  ? Text(
                                      '${_output![0]['label']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            pickCameraImage();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 250,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 18),
                            decoration: BoxDecoration(
                                color: Color(0xff4b4031),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              "click Image",
                              style: TextStyle(color: Color(0xffaea999)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 05,
                        ),
                        GestureDetector(
                          onTap: () {
                            pickGalleryImage();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 250,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 18),
                            decoration: BoxDecoration(
                                color: Color(0xff4b4031),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              "Select Image",
                              style: TextStyle(color: Color(0xffaea999)),
                            ),
                          ),
                        )
                      ]),
                ),
              ],
            )));
  }
}
