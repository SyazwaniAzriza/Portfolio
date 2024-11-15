import 'package:code/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Homepage',
          style: TextStyle(color: Color.fromARGB(255, 3, 237, 233)),
        ),
      ),
      backgroundColor: Colors.black,
        body: Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 3, 237, 233)),
          child: Text('Log Out'),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("Signed Out");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ));
            });
          }),
    ));
  }
}


