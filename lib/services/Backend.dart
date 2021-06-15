import 'dart:convert';
import 'dart:io';
import 'package:diplom_app/models/Form.dart';
import 'package:diplom_app/models/Note.dart';
import 'package:diplom_app/models/NoteModel.dart';
import 'package:diplom_app/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:http_parser/src/media_type.dart';
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
      host: '192.168.0.134',
      port: 4000,
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
        return FormModel.fromJSON(e);
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

  static Future<User> givePermissionToken(String token) async {
    Response res = await post(getUrl('/user/givePermission'),
        headers: {..._json, ...(await _cookie)},
        body: jsonEncode({"permissionToken": token}));
    return User.fromJson(jsonDecode(res.body));
  }

  static Future<User> createUser(User user) async {
    Response res = await post(getUrl('/user'),
        headers: {..._json, ...(await _cookie)},
        body: jsonEncode(user.toJson()));
    return User.fromJson(jsonDecode(res.body));
  }

  static Future<dynamic> createNote(Note note, File file, String filelabel,
      {String id}) async {
    print(id);
    if (file != null) {
      MultipartRequest request =
          MultipartRequest("POST", Uri.parse('http://192.168.0.134:4000/note'))
            ..headers.addAll(await _cookie);

      MultipartFile multipartFile = MultipartFile.fromBytes(
          filelabel, file.readAsBytesSync(),
          filename: 'test.jpeg', contentType: MediaType('image', 'jpeg'));
      request.files.add(multipartFile);
      if (id != null) request.fields['userId'] = id;
      request.fields['name'] = note.name;
      request.fields['created_at'] = note.date.toIso8601String() + "Z";
      request.fields['form'] = note.form;
      for (int i = 0; i < note.fields.length; i++) {
        request.fields[note.fields[i].label] = note.fields[i].value;
      }

      request.fields['tags'] = note.tags.toList().join(';');

      return request.send();
    } else {
      await post(getUrl('/note'),
          headers: {..._json, ...(await _cookie)},
          body: jsonEncode({...note.toJson(), if (id != null) "userId": id}));
    }
  }

  static Future<dynamic> updateNote(Note note, File file, String filelabel,
      {String id}) async {
    if (file != null) {
      MultipartRequest request =
          MultipartRequest("PUT", Uri.parse('http://192.168.0.134:4000/note'))
            ..headers.addAll(await _cookie);
      MultipartFile multipartFile = MultipartFile.fromBytes(
          filelabel, file.readAsBytesSync(),
          filename: 'test.jpeg', contentType: MediaType('image', 'jpeg'));
      request.files.add(multipartFile);
      request.fields['id'] = note.id;
      if (id != null) request.fields['userId'] = id;
      request.fields['name'] = note.name;
      request.fields['created_at'] = note.date.toIso8601String() + "Z";
      request.fields['form'] = note.form;
      for (int i = 0; i < note.fields.length; i++) {
        request.fields[note.fields[i].label] = note.fields[i].value;
      }
      request.fields['tags'] = note.tags.toList().join(';');
      return request.send();
    } else {
      await put(getUrl('/note'),
          headers: {..._json, ...(await _cookie)},
          body: jsonEncode({...note.toJson(), if (id != null) "userId": id}));
    }
  }

  static Future<List<NoteModel>> getPatientNotes(String id,
      {String orderField, String orderType, String tags}) async {
    try {
      Response res = await get(
          getUrl('/note/patient', {
            "patient_id": id,
            "orderField": orderField,
            "orderType": orderType,
            if (tags != '') "tags": tags
          }),
          headers: {..._json, ...(await _cookie)});
      List body = jsonDecode(res.body);

      List<NoteModel> serialized =
          body.map((e) => NoteModel.fromJson(e)).toList();
      return serialized;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<User>> getPatients() async {
    try {
      Response res = await get(getUrl('user/patients'),
          headers: {..._json, ...(await _cookie)});
      List body = jsonDecode(res.body);
      List<User> serialized = body.map((e) => User.fromJson(e)).toList();
      return serialized;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<User>> getDoctors() async {
    try {
      Response res = await get(getUrl('user/doctors'),
          headers: {..._json, ...(await _cookie)});
      List body = jsonDecode(res.body);
      List<User> serialized = body.map((e) => User.fromJson(e)).toList();
      return serialized;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<NoteModel>> getNotes(
      {String orderField, String orderType, String tags}) async {
    try {
      Response res = await get(
        getUrl('/note', {
          "orderField": orderField,
          "orderType": orderType,
          if (tags != '') "tags": tags
        }),
        headers: {...(await _cookie)},
      );

      List body = jsonDecode(res.body);

      List<NoteModel> serialized = body.map((e) {
        return NoteModel.fromJson(e);
      }).toList();
      return serialized;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
