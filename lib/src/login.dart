import 'package:http/http.dart' as http;
import 'cookie_manage.dart' as cookie;

class LoginURL {
  static Uri login(String id, String password) {
    return Uri.parse(
        'https://eclass.seoultech.ac.kr/ilos/lo/login.acl?&usr_id=${id}&usr_pwd=${password}');
  }
}

class Login {
  String? _id;
  String? _password;

  Login(String id, String password) {
    _id = id;
    _password = password;
  }

  Future<Map<String, String>> getLoginInfo() async {
    assert(_id != null);
    assert(_password != null);

    final endpoint = LoginURL.login(_id!, _password!);
    final res = await http.Client().post(endpoint);
    final resCookie = cookie.CookieManage.getCookie(res.headers);

    Map<String, String> ck = {};
    ck['LMS_SESSIONID'] = resCookie['LMS_SESSIONID'] ?? '';
    ck['WMONID'] = resCookie['WMONID'] ?? '';
    return ck;
  }

  Future<String> getSession() async {
    final ck = getLoginInfo();
    return (await ck)['LMS_SESSIONID']!;
  }
}
