import 'package:stuclass/src/lecture_material.dart';

import 'login.dart';
import 'subject.dart';
import 'attend.dart';
import 'base.dart';
import 'auth.dart';

class Eclass {
  late String _id;
  final BaseInfo _baseInfo = BaseInfo('', '', '');
  late Login login;
  late Auth auth;
  late Subject subject;
  late Attend attend;
  late LectureMaterial lectureMaterial;

  Eclass(String id, String password) {
    _id = id;
    login = Login(id, password);
  }

  Future<void> initalize() async {
    final baseinfo = await login.getLoginInfo();
    if (baseinfo['LMS_SESSIONID'] == '') throw 'id or password not matched';
    _baseInfo(_id, baseinfo['LMS_SESSIONID']!, baseinfo['WMONID']!);

    auth = Auth(_baseInfo);

    subject = Subject(_baseInfo, auth);
    attend = Attend(_baseInfo, auth, subject);
    lectureMaterial = LectureMaterial(_baseInfo, auth);
  }
}
