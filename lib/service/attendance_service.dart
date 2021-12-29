import 'package:instattendance/models/attendance.dart';
import 'package:instattendance/repository/attendance_repository.dart';
import 'package:instattendance/widgets/toast.dart';

class AttendanceService {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();

  Future<Attendance?> takeAttendance(Attendance attendanceDetails) async {
    Attendance? attendance =
        await _attendanceRepository.takeAttendance(attendanceDetails);

    if (attendance == null) {
      return DisplayMessage.showSomethingWentWrong();
    }
    return attendance;
  }

  Future<List<Attendance>?> getAttendanceByTeacher(String teacherName) async {
    List<Attendance>? allAttendanceOfTeacher =
        await _attendanceRepository.getAttendanceByTeacherName(teacherName);

    /*if (allAttendanceOfTeacher == null) {
      DisplayMessage.showSomethingWentWrong();
    } else if (allAttendanceOfTeacher.isEmpty) {
      DisplayMessage.showNotFound();
    }*/

    return allAttendanceOfTeacher;
  }

  Future<String> deleteAttendance(int id) async {
    return await _attendanceRepository.deleteAttendance(id);
  }
}
