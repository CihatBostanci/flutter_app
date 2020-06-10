import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Note.dart';


class MessageDetail extends StatelessWidget{
  final String email;
  final String title;
  final int index;

   String varMessage;
   String varDocumentID;
   String varTitle;
   String rememberTitle;
   String rememberMessage;

  MessageDetail({Key key, @required this.email,@required this.title, @required this.index}) : super(key: key);

  final Firestore _fireStore = Firestore.instance;
  Map<String, dynamic> _convertProductToMap( Note note )
  {
    Map<String, dynamic> map = {};
    map['title'] = note.title;
    map['user_email'] = note.user_email;
    map['message'] = note.message;

    return map;
  }
  Future updatePostTitle(String documentId, String varTitle) async {
    Note note;
    if(varMessage != null){
      note = Note (varTitle, varMessage, email);
    } else {
      note = Note(varTitle, rememberMessage,email);
    }

    final Map<String,dynamic> map = _convertProductToMap(note);
    try {
      await _fireStore
          .collection("Note")
          .document(documentId)
          .updateData(map);
      return true;
    } catch (e) {
      return e.toString();
    }
  }
  Future updatePost(String documentId, String varMessage) async {
    Note note;
    if(title != null){
      note = Note (title, varMessage, email);
    } else {
      note = Note(rememberTitle, varMessage,email);
    }


   final Map<String,dynamic> map = _convertProductToMap(note);
    try {
      await _fireStore
          .collection("Note")
          .document(documentId)
          .updateData(map);
      return true;
    } catch (e) {
      return e.toString();
    }
  }
  void ChangeTheText(String docID,String text) async{
   varMessage = text;
   varDocumentID = docID;
   print(varMessage);

   _fireStore
       .collection("Note")
       .document()
       .updateData({"message": varMessage}).then((_) {
     print("success!");
   });
  }
  void ChangeTheTitle(String docID,String text) async{
    varTitle = text;
    varDocumentID = docID;
    print(varMessage);

    _fireStore
        .collection("Note")
        .document()
        .updateData({"message": varMessage}).then((_) {
      print("success!");
    });
  }
  Future<bool> _onBackPressed(BuildContext context) {
    Navigator.of(context).pop(true);
  }


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop:(){ _onBackPressed(context);},
        child :new Scaffold(

            appBar: new AppBar(
            title : new Text ('Flutter Note App Message Detail'),
         ),

            body:Center (
                child:new Container (


                padding: const EdgeInsets.all(50.0),

                 child: new Column (

                    children  : <Widget> [ new Container(child :StreamBuilder<QuerySnapshot>(

                        stream: _fireStore
                                .collection("Note")
                                .where(email)
                                .where(title)
                                .snapshots(),

                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) return  const Text('Loading...');
                          final DocumentSnapshot document = snapshot.data.documents[index];
                          final dynamic message = document['message'];
                          final dynamic rettitle   = document ['title'];
                           rememberMessage = message ;
                           rememberTitle   = rettitle;
                          return new Column(


                            children: <Widget>[
                                new Text( "Please write your Note Title", style : new TextStyle (fontSize : 20.00)),
                                new TextField( controller: TextEditingController()..text = rettitle.toString(),
                                    onChanged: (text) => { ChangeTheTitle(document.documentID,text)
                                    } , style: new TextStyle (fontSize: 20.00)),
                              new Text( "Please write your Note", style : new TextStyle (fontSize : 20.00)),
                              new TextField( controller: TextEditingController()..text = message.toString(),
                                  onChanged: (text) => { ChangeTheText(document.documentID,text)
                                  } , style: new TextStyle (fontSize: 20.00))
                              ],
                            );



                }
                )
            ),
                     new Container(
                         child : new FlatButton(
                           color: Colors.blue,
                           textColor: Colors.white,
                           disabledColor: Colors.grey,
                           disabledTextColor: Colors.black,
                           padding: EdgeInsets.all(8.0),
                           splashColor: Colors.blueAccent,
                           child : Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Note Submit", style : new TextStyle (fontSize : 20.00)),
                            ),

                            onPressed: () {

                                          updatePost(varDocumentID, varMessage);
                                          updatePostTitle(varDocumentID, varTitle);},

                          )
                     )
                    ]
                )
               )
         )
    )
  );

  }

}
