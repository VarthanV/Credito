import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _scaffoldKey = new GlobalKey<FormState>();
  var _nameController = new TextEditingController();
  var _password1Controller = new TextEditingController();
  var _password2Controller = new TextEditingController();
  var _emailController = new TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  var db = Firestore.instance;
//SignUp function
  signUp(String useremail, String password, String name) {
    try {
      _firebaseAuth
          .createUserWithEmailAndPassword(email: useremail, password: password)
          .then((user) {
        user.sendEmailVerification();
        var profile = db.collection('profile');
        profile.add({
          "id":"",
          "name": _nameController.text,
          "email": _emailController.text
        }).then((doc) {
          doc.updateData({'id':doc.documentID});
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('id', doc.documentID);
          });
        });

        showDialog(
            context: context,
            child: AlertDialog(
              content: Text(
                "Please verify your Email and Login,Link has been mailed",
                style: TextStyle(fontFamily: "OpenSans"),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text("OK", style: TextStyle(fontFamily: "OpenSans")),
                    onPressed: () {
                      setState(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginPage()));
                      });
                    })
              ],
            ));
      });
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          showDialog(
              context: context,
              child: AlertDialog(
                content: Text("Email Already Exists Please Login"),
                actions: <Widget>[
                  FlatButton(
                      color: Colors.teal,
                      child: Text("OK"),
                      onPressed: () {
                        setState(() {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginPage()));
                        });
                      })
                ],
              ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              margin: EdgeInsets.only(top: 6.0),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(fontFamily: "OpenSans")),
                style: TextStyle(fontFamily: "OpenSans"),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Email cannot  be Empty";
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              margin: EdgeInsets.only(top: 6.0),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    hintText: "Enter your name",
                    hintStyle: TextStyle(fontFamily: "OpenSans")),
                style: TextStyle(fontFamily: "OpenSans"),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Name cannot be Empty";
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              margin: EdgeInsets.only(top: 6.0),
              child: TextFormField(
                  controller: _password1Controller,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(fontFamily: "OpenSans")),
                  style: TextStyle(fontFamily: "OpenSans"),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Password cannot be Empty";
                    }
                  }),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              margin: EdgeInsets.only(top: 6.0),
              child: TextFormField(
                  controller: _password2Controller,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: " Confirm Password",
                      hintStyle: TextStyle(fontFamily: "OpenSans")),
                  style: TextStyle(fontFamily: "OpenSans"),
                  validator: (String value) {
                    if (_password1Controller.text != value) {
                      return "Passwords Does'nt Match";
                    }
                  }),
            ),
            !isLoading
                ? Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        if (_formKey.currentState.validate()) {
                          signUp(_emailController.text,
                              _password1Controller.text, _nameController.text);
                        }
                      },
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 20.0),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
