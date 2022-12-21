import 'auth.dart' show BaseInfo;

class CookieManage {
  static Map<String, String> getCookie(Map<String, String> headers) {
    Map<String, String> cookieMap = {};
    if (headers.containsKey('set-cookie')) {
      String cookieString = headers['set-cookie']!;
      for (String ck in cookieString.split(';')) {
        final tmp = ck.split('=');
        if (tmp.length <= 1) continue;
        String key = tmp[tmp.length - 2].replaceAll('/,', '');
        String value = tmp[tmp.length - 1].trim();
        cookieMap[key] = value;
      }
    }
    return cookieMap;
  }

  static String setCookie(Map<String, String> cookieMap) {
    List<String> cookieList = [];
    cookieMap.forEach((key, value) => cookieList.add('$key=$value'));
    return cookieList.join(';');
  }
}

class BaseCookieManage {
  // for consistency, param type is only Map, do not implement String type param
  // this method force override base cookie key-values
  static String setCookie(BaseInfo baseInfo, [Map<String, String>? cookieMap]) {
    cookieMap ??= {};
    cookieMap['_language_'] = 'ko';
    cookieMap['WMONID'] = baseInfo.wmonid;
    cookieMap['LMS_SESSIONID'] = baseInfo.session;
    return CookieManage.setCookie(cookieMap);
  }
}

class Cookie {}
