import 'package:http/http.dart' as http;
import 'cookie_manage.dart';

class AuthURI {
  static Uri login(String id, String password) {
    return Uri.parse(
        'https://eclass.seoultech.ac.kr/ilos/lo/login.acl?&usr_id=$id&usr_pwd=$password');
  }

  static Uri move(String kj) {
    return Uri.parse(
        'https://eclass.seoultech.ac.kr/ilos/st/course/eclass_room_submain.acl?KJKEY=$kj');
  }
}

class Auth {
  late final String _id;
  late final String _password;
  late BaseInfo _baseInfo;

  Auth(String id, String password) {
    _id = id;
    _password = password;
  }

  BaseInfo get baseInfo => _baseInfo;
  set baseInfo(BaseInfo bi) =>
      {}; // can't set baseinfo, baseinfo only manage in auth class

  Future<void> login() async {
    final endpoint = AuthURI.login(_id, _password);
    final res = await http.Client().post(endpoint);
    final resCookie = CookieManage.getCookie(res.headers);
    final sessionId = resCookie['LMS_SESSIONID'];
    final wmonid = resCookie['WMONID'];
    if (sessionId == null || wmonid == null) {
      throw Exception('Error: id or password is not corrected');
    }
    _baseInfo =
        BaseInfo(_id, resCookie['LMS_SESSIONID']!, resCookie['WMONID']!);
  }

  Future<void> move(String kj) async {
    final ckString = BaseCookieManage.setCookie(_baseInfo);
    final res =
        await http.post(AuthURI.move(kj), headers: {'Cookie': ckString});
  }
}

class BaseInfo {
  String id = '';
  String session = '';
  String wmonid = '';
  BaseInfo(this.id, this.session, this.wmonid);

  call(String id, String session, String wmonid) {
    this.id = id;
    this.session = session;
    this.wmonid = wmonid;
  }
}
