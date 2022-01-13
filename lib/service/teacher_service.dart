import 'package:instattendance/models/dept_class.dart';
import 'package:instattendance/models/division.dart';
import 'package:instattendance/models/student.dart' as stud;
import 'package:instattendance/models/subject.dart' as sub;
import 'package:instattendance/models/teacher.dart';
import 'package:instattendance/repository/teacher_repository.dart';
import 'package:instattendance/utils/storage_util.dart';
import 'package:instattendance/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherService {
  final TeacherRepository _teacherRepository = TeacherRepository();

  Future<Teacher?> authenticateTeacher(String email, String password) async {
    try {
      Teacher? teacher =
          await _teacherRepository.authenticateTeacher(email, password);
      if (teacher != null) {
        final StorageUtil storage = StorageUtil.storageInstance;
        if (storage.getPrefs('email')!.isEmpty &&
            storage.getPrefs('password')!.isEmpty) {
          storage.addStringtoSF('email', teacher.email!);
          storage.addStringtoSF('password', teacher.password!);
        }

        return teacher;
      }
    } catch (e) {
      DisplayMessage.showMsg('Faculty Not Found');
    }
  }

  Future<List<DeptClass>?> getAllClasses() async {
    List<DeptClass>? classes = await _teacherRepository.getAllClasses();

    if (classes == null) {
      DisplayMessage.showSomethingWentWrong();
    } else if (classes.isEmpty) {
      DisplayMessage.showNotFound();
    } else {
      return classes;
    }
  }

  Future<List<Division>?> getAllDivision() async {
    List<Division>? divisions = await _teacherRepository.getAllDivisions();

    if (divisions == null) {
      return DisplayMessage.showSomethingWentWrong();
    } else if (divisions.isEmpty) {
      return DisplayMessage.showNotFound();
    }

    return divisions;
  }

  Future<List<stud.Student>?> getStudentsByClassAndDiv(
      int className, int divName) async {
    List<stud.Student>? students =
        await _teacherRepository.getStudentsByClassAndDiv(className, divName);

    if (students == null) {
      return DisplayMessage.showSomethingWentWrong();
    }

    return students;
  }

  Future<List<sub.Subject>?> getSubjectsByClass(String className) async {
    List<sub.Subject>? subjects =
        await _teacherRepository.getAllSubjectsByClass(className);

    if (subjects == null) {
      return DisplayMessage.showSomethingWentWrong();
    } else if (subjects.isEmpty) {
      return DisplayMessage.showNotFound();
    }

    return subjects;
  }

  Future<DeptClass?> findClassByName(String name) async {
    DeptClass? deptClass = await _teacherRepository.findClassByName(name);
    if (deptClass != null) {
      return deptClass;
    }
  }

  Future<Division?> findDivisionByName(String name) async {
    Division? division = await _teacherRepository.findDivByName(name);
    if (division != null) {
      return division;
    }
  }
}
