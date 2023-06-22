import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'register.dart';
import 'package:get/get.dart';
import 'screens/home.dart';
import 'screens/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? email = sharedPreferences.getString('email');

  runApp(MyApp(email: email));
}

class MyApp extends StatelessWidget {
  final String? email;

  const MyApp({Key? key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: email != null ? HomePage() : newHome(),
      routes: {
        '/loading': (context) => LoadingScreen(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

class newHome extends StatefulWidget {
  @override
  _newHomeState createState() => _newHomeState();
}

class _newHomeState extends State<newHome> {
  bool _loggedOut = false;

  @override
  void initState() {
    super.initState();

  }



  int counter = 0;
  String displayText = "";

  final dbhelper = Databasehelper.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<String> _login() async {
    var allrows = await dbhelper.queryspecific(email.text, password.text);
    if (allrows.isNotEmpty) {
      var result = "row not found!"; // Default value
      allrows.forEach((row) {
        if (row["email"] == email.text && row["password"] == password.text) {
          result = "Success";
        } else {
          result = "incorrect username";
        }
      });
      return result; // Return the result after the loop
    } else {
      return "No User Found!";
    }
  }

  Future<void> _saveEmail(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('email', email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          'LOGIN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Satisfy-Regular',
          ),
        ),
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
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: password,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "The field is empty!";
                    }
                    return null;
                  },
                ),
                ElevatedButton.icon(
                  label: Text('login'),
                  icon: Icon(Icons.login_outlined),
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      _login().then((result) {
                        if (result == "Success") {
                          setState(() {
                            displayText = result;
                          });
                          _saveEmail(email.text).then((_) {
                            Navigator.of(context).pushReplacementNamed('/loading');
                          });
                        } else {
                          setState(() {
                            displayText = result;
                          });
                        }
                      });
                    } else {
                      debugPrint("There is some problem");
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => register()),
                    );
                  },
                  child: Text("Register"),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 25.5,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
