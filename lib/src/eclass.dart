import 'login.dart';
import 'subject.dart';
import 'attend.dart';
import 'base.dart';

class Eclass {
  late String _id;
  final BaseInfo _baseInfo = BaseInfo('', '', '');
  late Login login;
  late Subject subject;
  late Attend attend;

  Eclass(String id, String password) {
    _id = id;
    login = Login(id, password);
  }

  Future<void> initalize() async {
    final baseinfo = await login.getLoginInfo();
    if (baseinfo['LMS_SESSIONID'] == '') throw 'id or password not matched';
    _baseInfo(_id, baseinfo['LMS_SESSIONID']!, baseinfo['WMONID']!);

    subject = Subject(_baseInfo);
    attend = Attend(_baseInfo, subject);
  }
}
