import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardDetailPage extends StatefulWidget {
  var id;
  CardDetailPage(this.id);
  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  var expenses=[];
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
  Widget expenseCard(List expenses){

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
          card['expiryDate'] = data.data['expiryDate'];
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
                                   child: Text("ADD",style: TextStyle(fontFamily: "OpenSans"),),
                                   onPressed: (){
                                     
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
        body: RefreshIndicator(
            onRefresh: refresh,
            child: !isLoading
                ? Container(
                    padding: EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0),
                    margin: EdgeInsets.only(top: 20.0),
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                    top: 6.0, left: 6.0, right: 6.0),
                                margin: EdgeInsets.only(top: 6.0),
                                child: Text(
                                  "Card Number " +
                                      card['cardNumber'].toString(),
                                  style: TextStyle(
                                      fontFamily: "Opensans", fontSize: 20.0),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                    top: 6.0, left: 6.0, right: 6.0),
                                margin: EdgeInsets.only(top: 6.0),
                                child: Text(
                                  "TotalBalance  " +
                                      card['currency'] +
                                      ' ' +
                                      card['balance'].toString(),
                                  style: TextStyle(
                                      fontFamily: "Opensans", fontSize: 20.0),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                    top: 6.0, left: 6.0, right: 6.0),
                                margin: EdgeInsets.only(top: 6.0),
                                child: Text(
                                  "AvailableBalance  " +
                                      card['currency'] +
                                      ' ' +
                                      card['availableBalance'].toString(),
                                  style: TextStyle(
                                      fontFamily: "Opensans", fontSize: 20.0),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                    top: 6.0, left: 6.0, right: 6.0),
                                margin: EdgeInsets.only(top: 6.0),
                                child: Text(
                                  "Valid Upto  " +
                                      card['expiryDate'].toString(),
                                  style: TextStyle(
                                      fontFamily: "Opensans", fontSize: 20.0),
                                ),
                              ),
                             
                            ],
                          ),
                        ),
                        
                        Divider(
                          color: Colors.white70,
                        ),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            expenses.length != 0 ?  
                            ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (BuildContext context,int i){
                                return expenseCard(expenses[i]);
                              },
                            ):Container()

                          ]
      
                        )
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator())));
  }
}
