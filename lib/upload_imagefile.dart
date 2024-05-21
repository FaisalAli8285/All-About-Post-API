import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadImageFile extends StatefulWidget {
  const UploadImageFile({super.key});

  @override
  State<UploadImageFile> createState() => _UploadImageFileState();
}

class _UploadImageFileState extends State<UploadImageFile> {
  File? image;
  final ImagePicker _picker = ImagePicker();

  bool showSpinner = false;
  Future getImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {
      print("no image selected");
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      showSpinner = true;
    });
    // Files can be large, and reading them directly into memory as a whole might not be feasible.
    // Instead, using a byte stream allows you to read and upload the file in chunks, which is more
    // memory-efficient and suitable for network transmission.
    var stream = http.ByteStream(image!.openRead());
    //Ensures the stream is of the correct type for the multipart request
    stream.cast();
    //Gets the length of the file in bytes asynchronously
    var length = await image!.length();
    //Defines the endpoint to which the image will be uploaded
    var uri = Uri.parse("https://fakestoreapi.com/products");
// http.MultipartRequest is a class provided by the http package in Dart.
// It is used to create an HTTP request that can send both text (form fields) and binary data (files)
// simultaneously, using the multipart/form-data content type.
// "Post" indicates the HTTP method to be used for the request. In this case, it specifies a POST request.
// HTTP methods like GET, POST, PUT, DELETE, etc., determine the type of action to be performed on the server.
// uri is an instance of Uri, which represents the URL or endpoint to which the HTTP request will be sent.
// It specifies the destination of the request.

    var request = http.MultipartRequest("Post", uri);
    // request.fields["title"] = "Static Title"; 
    // adds a form field named "title" to the HTTP request with a static value of "Static Title". 
    // This could be useful if your server-side code expects specific metadata to be included along with the 
    // uploaded file.
    request.fields["title"] = "Static Title";
    var multiport = new http.MultipartFile("image", stream, length);
    request.files.add(multiport);
    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        showSpinner = false;
      });
      print("Image Uploaded");
    } else {
      setState(() {
        showSpinner = false;
      });
      print("Failed to upload an image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Upload Image"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: image == null
                  ? Center(
                      child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Gallery'),
                          onTap: () {
                            //Navigator.of(context).pop();
                            getImage(ImageSource.gallery);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_camera),
                          title: Text('Camera'),
                          onTap: () {
                            //  Navigator.of(context).pop();
                            getImage(ImageSource.camera);
                          },
                        ),
                      ],
                    ))
                  : Container(
                      child: Center(
                        child: Image.file(
                          File(image!.path).absolute,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 150,
            ),
            ElevatedButton(
                onPressed: () {
                  uploadImage();
                },
                child: Center(
                  child: Text("Upload"),
                ))
          ],
        ),
      ),
    );
  }
}
