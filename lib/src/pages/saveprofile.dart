import 'dart:async';
import 'dart:convert';

import 'package:appflutterc3movil/src/models/Login.dart';
import 'package:appflutterc3movil/src/models/UserProfile.dart';
import 'package:appflutterc3movil/src/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SaveProfile extends StatefulWidget {
  final Login login;
  SaveProfile({Key keys, @required this.login}) : super(key: keys);
  @override
  State<SaveProfile> createState() => _SaveProfileState(login: login);
}

class _SaveProfileState extends State<SaveProfile> {
  final TextEditingController _cntrlrName = TextEditingController();
  final TextEditingController _cntrlrLName = TextEditingController();
  final TextEditingController _cntrlrPhone = TextEditingController();
  final TextEditingController _cntrlrAddress = TextEditingController();
  final TextEditingController _cntrlrUser = TextEditingController();
  final TextEditingController _cntrlrEmail = TextEditingController();
  final Login login;
  _SaveProfileState({@required this.login});

  Future<UserProfile> _futureUser;
  String error = "";
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Guardar información'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.list,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        login: login,
                      ),
                    ),
                  );
                },
              ),
            ]),
        body: SingleChildScrollView(
          child: (_futureUser == null)
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 45),
                      //color: Color.fromRGBO(249, 246, 239, 1.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80.0,
                          ),
                          _userTextField("Nombre", _cntrlrName),
                          SizedBox(
                            height: 50.0,
                          ),
                          _userTextField('Apellido', _cntrlrLName),
                          SizedBox(
                            height: 50.0,
                          ),
                          _userNumberField('Teléfono'),
                          SizedBox(
                            height: 50.0,
                          ),
                          _userTextField('Dirección', _cntrlrAddress),
                          SizedBox(
                            height: 50.0,
                          ),
                          _userTextField('Email', _cntrlrEmail),
                          SizedBox(
                            height: 50.0,
                          ),
                          _btnUpdate(),
                          SizedBox(
                            height: 50.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : FutureBuilder<UserProfile>(
                  future: _futureUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          //color: Color.fromRGBO(249, 246, 239, 1.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 80.0,
                              ),
                              _textData(snapshot.data.name, "Nombre"),
                              SizedBox(
                                height: 50.0,
                              ),
                              _textData(snapshot.data.lastName, "Apellido"),
                              SizedBox(
                                height: 50.0,
                              ),
                              _textData(snapshot.data.phone, "Teléfono"),
                              SizedBox(
                                height: 50.0,
                              ),
                              _textData(snapshot.data.address, "Dirección"),
                              SizedBox(
                                height: 50.0,
                              ),
                              _textData(snapshot.data.email, "Correo"),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Center(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 100),
                          child: Text(
                              "Ha ocurrido un error, llene todos los campos y verifique que las entradas sean correctas.")),
                    );
                  },
                ),
        ));
  }

  _userTextField(hint, controller) {
    return Container(
        child: Column(
      children: [
        Text(hint, style: TextStyle(fontSize: 16)),
        TextField(
          keyboardType: TextInputType.name,
          controller: controller,
          decoration: InputDecoration(counterText: "", hintText: hint),
          maxLength: 100,
        ),
      ],
    ));
  }

  _textData(text, description) {
    return new Container(
      //padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
      child: Card(
          color: Colors.white,
          child: new Container(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 130.0),
            child: Column(
              children: <Widget>[
                Text(description + ": " + text,
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ],
            ),
          ),
          shadowColor: Colors.grey),
    );
  }

  _userNumberField(hint) {
    return Container(
        child: Column(
      children: [
        Text(hint, style: TextStyle(fontSize: 16)),
        TextField(
          keyboardType: TextInputType.number,
          controller: _cntrlrPhone,
          decoration: InputDecoration(hintText: hint, counterText: ""),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          maxLength: 10,
        ),
      ],
    ));
  }

  _btnUpdate() {
    return ElevatedButton(
      child: Text('Guardar información'),
      onPressed: () {
        setState(() {
          _futureUser = saveUserProfile(
                  _cntrlrName.text,
                  _cntrlrLName.text,
                  _cntrlrPhone.text,
                  _cntrlrAddress.text,
                  login.user_id,
                  _cntrlrEmail.text,
                  login.token)
              .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(
                        login: login,
                      )),
            ),
          );
        });
      },
    );
  }
}

Future<UserProfile> saveUserProfile(String name, String lName, String phone,
    String address, int user, String email, String token) async {
  final response = await http.post(
    Uri.parse('http://34.239.109.204/api/v1/profile/profile_list/'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      "Authorization": "Token " + token
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'lastName': lName,
      'phone': phone,
      'address': address,
      'user': user,
      'email': email
    }),
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    return UserProfile.fromJson(jsonDecode(response.body));
  } else {
    print("Failed to load user " + response.body);
  }
}
