import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instattendance/constants/api_service_constants.dart';
import 'package:instattendance/models/dept_class.dart';
import 'package:instattendance/models/division.dart';
import 'package:instattendance/models/student.dart' as stud;
import 'package:instattendance/models/student.dart';
import 'package:instattendance/models/subject.dart' as sub;
import 'package:instattendance/models/teacher.dart';

class TeacherRepository {
  Future<Teacher?> authenticateTeacher(String email, String password) async {
    var body = jsonEncode({"teacherEmail": email, "teacherPassword": password});
    var response = await http.post(
      Uri.parse("${RepositoryConstants.baseUrl}/teachers/authenticate"),
      body: body,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return teacherFromJson(response.body);
    }
    return null;
  }

  Future<List<DeptClass>?> getAllClasses() async {
    var response = await http.get(
      Uri.parse('${RepositoryConstants.baseUrl}/classes'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return deptClassFromJson(response.body);
    }

    return null;
  }

  Future<List<Division>?> getAllDivisions() async {
    var response = await http.get(
      Uri.parse('${RepositoryConstants.baseUrl}/divisions'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return divisionListFromJson(response.body);
    }

    return null;
  }

  Future<List<stud.Student>?> getStudentsByClassAndDiv(
      int className, int divName) async {
    var body = jsonEncode({"classId": className, "divId": divName});
    var response = await http.post(
      Uri.parse('${RepositoryConstants.baseUrl}/studentsByClassAndDiv'),
      body: body,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return studentFromJson(response.body);
    }
    return null;
  }

  Future<List<sub.Subject>?> getAllSubjectsByClass(String className) async {
    var response = await http.get(
        Uri.parse('${RepositoryConstants.baseUrl}/subjects/class/$className'));

    if (response.statusCode == RepositoryConstants.statusSuccessful) {
      return sub.subjectFromJson(response.body);
    }
    return null;
  }
}
