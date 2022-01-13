import 'package:get/get.dart';
import 'package:instattendance/models/attendance.dart';
import 'package:instattendance/models/dept_class.dart';
import 'package:instattendance/models/division.dart';
import 'package:instattendance/models/student.dart';

import 'package:instattendance/models/subject.dart' as sub;
import 'package:instattendance/service/attendance_service.dart';
import 'package:instattendance/service/attendance_sheet.dart';
import 'package:instattendance/service/teacher_service.dart';
import 'package:instattendance/widgets/toast.dart';
import 'package:intl/intl.dart';

class AttendanceFilterController extends GetxController {
  final TeacherService _teacherService = TeacherService();
  final AttendanceService _attendanceService = AttendanceService();
  var subjectsByclass = List<sub.Subject>.empty(growable: true).obs;
  var filterAttendanceByClassDivSub =
      List<sub.Subject>.empty(growable: true).obs;
  var selectedClassName = ''.obs;
  var selectedDivision = ''.obs;
  var selectedSub = ''.obs;
  var classRadioButtonVal = 999.obs;
  var divRadioButtonVal = 999.obs;

  Future getSubjectsByClass(String className) async {
    var subList = await _teacherService.getSubjectsByClass(className);

    if (subList != null) {
      subjectsByclass.assignAll(subList);
    }
  }

  Future<List<Attendance>?> getAttendanceByClassSubDiv(
      String className, String div, String subject) async {
    var filteredAttendanceList = await _attendanceService
        .getAttendanceByClassSubDiv(className, div, subject);

    if (filteredAttendanceList != null) {
      return filteredAttendanceList;
    }
  }

  Future fillAttendanceSheet(List<Attendance> data) async {
    DeptClass? getClassByName =
        await _teacherService.findClassByName(selectedClassName.value);

    Division? getDivByName =
        await _teacherService.findDivisionByName(selectedDivision.value);

    if (getClassByName != null && getDivByName != null) {
      List<Student>? studentsByClassAndDiv = await _teacherService
          .getStudentsByClassAndDiv(getClassByName.id!, getDivByName.id!);

      try {
        if (studentsByClassAndDiv != null && studentsByClassAndDiv.isNotEmpty) {
          await AttendanceSheet.init(selectedClassName.value,
              selectedDivision.value, selectedSub.value);

          int columnNo = 4;
          int rowNo = 9;

          int addStudentForSingleTime = 0;
          for (var i = 0; i < data.length; i++) {
            AttendanceSheet.insertDatesInColumn(columnNo,
                DateFormat.yMEd('en_US').format(data[i].attendanceDate!));
            List<String> absentStudentList = data[i].absentStudents!.split(",");
            int tempRow = 9;
            for (var j = 0; j < studentsByClassAndDiv.length; j++) {
              bool isStudentAbsent =
                  absentStudentList.contains(studentsByClassAndDiv[j].rollNo);
              if (isStudentAbsent) {
                List row = [
                  '${j + 1}',
                  studentsByClassAndDiv[j].rollNo,
                  studentsByClassAndDiv[j].name,
                ];
                if (addStudentForSingleTime <= 0) {
                  AttendanceSheet.insertRows(row, rowNo);
                }
                AttendanceSheet.insertpresenti('A', columnNo, tempRow);
              } else {
                List row = [
                  '${j + 1}',
                  studentsByClassAndDiv[j].rollNo,
                  studentsByClassAndDiv[j].name,
                ];
                if (addStudentForSingleTime <= 0) {
                  AttendanceSheet.insertRows(row, rowNo);
                }
              }

              rowNo += 1;
              tempRow += 1;
            }
            columnNo += 1;
            addStudentForSingleTime += 1;
          }
        }

        DisplayMessage.showMsg('Report Generated Successfully');
      } catch (e) {
        DisplayMessage.showMsg('something went wrong .. try again');
      }
    }
  }
}










 /* int columnNo = 3;
        int rowNo = 6;
        int addStudentForSingleTime = 0;
        for (var i = 0; i < data.length; i++) {
          AttendanceSheet.insertDatesInColumn(columnNo,
              DateFormat.yMEd('en_US').format(data[i].attendanceDate!));
          List<String> absentStudentList = data[i].absentStudents!.split(",");

          for (var j = 0; j < studentsByClassAndDiv.length; j++) {
            bool isStudentAbsent =
                absentStudentList.contains(studentsByClassAndDiv[j].rollNo);
            if (isStudentAbsent) {
              List row = [
                studentsByClassAndDiv[j].rollNo,
                studentsByClassAndDiv[j].name,
              ];
              if (addStudentForSingleTime <= 0) {
                AttendanceSheet.insertRows(row, rowNo);
              }
              AttendanceSheet.insertpresenti('A', columnNo, rowNo);
            } else {
              List row = [
                studentsByClassAndDiv[j].rollNo,
                studentsByClassAndDiv[j].name,
              ];
              if (addStudentForSingleTime <= 0) {
                AttendanceSheet.insertRows(row, rowNo);
              }
            }

            rowNo += 1;
          }
          columnNo += 1;
          addStudentForSingleTime += 1;
        }*/