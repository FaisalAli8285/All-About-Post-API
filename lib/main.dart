import 'dart:io';

import 'package:flutter/material.dart';
import 'package:post_api/upload_imagefile.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new PostHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.deepPurple)),
      home: UploadImageFile(),
    );
  }
}
