import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _key = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _emailController = new TextEditingController();
  var _passwordController = new TextEditingController();
  bool isLoading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print(user.uid);
    if (user.uid != null || user.uid != '') {
      SharedPreferences.getInstance().then((prefs){
        prefs.setString('cookie', user.uid);
      });
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      });
    }

    return user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black54),
          ),
          Form(
            key: _key,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 250.0, left: 10.0, right: 10.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "Email",
                        icon: Icon(Icons.email),
                        hintStyle: TextStyle(fontFamily: 'OpenSans')),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(Icons.payment),
                        hintStyle: TextStyle(fontFamily: 'OpenSans')),
                  ),
                ),
                !isLoading
                    ? Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 10.0, top: 10.0),
                        margin: EdgeInsets.only(top: 3.0),
                        child: FlatButton(
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(fontFamily: 'OpenSans'),
                            ),
                            onPressed: () {
                              if (_emailController.text == '' ||
                                  _passwordController.text == '') {
                                var snackbar = SnackBar(
                                  content: Text(
                                    "Email or Password Incorrect",
                                    style: TextStyle(fontFamily: 'Opensans'),
                                  ),
                                  backgroundColor: Colors.red,
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(snackbar);
                              } else {
                                isLoading = true;
                                signIn(_emailController.text,
                                    _passwordController.text);
                              }
                            }))
                    : Container(
                        margin: EdgeInsets.only(top: 20.0),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator())
              ],
            ),
          )
        ],
      ),
    );
  }
}
