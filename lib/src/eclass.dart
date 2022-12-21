import 'package:stuclass/src/lecture_material.dart';
import 'subject.dart';
import 'attend.dart';
import 'auth.dart';

class Eclass {
  late Auth auth;
  late Subject subject;
  late Attend attend;
  late LectureMaterial lectureMaterial;

  Eclass(String id, String password) {
    auth = Auth(id, password);
  }

  Future<void> initalize() async {
    await auth.login();

    subject = Subject(auth);
    attend = Attend(auth, subject);
    lectureMaterial = LectureMaterial(auth);
  }
}
