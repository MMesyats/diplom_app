import 'dart:convert';

import 'package:diplom_app/models/Form.dart';
import 'package:diplom_app/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:http/http.dart';

class Backend {
  static get token async =>
      await fb.FirebaseAuth.instance.currentUser.getIdToken();

  static get _json => ({'Content-Type': 'application/json'});
  static get _cookie async {
    String token = await Backend.token;
    return {"Cookie": "token=$token"};
  }

  static Uri getUrl(String pathname, [Map<String, dynamic> queryParams]) {
    return Uri(
      scheme: "http",
      host: '192.168.1.134',
      port: 3000,
      path: pathname,
      queryParameters: queryParams,
    );
  }

  static Future<User> getUserInfo() async {
    try {
      Response res = await get(
        getUrl('/user'),
        headers: {..._json, ...(await _cookie)},
      );
      return User.fromJson(jsonDecode(res.body));
    } catch (e) {
      return null;
    }
  }

  static Future<List<FormModel>> getForms() async {
    try {
      Response res = await get(
        getUrl('/note/form'),
        headers: {..._json, ...(await _cookie)},
      );
      List body = jsonDecode(res.body);
      return body.map((e) {
            return FormModel(e['_id'], e['name'], e['schema']);
      }).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String> getPermissionToken() async {
    try {
      Response res = await get(
        getUrl('/user/requestPermission'),
        headers: {...(await _cookie)},
      );
      final String token = jsonDecode(res.body)['permissionToken'];
      return token;
    } catch (e) {
      return null;
    }
  }

  static Future<User> createUser(User user) async {
    Response res = await post(getUrl('/user'),
        headers: {..._json, ...(await _cookie)},
        body: jsonEncode(user.toJson()));
    return User.fromJson(jsonDecode(res.body));
  }
}
