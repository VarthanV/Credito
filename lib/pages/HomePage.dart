import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var key=GlobalKey<FormState>();
 
  var currency ={'JPY':' ¥ ','INR': '₹','Yuan':'¥','EU':'€'};
  //Controllers
  var _currencyController =new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        
        title: Text("Credito",style: TextStyle(fontFamily: "Opensans"),),
        centerTitle: true,
    
      ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.red,
      foregroundColor: Colors.black,
      child: Icon(Icons.add),
      onPressed: (){
        setState(() {
          showDialog(
            context: context,
            barrierDismissible: true,
            child: Form(
              
              key: key,
              child:ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 6.0,left: 6.0,right: 6.0),
                    margin: EdgeInsets.only(top:3.0),
                    child: TextFormField(
                      controller: _currencyController,
                      maxLength: 16,
                      decoration: InputDecoration(
                        icon:Icon(Icons.payment),
                        hintText: "Card Number",
                        hintStyle: TextStyle(fontFamily:"OpenSans" )
                        
                      ),
                      style: TextStyle(fontFamily: "OpenSans"),


                    ),
                  )
                  
                ],
              ) 
            )

          
            

          );
         
          
        });

      }
    ),
      
      
    );
  }
}