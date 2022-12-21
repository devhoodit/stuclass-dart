import 'base.dart';
import 'subject.dart';
import 'cookie_manage.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'auth.dart';

class AttendURI {
  static Uri attend(String id, String kj) {
    return Uri.parse(
        'https://eclass.seoultech.ac.kr/ilos/st/course/attendance_list.acl?ud=$id&ky=$kj&encoding=utf-8');
  }

  static Uri subroom() {
    return Uri.parse(
        'https://eclass.seoultech.ac.kr/ilos/st/course/eclass_room_submain.acl');
  }
}

class Attend {
  late BaseInfo _baseInfo;
  late Auth _auth;
  late Subject _subject;
  Attend(this._baseInfo, this._auth, this._subject);

  Future<Map<String, List<AttendContainer>>> getAll() async {
    return {};
  }

  Future<List<AttendContainer>> get(String kj) async {
    final ckString = BaseCookieManage.setCookie(_baseInfo);
    await subroom(kj);
    final res = await http.post(AttendURI.attend(_baseInfo.id, kj),
        headers: {'Cookie': ckString});
    final document = parser.parse(res.body);

    final attendBox = document.body?.children;
    if (attendBox == null || attendBox.length < 2) return [];
    List<AttendContainer> attendList = [];
    for (final outsideBox
        in document.body!.children.elementAt(1).children.toList()) {
      try {
        final weekBox = outsideBox.getElementsByTagName('div')[0];
        final attendListBox = outsideBox.getElementsByTagName('div')[1];
        final weekName = weekBox.text;
        List<UnitContainer> unitList = [];
        // box1 => green, box2 => red, box3 => orange, box6 => grey
        for (final attBox in attendListBox.querySelectorAll(
            '.attend_box_1,.attend_box_2,.attend_box_3,.attend_box_6')) {
          final tmp = attBox.text.trim().split('\n');
          unitList.add(UnitContainer(tmp[0].trim(), tmp[1].trim(),
              int.parse(attBox.className.split("_")[2])));
        }
        attendList.add(AttendContainer(weekName, unitList));
      } catch (e) {
        //
      }
    }
    return attendList;
  }

  Future<void> subroom(String kj) async {
    final payload = {"KJKEY": kj};
    final ckString = BaseCookieManage.setCookie(_baseInfo);
    await http.post(AttendURI.subroom(),
        headers: {'Cookie': ckString}, body: payload);
  }
}

class AttendContainer {
  late String week;
  late List<UnitContainer> weekAttend;
  AttendContainer(this.week, this.weekAttend);
}

class UnitContainer {
  late String name;
  late String date;
  late int type;
  UnitContainer(this.name, this.date, this.type);
}
