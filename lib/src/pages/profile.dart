import 'dart:convert';

import 'package:appflutterc3movil/src/models/userProfile.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

List<UserProfile> parseListProfile(String reponseBody) {
  final parsed = jsonDecode(reponseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<UserProfile>((json) => UserProfile.fromJson(json)).toList();
}

Future<List<UserProfile>> fechtProfileDetail(http.Client client) async {
  final response = await http.get(
      Uri.parse('http://34.239.109.204/api/v1/profile/profile_detail/42/'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Token cbb26288d097255ebf4e4a02339ad53561e64c40"
      });

  return parseListProfile(response.body);
}

class Profile extends StatelessWidget {
  final String idprofile;

  Profile({Key keys, @required this.idprofile}) : super(key: keys);

  List<UserProfile> parseListProfile(String reponseBody) {
    final parsed = jsonDecode(reponseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<UserProfile>((json) => UserProfile.fromJson(json))
        .toList();
  }

  Future<List<UserProfile>> fechtProfileDetail(http.Client client) async {
    final response = await http.get(
        Uri.parse(
            'http://34.239.109.204/api/v1/profile/profile_detail/${idprofile}/'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Token cbb26288d097255ebf4e4a02339ad53561e64c40"
        });

    return parseListProfile(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Profile " + idprofile),
      ),
      body: FutureBuilder<List<UserProfile>>(
        future: fechtProfileDetail(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ProfileList(profilesList: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ProfileList extends StatelessWidget {
  final List<UserProfile> profilesList;

  ProfileList({Key key, this.profilesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: profilesList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            height: 40,
            padding: const EdgeInsets.all(8),
            child: Text(
              profilesList[index].name + " " + profilesList[index].lastName,
              style: TextStyle(fontSize: 20),
            ));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
