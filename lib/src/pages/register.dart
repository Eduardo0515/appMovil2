import 'dart:convert';
import 'dart:io';

import 'package:appflutterc3movil/src/models/Register.dart';
import 'package:appflutterc3movil/src/pages/home.dart';
import 'package:appflutterc3movil/src/pages/profile.dart';
import 'package:appflutterc3movil/src/pages/register.dart';
import 'package:appflutterc3movil/src/pages/saveprofile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appflutterc3movil/src/models/Login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  // Initially password is obscure
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<RegisterPage> {
  Future<List<Register>> registerFinal;
  Register registerD;

  Future<List<Register>> postRegister(
      String user, String password1, String password2) async {
    List<Register> registro = [];

    String url = 'http://34.239.109.204/api/v1/registration/';

    Map<String, String> params = {
      "username": user,
      "password1": password1,
      "password2": password2
    };

    Map<String, String> header = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    Uri uri = Uri.parse(url);

    final response =
        await http.post(uri, headers: header, body: jsonEncode(params));

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      registro.add(Register(jsonData['token'], response.statusCode));
      return registro;
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  bool hidePassword = true;
  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
    //loginFinal = postLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
          title: Text('Login Screen App'),
        ),*/
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        SizedBox(height: 250),
        Container(
          padding: EdgeInsets.fromLTRB(60, 10, 60, 20),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Usuario',
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
          child: Column(
            children: [
              TextField(
                obscureText: hidePassword,
                controller: passwordController1,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Theme.of(context).accentColor.withOpacity(0.9),
                    icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                obscureText: hidePassword,
                controller: passwordController2,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  labelText: 'Confirmar contraseña',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Theme.of(context).accentColor.withOpacity(0.9),
                    icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
            ],
          ),
        ),
        FlatButton(
          onPressed: () {
            //forgot password screen
          },
          textColor: Colors.blue,
          //child: Text('Forgot Password'),
        ),
        Container(
            height: 50,
            width: 310,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Registrarse', style: TextStyle(fontSize: 18)),
              onPressed: () {
                print(nameController.text);
                print(passwordController1.text);
                print(passwordController2.text);
                registerFinal = postRegister(nameController.text,
                    passwordController1.text, passwordController2.text);
                registerFinal.then((value) => {
                      if (value == null)
                        {
                          print("ERROR - Revise los datos ingresados"),
                          Fluttertoast.showToast(
                              msg: 'Revise los datos ingresados',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 20.0)
                        }
                      else
                        {
                          print("OK - registro correcto"),
                          print("Token user: "),
                          print(value[0].token),
                          registerD = Register(value[0].token, value[0].status),
                          Fluttertoast.showToast(
                              msg: 'Registro correcto',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 20.0),
                        }
                    });
              },
            )),
      ],
    )));
  }
}
