import 'dart:convert';

import 'package:stuclass/src/auth.dart';

import 'base.dart';
import 'cookie_manage.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class SubjectURI {
  static Uri main() {
    return Uri.parse('https://eclass.seoultech.ac.kr/ilos/main/main_form.acl');
  }

  static Uri move() {
    return Uri.parse(
        'https://eclass.seoultech.ac.kr/ilos/st/course/eclass_room2.acl');
  }
}

class Subject {
  late BaseInfo _baseInfo;
  late Auth _auth;
  Subject(this._baseInfo, this._auth);

  Future<List<Map<String, String>>> get() async {
    final ckString = BaseCookieManage.setCookie(_baseInfo);
    final res =
        await http.get(SubjectURI.main(), headers: {'Cookie': ckString});
    final document = parser.parse(res.body);
    List<Map<String, String>> output = [];
    for (final index in document.getElementsByClassName('sub_open')) {
      final tmp = index.text.trim().replaceAll(" ", "").split("\n\n");
      // implement exception control
      final subjectInfo = {
        "name": tmp[0],
        "id": tmp[1],
        "ky": index.attributes['kj']!
      };
      output.add(subjectInfo);
    }
    return output;
  }

  Future<void> move(String kj) async {
    final ck = {
      "_language_": "ko",
      "WMONID": _baseInfo.wmonid,
      "LMS_SESSIONID": _baseInfo.session
    };
    final ckString = CookieManage.setCookie(ck);
    final res = await http.post(SubjectURI.move(),
        headers: {'Cookie': ckString},
        body: jsonEncode(<String, String>{
          'KJKEY': kj,
          'returnData': 'json',
          'encoding': 'utf-8'
        }));
    final resJson = json.decode(res.body.trim());
    if (resJson['isError'] == 'true') {
      // error catcher implement
    } else {
      print('no error founded');
    }
  }
}
