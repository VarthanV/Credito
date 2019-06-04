import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RegisterPage.dart';

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
  final _googleSignIn= GoogleSignIn();
@override
Future<FirebaseUser> googleSignIn() async {
    // Start
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    var prefs=await SharedPreferences.getInstance();
    if (user.displayName != '' ){
      SharedPreferences.getInstance().then((prefs){
        print(prefs.getString('first'));
        prefs.setString('cookie', user.displayName);
        prefs.setString('email', user.email);
        prefs.setString('name', user.displayName);
        prefs.setString('url', user.photoUrl);
         Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) =>HomePage()));
        
    

      });
    }
    
  }
     
      

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print(user.uid);
    if (user.uid != null || user.uid != '') {
      if (!user.isEmailVerified) {
        setState(() {
          showDialog(
              context: context,
              child: AlertDialog(
                title: Text(
                  "Email Verification",
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
                content: Text("Please Verify Your Email to continue"),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "OK",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
        });
      }
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('cookie', user.uid);
        prefs.setString('email', user.email);
      Firestore.instance.collection('profile').where('email',isEqualTo: user.email).snapshots().listen((data){
        var id=data.documents[0]['id'];
        prefs.setString('id', id);

      });
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
            decoration: BoxDecoration(color: Colors.white),
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
                        child: CircularProgressIndicator()),
                Container(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  margin: EdgeInsets.only(top: 6.0),
                  child: FlatButton(
                    child: Text(
                      "REGISTER",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RegisterPage()));
                    },
                  ),
                ),
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
