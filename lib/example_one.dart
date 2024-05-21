import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PostApiExampleOne extends StatefulWidget {
  const PostApiExampleOne({super.key});

  @override
  State<PostApiExampleOne> createState() => _PostApiExampleOneState();
}

class _PostApiExampleOneState extends State<PostApiExampleOne> {
  void signUp(String email, String password) async {
    try {
      Response response = await post(
          Uri.parse("https://reqres.in/api/register"),
          body: {"email": email, "password": password});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data["id"].toString());
        print("Account Created Succesfully");
      } else {
        print("account creation failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Post Api Examples")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(hintText: "Email"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(hintText: "Password"),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  onPressed: () {
                    signUp(_emailController.text.toString(),
                        _passwordController.text.toString());
                  },
                  child: Center(child: Text("Sign Up"))),
            ),
          ],
        ),
      ),
    );
  }
}
