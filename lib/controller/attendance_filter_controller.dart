import 'dart:collection';
import 'package:flutter/cupertino.dart';
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
  var isLoading = false.obs;

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

  Future fillAttendanceSheet(
      List<Attendance> data, BuildContext context) async {
    isLoading(true);
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
              selectedDivision.value, selectedSub.value, data.length + 4);

          int columnNo = 4;
          int rowNo = 9;
          int totalPresentiColNo = 4 + data.length;
          int addStudentForSingleTime = 0;
          LinkedHashMap map = LinkedHashMap<String, int>();
          for (var i = 0; i < data.length; i++) {
            await AttendanceSheet.insertDatesInColumn(columnNo,
                DateFormat.yMEd('en_US').format(data[i].attendanceDate!));
            await Future.delayed(Duration(seconds: 1));
            List<String> absentStudentList = data[i].absentStudents!.split(",");

            int tempRow = 9;
            for (var j = 0; j < studentsByClassAndDiv.length; j++) {
              bool isStudentAbsent =
                  absentStudentList.contains(studentsByClassAndDiv[j].rollNo);
              map.putIfAbsent(studentsByClassAndDiv[j].rollNo, () => 0);
              List row = [
                '${j + 1}',
                studentsByClassAndDiv[j].rollNo,
                studentsByClassAndDiv[j].name,
              ];
              if (addStudentForSingleTime <= 0) {
                await AttendanceSheet.insertRows(row, rowNo);
              }
              if (isStudentAbsent) {
                await AttendanceSheet.insertpresenti('A', columnNo, tempRow);
              } else {
                if (map.containsKey(studentsByClassAndDiv[j].rollNo)) {
                  int val = map[studentsByClassAndDiv[j].rollNo];
                  map.update(
                      studentsByClassAndDiv[j].rollNo, (value) => val + 1);
                }
              }

              await AttendanceSheet.insertTotalAvgpresenti(
                  map[studentsByClassAndDiv[j].rollNo],
                  totalPresentiColNo,
                  tempRow);

              int attendancePercentage =
                  ((map[studentsByClassAndDiv[j].rollNo] * 100) / data.length)
                      .round();

              await AttendanceSheet.insertTotalAvgpresenti(
                  attendancePercentage, totalPresentiColNo + 1, tempRow);

              await Future.delayed(Duration(seconds: 1));

              rowNo += 1;
              tempRow += 1;
            }
            columnNo += 1;
            addStudentForSingleTime += 1;
            await Future.delayed(Duration(seconds: 1));
          }
        }
        isLoading(false);

        DisplayMessage.displaySuccessMotionToast(
            context, 'Success', 'Report Generated Successfully');
      } catch (e) {
        isLoading(false);
        DisplayMessage.displayErrorMotionToast(context, 'Error', e.toString());
        print(e.toString());
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