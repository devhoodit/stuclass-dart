import 'package:http/http.dart' as http;
import 'package:stuclass/src/base.dart';
import 'cookie_manage.dart';

class AuthURI {
  static Uri move(String kj) {
    return Uri.parse(
        'https://eclass.seoultech.ac.kr/ilos/st/course/eclass_room_submain.acl?KJKEY=$kj');
  }
}

class Auth {
  late BaseInfo _baseInfo;
  Auth(this._baseInfo);

  Future<void> move(String kj) async {
    final ckString = BaseCookieManage.setCookie(_baseInfo);
    final res =
        await http.post(AuthURI.move(kj), headers: {'Cookie': ckString});
  }
}
