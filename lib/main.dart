import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OCR_app(),
    );
  }
}

class OCR_app extends StatefulWidget {
  @override
  _OCR_State createState() => _OCR_State();
}

class _OCR_State extends State<OCR_app> {
  File selectedImage;
  bool imgStatus = false;
  var displayText = "";

  Future selectImage() async {
    var temp = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = temp;
      imgStatus = true;
    });
  }

  Future copyImageText() async {
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(selectedImage);
    TextRecognizer imageTextRecogn = FirebaseVision.instance.textRecognizer();
    VisionText imageText = await imageTextRecogn.processImage(myImage);
    print(imageText);
    setState(() {
      for (TextBlock block in imageText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement word in line.elements) {
            displayText += word.text + " ";
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OCR"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          imgStatus
              ? Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(selectedImage),
                            fit: BoxFit.cover)),
                  ),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: Text("Select image"),
            onPressed: selectImage,
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: Text('Convert text'),
            onPressed: copyImageText,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              displayText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontFamily: 'Arial'),
            ),
          ),
        ],
      ),
    );
  }
}
