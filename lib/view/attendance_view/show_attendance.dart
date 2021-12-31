import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instattendance/controller/attendance_controller.dart';
import 'package:instattendance/controller/teacher_controller.dart';
import 'package:instattendance/models/attendance.dart';
import 'package:instattendance/widgets/toast.dart';
import 'package:intl/intl.dart';

class ShowAttendance extends StatelessWidget {
  ShowAttendance({Key? key}) : super(key: key);
  final AttendanceController _attendanceController = Get.find();
  final TeacherController _teacherController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Attendance Record'),
            backgroundColor: Colors.indigoAccent),
        body: Container(
          child: FutureBuilder(
            future: _attendanceController
                .getAttendanceByTeacher(_teacherController.teacher.value.name),
            builder: (context, AsyncSnapshot<List<Attendance>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.indigo,
                  ),
                );
              } else if (snapshot.hasError) {
                return DisplayMessage.showSomethingWentWrong();
              } else {
                return snapshot.data!.isEmpty
                    ? const Center(child: Text('No Attendance records found'))
                    : ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            collapsedIconColor: Colors.indigo,
                            backgroundColor: Colors.indigo[50],
                            title: Row(
                              children: [
                                Text(DateFormat.yMEd('en_US').format(
                                    snapshot.data![index].attendanceDate!)),
                                const SizedBox(width: 7),
                                Text(
                                    '${_attendanceController.attendanceByTeacher[index].attendanceTime}'),
                              ],
                            ),
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Class: ${snapshot.data![index].className} , ${snapshot.data![index].divisionName}'),
                                  const SizedBox(width: 8),
                                  Text(
                                      'Subject: ${snapshot.data![index].subject}'),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Column(
                                children: [
                                  const Text('Absent Student :'),
                                  Text(
                                      '${snapshot.data![index].absentStudents}'),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text('Generate Report',
                                      style: TextStyle(color: Colors.indigo))),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                      onPressed: () async {
                                        String res = await _attendanceController
                                            .deleteattendance(
                                                snapshot.data![index].id!);

                                        DisplayMessage.showMsg(res);
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.black45, size: 18)))
                            ],
                          );
                        });
              }
            },
          ),
        ));
  }
}
