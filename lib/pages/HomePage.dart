import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CardDetail.dart';

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
  List cards = [];
  bool isLoading = false;
bool loading1=false;
  @override
  void initState() {
    super.initState();
    getCard();
  }

  getCard() {
    setState(() {
      isLoading = true;
    });
    SharedPreferences.getInstance().then((prefs) {
      SharedPreferences.getInstance().then((prefs) {
        Firestore.instance
            .collection('profile')
            .document(prefs.getString('id'))
            .collection('Cards')
            .snapshots()
            .listen((data) {
          setState(() {
            if (data.documents.length != 0) {
              cards.add(data.documents);
            }

            // print(data.documents[0]['cardNumber']);
          });
        });
      });
    });
  }

  Future refresh() async {
    setState(() {
      cards.clear();
      getCard();
    });
  }

  Widget displayCard(List cards) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: cards.map((item) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                elevation: 5.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CardDetailPage(item['id'])));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding:
                            EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0),
                        margin: EdgeInsets.only(top: 6.0, left: 10.0),
                        child: Text(
                          item['cardNumber'.toString()].toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "OpenSans",
                              fontSize: 20.0,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  top: 6.0, left: 6.0, right: 6.0),
                              margin: EdgeInsets.only(top: 6.0, left: 7.0),
                              child: Text(
                                "Balance:",
                                style: TextStyle(
                                    fontFamily: "OpenSans", fontSize: 20.0),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  top: 6.0, left: 6.0, right: 6.0),
                              margin: EdgeInsets.only(
                                top: 6.0,
                              ),
                              child: Text(
                                item['currency'].toString() +
                                    item['balance'].toString(),
                                style: TextStyle(
                                    fontFamily: "OpenSans", fontSize: 20.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  top: 6.0, left: 6.0, right: 6.0),
                              margin: EdgeInsets.only(top: 6.0, left: 7.0),
                              child: Text(
                                "Available Balance:",
                                style: TextStyle(
                                    fontFamily: "OpenSans", fontSize: 20.0),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  top: 6.0, left: 6.0, right: 6.0),
                              margin: EdgeInsets.only(
                                top: 6.0,
                              ),
                              child: Text(
                                item['currency'].toString() +
                                    item['availableBalance'].toString(),
                                style: TextStyle(
                                    fontFamily: "OpenSans", fontSize: 20.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }).toList());
  }

  newCard() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        Navigator.of(context).pop();
        loading1=true;
        email = prefs.getString('email');
        var id = prefs.getString('id');
        db.collection('profile').document(id).collection('Cards').add({
          "id": "",
          "cardNumber": _cardController.text,
          "currency": currency[_currencyController.text],
          "balance": _balanceController.text,
          "expiryDate": _dateController.text,
          "created": FieldValue.serverTimestamp(),
          "email": email,
          "availableBalance": _balanceController.text,
        }).then((doc) {
          setState(() {
            loading1=false;
            doc.updateData({"id": doc.documentID});
            _cardController.text ='';
            _currencyController.text='';
            _balanceController.text='';
            _dateController.text ='';



            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CardDetailPage(doc.documentID)));
          });
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
                                  validator: (String value) {
                                    if (value.length != 16) {
                                      return "Enter a valid Card Number";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.payment),
                                    hintText: "Card Number",
                                    hintStyle:
                                        TextStyle(fontFamily: "OpenSans"),
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
                                    maxLength: 5,
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
                              !loading1 ? Container(
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
                                  )):Container(child: CircularProgressIndicator(),)
                            ],
                          )),
                    ),
                  ),
                );
              });
            }),
        body: cards.length != 0
            ? RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (BuildContext context, int i) {
                    return displayCard(cards[i]);
                  },
                ))
            : Center(
                child: Text("No Cards found"),
              ));
  }
}
