import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:stuclass/src/auth.dart';
import 'package:stuclass/src/cookie_manage.dart';

class LectureMaterialURI {
  static list(String kj, String id) {
    return Uri.parse(
        'https://eclass.seoultech.ac.kr/ilos/st/course/lecture_material_list.acl?start=&display=1&SCH_VALUE=&ud=$id&ky=$kj&encoding=utf-8');
  }

  static box(String kj, String id, String contentSeq) {
    return Uri.parse(
        'https://eclass.seoultech.ac.kr/ilos/co/efile_list.acl?ud=$id&ky=$kj&CONTENT_SEQ=$contentSeq&encoding=utf-8');
  }
}

class LectureMaterial {
  late Auth _auth;
  LectureMaterial(this._auth);
  // list[{title, prof, views, downloadlinks}]
  Future<List<Map<String, dynamic>>> get(String kj) async {
    await _auth.move(kj);
    final ckString = BaseCookieManage.setCookie(_auth.baseInfo);
    final res = await http.post(LectureMaterialURI.list(kj, _auth.baseInfo.id),
        headers: {'Cookie': ckString});
    final document = parser.parse(res.body);
    List<Map<String, dynamic>> output = [];
    for (final content in document.getElementsByTagName('tr').sublist(1)) {
      final idxfall = content.getElementsByTagName('td');
      if (idxfall.length < 4) continue;

      final td = idxfall[2];
      final title = td.getElementsByClassName('subjt_top')[0].text;
      final prof = td
          .getElementsByClassName('subjt_bottom')[0]
          .getElementsByTagName('span')[0]
          .text;
      final views = td
          .getElementsByClassName('subjt_bottom')[0]
          .getElementsByTagName('span')[1]
          .text;
      List<DownloadInfo> downloadInfos = [];
      final downloadBox = idxfall[3].getElementsByTagName('div');
      if (downloadBox.length >= 2) {
        final contentSeq =
            downloadBox[1].id.split("_")[2]; // this is contentseq
        final res = await http.get(
            LectureMaterialURI.box(kj, _auth.baseInfo.id, contentSeq),
            headers: {'Cookie': ckString});
        final document = parser.parse(res.body);
        final downloadBoxElements =
            document.getElementsByClassName('attfile-list');
        if (downloadBoxElements.isNotEmpty) {
          for (final index
              in downloadBoxElements[0].getElementsByClassName('site-link')) {
            final downloadLink = index.attributes['href']!; // download link
            final tmpBox = index.text.trim().split(' ');
            final filename = tmpBox[0]; // this is filename
            final filesize = tmpBox[1];
            final downloadInfo = DownloadInfo(filename, filesize, downloadLink);
            downloadInfos.add(downloadInfo);
          }
        }
      }
      output.add({
        'title': title,
        'professor': prof,
        'views': views,
        'elements': downloadInfos
      });
    }
    return output;
  }
}

class DownloadInfo {
  late String filename;
  late String filesize;
  late String link;
  DownloadInfo(this.filename, this.filesize, this.link);
}
