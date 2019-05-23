import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardDetailPage extends StatefulWidget {
  final id;
  CardDetailPage(this.id);
  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  var expenses = [];
  int expense;
//Controller
  var _expenseController = new TextEditingController();
  var _formKey = new GlobalKey<FormState>();
  var _titleController = new TextEditingController();
  var _contentController = new TextEditingController();

  var card = {};
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getCard();
  }

  Widget expenseCard(List expenses) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: expenses.map((item) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0),
                      margin: EdgeInsets.only(top: 6.0, left: 10.0),
                      child: Text(
                        "Title :" +
                        item['title'.toString()].toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "OpenSans",
                            fontSize: 20.0,
                           ),
                      ),
                    ),
                      Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0),
                      margin: EdgeInsets.only(top: 6.0, left: 10.0),
                      child: Text(
                            item['content'].toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "OpenSans",
                            fontSize: 20.0,
                            ),
                      ),
                    ),
                      Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0),
                      margin: EdgeInsets.only(top: 6.0, left: 10.0),
                      child: Text(
                          "Amount Spent  : " +
                            card['currency'] +      item['amountSpent'].toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "OpenSans",
                            fontSize: 20.0,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }).toList());
  }

  postExpense() {
    var expense;
    setState(() {
      if (int.parse(_expenseController.text) <
          int.parse(card['availableBalance'])) {
        expense = {
          "id": "",
          "title": _titleController.text,
          "content": _contentController.text,
          "amountSpent": _expenseController.text
        };

        setState(() {
          //expenses.add(expense);
          var tempbal = int.parse(card['availableBalance']) -
              int.parse(_expenseController.text);
          expense = tempbal;
        });
      } else {
        setState(() {
          showDialog(
              context: context,
              child: AlertDialog(
                title:
                    Text("Warning", style: TextStyle(fontFamily: "OpenSans")),
                content: Text(
                  "You have Insufficient Balance",
                  style: TextStyle(fontFamily: "OpenSans"),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok", style: TextStyle(fontFamily: "OpenSans")),
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ],
              ));
        });
      }
    });

    SharedPreferences.getInstance().then((prefs) {
      Firestore.instance
          .collection('profile')
          .document(prefs.getString('id'))
          .collection('Cards')
          .document(widget.id)
          .updateData({"availableBalance": expense.toString()});
      Firestore.instance
          .collection('profile')
          .document(prefs.getString('id'))
          .collection('Cards')
          .document(widget.id)
          .collection('Expenses')
          .add({
        "id": "",
        "title": _titleController.text,
        "content": _contentController.text,
        "amountSpent": _expenseController.text
      }).then((doc) {
        doc.updateData({"id": doc.documentID});
      });
    });
  }

  getCard() {
    setState(() {
      isLoading = true;
    });
    SharedPreferences.getInstance().then((prefs) {
      Firestore.instance
          .collection('profile')
          .document(prefs.getString('id'))
          .collection('Cards')
          .document(widget.id)
          .snapshots()
          .listen((data) {
        setState(() {
          card["cardNumber"] = data.data['cardNumber'];
          card['balance'] = data.data['balance'];
          card['currency'] = data.data['currency'];
          card['availableBalance'] = data.data['availableBalance'];
          expense = int.parse(data.data['availableBalance']);
          card['expiryDate'] = data.data['expiryDate'];
          Firestore.instance
              .collection('profile')
              .document(prefs.getString('id'))
              .collection('Cards')
              .document(widget.id)
              .collection("Expenses")
              .snapshots()
              .listen((data) {
            setState(() {
              expenses = data.documents;
            });
          });
          isLoading = false;
        });
      });
    });
  }

  Future refresh() async {
    setState(() {
      getCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.note_add),
          backgroundColor: Colors.redAccent,
          onPressed: () {
            setState(() {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text(
                      "Expense",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    content: Container(
                      height: 300,
                      width: 300,
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  top: 5.0, left: 5.0, right: 5.0),
                              margin: EdgeInsets.only(top: 3.0),
                              child: TextFormField(
                                controller: _titleController,
                                maxLength: 10,
                                validator: (String value) {
                                  if (value == '') {
                                    return "This must  not be empty";
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Title",
                                  hintStyle: TextStyle(fontFamily: "OpenSans"),
                                ),
                                style: TextStyle(fontFamily: "OpenSans"),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 5.0, left: 5.0, right: 5.0),
                              margin: EdgeInsets.only(top: 3.0),
                              child: TextFormField(
                                controller: _contentController,
                                maxLength: 100,
                                validator: (String value) {
                                  if (value == '') {
                                    return "This must  not be empty";
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "About the Expense",
                                  hintStyle: TextStyle(fontFamily: "OpenSans"),
                                ),
                                style: TextStyle(fontFamily: "OpenSans"),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 5.0, left: 5.0, right: 5.0),
                              margin: EdgeInsets.only(top: 3.0),
                              child: TextFormField(
                                controller: _expenseController,
                                maxLength: 7,
                                validator: (String value) {
                                  if (value == '') {
                                    return "This must  not be empty";
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Amount Spent",
                                  hintStyle: TextStyle(fontFamily: "OpenSans"),
                                ),
                                style: TextStyle(fontFamily: "OpenSans"),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(
                                  top: 6.0, left: 6.0, right: 6.0),
                              margin: EdgeInsets.only(top: 6.0),
                              child: FlatButton(
                                child: Text(
                                  "ADD",
                                  style: TextStyle(fontFamily: "OpenSans"),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    postExpense();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            });
          },
        ),
        body: Column(
    mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              children: <Widget>[

                Container(
                
                    margin: EdgeInsets.only(top: 3.0,left:2.0),

                  child:Card(
                child: Column(
                  children: <Widget>[
                     
                  Container(
                     padding: EdgeInsets.only(
                                  top: 6.0, left: 6.0, right: 6.0),
                
                    margin: EdgeInsets.only(top: 3.0,left:2.0),

                  child:Card(
                child: Text("Total Balance : "+ card['balance'].toString(),style: TextStyle(fontFamily: "OpenSans",fontSize: 30.0), ),
              ) ,
                ),
              
                
                   Container(
                     padding: EdgeInsets.only(
                                  top: 6.0, left: 6.0, right: 6.0),
                
                    margin: EdgeInsets.only(top: 3.0,left:2.0),

                  child:Card(
                child: Text("Available Balance : "+ expense.toString(),style: TextStyle(fontFamily: "OpenSans",fontSize: 30.0), ),
              ) ,
                ),
                    
                  ],
                ))),
                
                
               
                Divider
                (color: Colors.white70
                ,),
                expenses.length !=0 ? expenseCard(expenses)
                :Center(child: Text("No Expenses Found",style: TextStyle(fontFamily: "OpenSans",),))
              
              ],
            )

          ],
        ),
        


    );
  }
}
