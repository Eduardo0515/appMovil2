import 'dart:async';
import 'dart:convert';

import 'package:appflutterc3movil/src/models/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UpdateProfile extends StatefulWidget {
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _cntrlrName = TextEditingController();
  final TextEditingController _cntrlrLName = TextEditingController();
  final TextEditingController _cntrlrPhone = TextEditingController();
  final TextEditingController _cntrlrAddress = TextEditingController();
  final TextEditingController _cntrlrUser = TextEditingController();
  final TextEditingController _cntrlrEmail = TextEditingController();

  Future<UserProfile> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = fetchUser();
    showCurrentInfo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Actualizar información'),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<UserProfile>(
            future: _futureUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 45),
                        color: Color.fromRGBO(249, 246, 239, 1.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 80.0,
                            ),
                            _userTextField("Nombre", "Nombre", _cntrlrName),
                            SizedBox(
                              height: 50.0,
                            ),
                            _userTextField(
                                "Apellido", 'Apellido', _cntrlrLName),
                            SizedBox(
                              height: 50.0,
                            ),
                            _userTextField(
                                "Teléfono", 'Teléfono', _cntrlrPhone),
                            SizedBox(
                              height: 50.0,
                            ),
                            _userTextField(
                                "Dirección", 'Dirección', _cntrlrAddress),
                            SizedBox(
                              height: 50.0,
                            ),
                            _userTextField("Email", 'Email', _cntrlrEmail),
                            SizedBox(
                              height: 50,
                            ),
                            _btnUpdate(),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              }

              return CircularProgressIndicator();
            },
          ),
        ));
  }

  _userTextField(label, hint, controller) {
    return Container(
        child: Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(fontSize: 17.0),
        ),
      ),
      TextField(
        keyboardType: TextInputType.name,
        controller: controller,
        decoration: InputDecoration( counterText: ""),
        maxLength: 100,
      ),
    ]));
  }

  _userNumberField(label, hint) {
    return Container(
        child: Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(label.toString()),
      ),
      TextField(
        keyboardType: TextInputType.number,
        controller: _cntrlrUser,
        decoration:
            InputDecoration(labelText: hint, hintText: label.toString()),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    ]));
  }

  _btnUpdate() {
    return ElevatedButton(
      child: Text('Actualizar información'),
      onPressed: () {
        setState(() {
          _futureUser = updateUserProfile(
              _cntrlrName.text,
              _cntrlrLName.text,
              _cntrlrPhone.text,
              _cntrlrAddress.text,
              int.parse(_cntrlrUser.text),
              _cntrlrEmail.text);
        });
      },
    );
  }

  showCurrentInfo() {
    _futureUser.then((value) => {
          this._cntrlrName.text = value.name,
          this._cntrlrLName.text = value.lastName,
          this._cntrlrPhone.text = value.phone,
          this._cntrlrAddress.text = value.address,
          this._cntrlrUser.text = value.user.toString(),
          this._cntrlrEmail.text = value.email
        });
  }
}

Future<UserProfile> updateUserProfile(String name, String lName, String phone,
    String address, int user, String email) async {
  final http.Response response = await http.put(
    Uri.parse('http://34.239.109.204/api/v1/profile/profile_detail/6/'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      "Authorization": "Token cbb26288d097255ebf4e4a02339ad53561e64c40"
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

  if (response.statusCode == 200) {
    return UserProfile.fromJson(jsonDecode(response.body));
  } else {
    print("Failed to load user "+response.body);
  }
}

Future<UserProfile> fetchUser() async {
  final response = await http.get(
      Uri.parse('http://34.239.109.204/api/v1/profile/profile_detail/6/'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Token cbb26288d097255ebf4e4a02339ad53561e64c40"
      });
  print(response.body);
  if (response.statusCode == 200) {
    return UserProfile.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}
