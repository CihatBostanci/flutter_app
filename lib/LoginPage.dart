
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage>{

  final formKey = new GlobalKey<FormState>();
  String _email ;
  String _password;
  FormType _formType = FormType.login;


  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if(validateAndSave()){
      try {
        if(_formType == FormType.login){
          FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          print('Signed in : ${_email}, ${_password}');
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(email: _email)));
        } else {
          FirebaseAuth.instance.createUserWithEmailAndPassword(email:_email, password: _password);
          print('Created in : ${_email}, ${_password}');
          moveLogin();

        }


      } catch(e){
        print('Error: $e');
      }
    }
  }
  void moveRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;

    });
  }

  void moveLogin(){
    setState(() {
      _formType = FormType.login;

    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title : new Text ('Flutter Note App Account'),
        ),
        body:Center(
            child: new Container(
              padding: const EdgeInsets.all(60.0),
                  child: new Form(
                    key: formKey,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: buildInputs() + submitButtons(),

                    ),
                  )
              )
        )
    );
  }

  List<Widget> buildInputs(){
        return [
          new TextFormField
            (
            decoration: new InputDecoration(labelText: 'Email'),
            validator: (value) => value.isEmpty ? 'Email cant be empty':null,
            onSaved: (value) => _email = value,
          ),
          new TextFormField(
            decoration: new InputDecoration(labelText: 'Passsword'),
            obscureText :true,
            validator: (value) => value.isEmpty ? 'Password cant be empty':null,
            onSaved: (value) => _password = value,

          ),
        ];
  }

  List<Widget> submitButtons(){

    if(_formType == FormType.login){
      return [
        new RaisedButton(
          child : new Text('Login', style : new TextStyle (fontSize : 20.00)),
          onPressed: validateAndSubmit,

        ),
        new FlatButton(
          child: new Text('Create an account',style: new TextStyle(fontSize: 20)),
          onPressed: moveRegister,
        ),
      ];
    } else {
      return [
           new RaisedButton(
              child : new Text('Create an account', style : new TextStyle (fontSize : 20.00)),
              onPressed: validateAndSubmit,

            ),
           new FlatButton(
            child: new Text('Have an account? Please login again.',style: new TextStyle(fontSize: 20)),
            onPressed: moveLogin,
            ),
          ];
    }


  }

}
