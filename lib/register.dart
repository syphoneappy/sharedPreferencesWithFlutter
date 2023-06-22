import 'package:flutter/material.dart';
import 'dbhelper.dart';

class register extends StatefulWidget{
  @override
  _register createState() => _register();
}

class _register extends State<register> {


  final dbhelper = Databasehelper.instance;

  Future<String> _reg() async{

    Map<String, dynamic> row = {
      Databasehelper.columnEmail : email.text,
      Databasehelper.columnpassword : password.text,
    };

    final id = await dbhelper.insert(row);
    return "your id a has been registered $id. please login";
  }

  void queryData() async {
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      print(row);
    });
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String DisplayText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text('REGISTER',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Satisfy-Regular')),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(3.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: email,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "The field is empty!";
                    }
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  controller: password,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "The field is empty!";
                    }
                  },
                ),
                ElevatedButton.icon(
                  label: Text('Register'),
                  icon: Icon(Icons.app_registration),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() == true) {
                      String message = await _reg();
                      queryData();
                      setState(() {
                        DisplayText = message;
                      });
                    } else {
                      debugPrint("There is some problem");
                    }
                  },
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Login")
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    this.DisplayText,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
