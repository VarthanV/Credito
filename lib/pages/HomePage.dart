import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var key = GlobalKey<FormState>();

  Map currency = {'JPY': ' ¥ ', 'INR': '₹', 'Yuan': '¥', 'EU': '€'};

  //Controllers
  var _currencyController = new TextEditingController();
  var _cardController = new TextEditingController();
  var _dateController = new TextEditingController();
  var _balanceController = new TextEditingController();
  var db = Firestore.instance;
  var email = '';

  @override
  void initState() {
    super.initState();
  }

  newCard() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        email = prefs.getString('email');
        var id = prefs.getString('id');
        db.collection('profile').document(id).collection('Cards').add({
          "cardNumber": _cardController.text,
          "currency": currency[_currencyController.text],
          "balance": _balanceController.text,
          "expiryDate": _dateController.text
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Credito",
          style: TextStyle(fontFamily: "Opensans"),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          foregroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              showDialog(
                context: context,
                barrierDismissible: true,
                child: AlertDialog(
                  title: Text(
                    "Card Details",
                    style: TextStyle(fontFamily: "OpenSans"),
                  ),
                  content: Container(
                    height: 300,
                    width: 300,
                    child: Form(
                        key: key,
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  top: 6.0, left: 6.0, right: 6.0),
                              margin: EdgeInsets.only(top: 3.0),
                              child: TextFormField(
                                controller: _cardController,
                                maxLength: 16,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.payment),
                                  hintText: "Card Number",
                                  hintStyle: TextStyle(fontFamily: "OpenSans"),
                                ),
                                style: TextStyle(fontFamily: "OpenSans"),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 6.0, left: 6.0, right: 6.0),
                                margin: EdgeInsets.only(top: 3.0),
                                child: TextFormField(
                                  controller: _currencyController,
                                  maxLength: 3,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.monetization_on),
                                      hintText:
                                          "Enter the type of your Currency",
                                      hintStyle:
                                          TextStyle(fontFamily: "OpenSans")),
                                  style: TextStyle(fontFamily: "OpenSans"),
                                )),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 6.0, left: 6.0, right: 6.0),
                                margin: EdgeInsets.only(top: 3.0),
                                child: TextFormField(
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.date_range),
                                      hintText: "Expiry Date",
                                      hintStyle:
                                          TextStyle(fontFamily: "OpenSans")),
                                  style: TextStyle(fontFamily: "OpenSans"),
                                )),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 6.0, left: 6.0, right: 6.0),
                                margin: EdgeInsets.only(top: 3.0),
                                child: TextFormField(
                                  controller: _balanceController,
                                  maxLength: 7,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.date_range),
                                      hintText: "Enter your  Net Balance",
                                      hintStyle:
                                          TextStyle(fontFamily: "OpenSans")),
                                  style: TextStyle(fontFamily: "OpenSans"),
                                )),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 6.0, left: 6.0, right: 6.0),
                                margin: EdgeInsets.only(top: 3.0),
                                alignment: Alignment.topRight,
                                child: FlatButton(
                                  color: Colors.teal,
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(fontFamily: "OpenSans"),
                                  ),
                                  onPressed: () {
                                    newCard();
                                  },
                                ))
                          ],
                        )),
                  ),
                ),
              );
            });
          }),
    );
  }
}
