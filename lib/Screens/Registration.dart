import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:regal_app/Screens/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegistrationState();
  }
}

class RegistrationState extends State<RegistrationScreen> {

  GlobalKey<ScaffoldState> registrationScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> registrationFromKey = GlobalKey<FormState>();



  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final passwordController = TextEditingController();
  final  confirmPwdInputController = TextEditingController();
  String _dateOfBirth = "Choose Date Of Birth";



  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  void _showDialog(String alertText) async{
    // flutter defined function
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert"),
          content: Text(alertText),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
//    resetData();
  }

  bool checkAllTextFieldValidation(){
    if (nameController.text.length == 0 || emailController.text.length == 0 || contactController.text.length == 0 || _dateOfBirth.length == 0 || passwordController.text.length == 0){
      return false;
    }else{
      return true;
    }
  }

  void resetData(){
    setState(() {
      _dateOfBirth = "Choose Date Of Birth";
    });
    nameController.text = "";
    emailController.text  = "";
    contactController.text = "";
    passwordController.text = "";
    confirmPwdInputController.text = '';
  }

  Widget _datePicker(){
    var dateTime = DateTime.now();
    return FlatButton(
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(1970, 1, 1),
              maxTime: dateTime, onChanged: (date) async {
              }, onConfirm: (date) {
                var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss.mmm');
                String formatted = formatter.format(date);
                var formatterN = new DateFormat(
                    "dd-MMM-yyyy");
                var selectedFormattedDate = DateTime.parse("$formatted");
                setState(() {
                  _dateOfBirth = formatterN.format(selectedFormattedDate);
                });
              }, currentTime: DateTime.now(), locale: LocaleType.en);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              _dateOfBirth,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black45),
            ),
          ],
        )
    );
  }

  Widget _buildRegistrationBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if (registrationFromKey.currentState.validate()) {
            if (passwordController.text ==
                confirmPwdInputController.text) {
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text)
                  .then((currentUser) => FirebaseFirestore.instance
                  .collection("registration")
                  .doc(currentUser.user.uid)
                  .set({
                "uid": currentUser.user.uid,
                'birthdate': _dateOfBirth,
                'contact':contactController.text,
                'email' : emailController.text,
                'name' : nameController.text,
                'password' : passwordController.text
              }).then((result)  {
                    print('completed registration');
                    _showDialogAfterInsertRecord('registration complete successful.');
              }).catchError((err) {
                print(err);
                _showDialog(err.toString());
              }
              )).catchError(
                      (err) {
                        print(err);
                        _showDialog(err.toString());
                      }
              );
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text("The passwords do not match"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }
          }
//            if(checkAllTextFieldValidation()){
//            print('API Call');
//            createRecord();
//            _showDialog('Data submitted.');
//          }else{
//            registrationScaffoldKey.currentState.showSnackBar(SnackBar(
//              behavior: SnackBarBehavior.floating,
//              backgroundColor: Colors.red,
//              content: Text('Please enter all fields',
//                style: TextStyle(color: Colors.white),
//              ),
//            ));
//          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Registration',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  void createRecord() async {
    final databaseReference = FirebaseFirestore.instance;
    databaseReference.collection("registration").add(
        {
          'birthdate': _dateOfBirth,
          'contact':contactController.text,
          'email' : emailController.text,
          'name' : nameController.text,
          'password' : passwordController.text
        }).then((value){
      print(value.toString());
      _showDialogAfterInsertRecord(value.toString());
    });
  }

  void _showDialogAfterInsertRecord(String alertText) async{
    // flutter defined function
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert"),
          content: Text(alertText),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return WillPopScope(
//      onWillPop: () async{
//        return false;
//      },
//      child: Scaffold(
//        key: registrationScaffoldKey,
//        appBar: AppBar(
//          title: Text('Registration'),
//        ),
//        body:
//        ListView(
//          children: <Widget>[
//            ListTile(
//              leading: const Icon(Icons.edit),
//              title: TextField(
//                enabled: true,
//                controller: nameController,
//                decoration: InputDecoration(
//                  hintText: 'Enter name',
//                  contentPadding: kContentPadding,
//
//                ),
//              ),
//            ),
//            ListTile(
//              leading: const Icon(Icons.email),
//              title: TextField(
//                enabled: true,
//                keyboardType: TextInputType.emailAddress,
//                controller: emailController,
//                decoration: InputDecoration(
//                  hintText: 'Enter Email',
//                    contentPadding: kContentPadding,
//                ),
//              ),
//            ),
//            ListTile(
//              leading: const Icon(Icons.call),
//              title: TextField(
//                enabled: true,
//                keyboardType: TextInputType.number,
//                controller: contactController,
//                decoration: InputDecoration(
//                  hintText: 'Enter Contact',
//                  contentPadding: kContentPadding,
//                ),
//              ),
//            ),
//            ListTile(
//              leading: const Icon(Icons.edit),
//              title: TextField(
//                controller: passwordController,
//                enabled: true,
//                decoration: InputDecoration(
//                  hintText: 'Choose Password',
//                  contentPadding: kContentPadding,
//                ),
//              ),
//            ),
//            ListTile(
//                leading: const Icon(Icons.calendar_today),
//                title: Container(
//                  decoration: BoxDecoration(
//                      border: Border(bottom: BorderSide(
//                          color: Colors.black45
//                      ))
//                  ),
//                  child: _datePicker(),
//                )
//            ),
//            SizedBox(
//              height: 50,
//            ),
//            ListTile(
//              title: _buildRegistrationBtn()
//            )
//          ],
//        ),
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: registrationScaffoldKey,
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
                  key:registrationFromKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Name*', hintText: "John"),
                        controller: nameController,
                        validator: (value) {
                          if (value.length < 3) {
                            return "Please enter a valid name.";
                          }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email*', hintText: "john.doe@gmail.com"),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator,
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Contact', hintText: "XXX"),
                          controller: contactController,
                          validator: (value) {
                            if (value.length < 3) {
                              return "Please enter a valid contact.";
                            }
                          }),
                      ListTile(
//                          leading: const Icon(Icons.calendar_today),
                          title: Container(
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    color: Colors.black45
                                ))
                            ),
                            child: _datePicker(),
                          )
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Password*', hintText: "********"),
                        controller: passwordController,
                        obscureText: true,
                        validator: pwdValidator,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Confirm Password*', hintText: "********"),
                        controller: confirmPwdInputController,
                        obscureText: true,
                        validator: pwdValidator,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildRegistrationBtn(),
                    ],
                  ),
                ))));
  }
}




