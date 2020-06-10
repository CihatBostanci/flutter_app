import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MessageDetail.dart';
import 'CreateNote.dart';


class HomePage extends StatelessWidget{

  final String email;
   int varIndex;

  HomePage({Key key, @required this.email}) : super(key: key);

  final Firestore _fireStore = Firestore.instance;

  void ItemMessageChange(BuildContext context, String varTitle, int varIndex){

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MessageDetail(email: email, title: varTitle, index : varIndex )));

  }

  void createNote(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateNote(email: email )));

  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
       appBar: new AppBar(
            title : new Text ('Flutter Note App Home'),
       ),
       body:  new Container (
         padding: const EdgeInsets.all(10.0),
         child: StreamBuilder<QuerySnapshot>(
         stream: _fireStore
             .collection('Note')
             .where('user_email', isEqualTo: email)
             .snapshots(),
         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
           if (!snapshot.hasData) return const Text('Loading...');
           final int messageCount = snapshot.data.documents.length;
           return ListView.builder(
             itemCount: messageCount,
             itemBuilder: (_, int index) {
               varIndex = index;
               final DocumentSnapshot document = snapshot.data.documents[index];
               final dynamic title = document['title'];
               return new ListTile(
                 trailing: IconButton(
                   onPressed: () => document.reference.delete(),
                   icon: Icon(Icons.delete),
                 ),
                 title: FlatButton(
                   child :
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text( title != null ? title.toString() : '<No message retrieved>', style : new TextStyle (fontSize : 20.00)),
                      ),
                    onPressed: () {ItemMessageChange(context,title,index);},

                 ),
                 subtitle: Text('Message ${index + 1} of $messageCount'),
               );
             },
           );
         },
       )
     ),
     floatingActionButton: FloatingActionButton(
        onPressed: () {
            createNote(context);
          },
          child: Icon(Icons.add),
    backgroundColor: Colors.green,
    )
    );
  }

}