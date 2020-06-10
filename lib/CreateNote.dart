import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Note.dart';
import 'HomePage.dart';


class CreateNote extends StatelessWidget {

  final String email;
  final Firestore _fireStore = Firestore.instance;
  String title, message;
  final formKey = new GlobalKey<FormState>();
  CreateNote({Key key, @required this.email}) : super(key: key);

  void validateAndSubmit(BuildContext context) async{
    if(validateAndSave()){
      try {
          Note note = Note(title, message, email);
          await _fireStore.collection("Note")
              .document()
              .setData({
            'title': title,
            'message': message,
            'user_email': email
          });

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(email: email)));
      } catch(e){
        print('Error: $e');
      }
    }
  }

  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    } else {
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title : new Text ('Create A Note'),
    ),

      body:Center(
          child:  new Container(
            padding: const EdgeInsets.all(50.0),
            child: new Column (

              children: <Widget>[ new Container(

              child: new Form(
                key: formKey,
                child: new Column(

                children: <Widget>[

                  new Text( "Please write your Note Title", style : new TextStyle (fontSize : 20.00)),
                  new TextFormField
                    (
                    decoration: new InputDecoration(labelText: 'Title'),
                    validator: (value) => value.isEmpty ? 'Title cant be empty':null,
                    onSaved: (value) => title = value,
                  ),

                    new Text( "Please write your Note", style : new TextStyle (fontSize : 20.00)),
                    new TextFormField(
                    decoration: new InputDecoration(labelText: 'Note'),
                    validator: (value) => value.isEmpty ? 'Note cant be empty':null,
                    onSaved: (value) => message = value,

                  ),
                  new RaisedButton(
                    child : new Text('Submit', style : new TextStyle (fontSize : 20.00)),
                    onPressed: (){validateAndSubmit(context);},

                  )
                ],
                  )
                )
              )
            ]

          )

      )

    )
    );
  }




}