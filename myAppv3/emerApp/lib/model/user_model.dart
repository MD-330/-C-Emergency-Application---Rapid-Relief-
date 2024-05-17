import 'dart:convert';

class UserModel {
  String? uid;
  String? setId;
  String? username;
  String? email;
  String? password;
  String? phone;
  String? photoUrl;


  UserModel();
  UserModel.fromJson(Map<String, dynamic> parsedJSON)
      : uid = parsedJSON['uid'],
        setId = parsedJSON['setId'],
        username = parsedJSON['username'],
        phone = parsedJSON['phone'],

      email = parsedJSON['email'],
        password = parsedJSON['password'],
        photoUrl = parsedJSON['photoUrl'];

  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'setId': setId,
      'username': username,
      'phone': phone,

      'email': email,
      'password': password,
      'photoUrl': photoUrl,
    };
  }

  static  String encode(List<UserModel> taskFile) => json.encode(
    taskFile
        .map<Map<String, dynamic>>((file) => file.toMap())
        .toList(),
  );

  static List<UserModel> decode(String? employee) =>
      (json.decode(employee!) as List<dynamic>)
          .map<UserModel>((dynamic item) => UserModel.fromJson(item))
          .toList();



}

