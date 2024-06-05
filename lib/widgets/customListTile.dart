import 'package:flutter/material.dart';
import 'package:followup/screens/EditTask.dart';
import 'package:followup/screens/ListAll.dart';
import 'package:followup/screens/Remark.dart';
import 'package:followup/screens/ViewTask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:followup/constant/conurl.dart';
import 'package:sizer/sizer.dart';
// import 'package:followup/EditTask.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

String? admintype;
String? mainid;
final GlobalKey<NavigatorState> _dialogNavigatorKey =
    GlobalKey<NavigatorState>();

void deletedata(String id) async {
  print(id);
  //var urlString = 'http://testfollowup.absoftwaresolution.in/getlist.php?Type=deletetask';
  var urlString = AppString.constanturl + 'deletetask';
  Uri uri = Uri.parse(urlString);
  var response = await http.post(uri, body: {"id": id});
  var jsondata = jsonDecode(response.body);
  print(jsondata);
  if (jsondata['success'] == "success") {
    Fluttertoast.showToast(
      backgroundColor: Color(0xff7c81dd),
      textColor: Colors.white,
      msg: jsondata['message'],
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}

void completetask(String id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  admintype = preferences.getString('admintype');
  mainid = preferences.getString('id');
  print(admintype);
  print('mainid');
  //var urlString = 'http://testfollowup.absoftwaresolution.in/getlist.php?Type=completetask';
  var urlString = AppString.constanturl + 'completetask';
  Uri uri = Uri.parse(urlString);
  var response = await http
      .post(uri, body: {"id": id, "mainid": mainid, "admintype": admintype});
  var jsondata = jsonDecode(response.body);
  print(jsondata);
  if (jsondata['success'] == "success") {
    Fluttertoast.showToast(
      backgroundColor: Color(0xff7c81dd),
      textColor: Colors.white,
      msg: jsondata['message'],
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}

void launchWhatsApp(String phoneNumber, String message) async {
  String whatsappUrl =
      "whatsapp://send?phone=$phoneNumber" "&text=${Uri.encodeFull(message)}";
  try {
    await launch(whatsappUrl);
  } catch (e) {
    //handle error properly
  }
}

class CustomListAll extends StatelessWidget {
  final String? id;
  final String? title;
  final String? date;
  final String? deadline;
  final String? starttime;
  final String? endtime;
  final String? assign;
  final String? mobile;
  final String? assignedby;
  final String? assignid;
  final String? admintype;
  final String? mainid;
  final String? status;
  final Function? trailingButtonOnTap;
  final double opacity;

  const CustomListAll({
    Key? key,
    required this.id,
    required this.title,
    required this.date,
    required this.deadline,
    required this.starttime,
    required this.endtime,
    required this.assign,
    required this.mobile,
    required this.assignedby,
    required this.assignid,
    required this.admintype,
    required this.mainid,
    required this.status,
    required this.trailingButtonOnTap,
    required this.opacity,
  }) : super(key: key);

  Future<bool> onwillpop(BuildContext context) async {
    print("hiii");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //String? id = "";
    ScrollController controller = ScrollController();
    return WillPopScope(
        onWillPop: () => onwillpop(context),
        child: Builder(builder: (BuildContext context) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Viewtask(id: '$id')),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.0.sp,),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.sp),
                color: Colors.white,
                border: Border.all(color: Colors.black.withOpacity(0.3))
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 5,
                //     blurRadius: 7,
                //     offset: Offset(0, 3),
                //   ),
                // ],
              ),
              child: Opacity(
                opacity: opacity,
                // child: Padding(
                //   padding: EdgeInsets.all(16.0),
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: status == 'complete'
                          ?Colors.green.withOpacity(0.9)
                          : status == 'pending'
                              ? Color.fromARGB(255, 77, 77, 174)
                              : status == 'Overdue'
                                  ?
                                  //Color(0xFF00CED1)
                                  // Color.fromARGB(
                                  //     255, // Alpha component (fully opaque)
                                  //     194, // Red component
                                  //     24, // Green component
                                  //     7, // Blue component
                                  //   )
                      Colors.red.withOpacity(0.9)
                                  // : Color.fromARGB(
                                  //     255, // Alpha component (fully opaque)
                                  //     194, // Red component
                                  //     24,  // Green component
                                  //     7,   // Blue component
                                  //   ),
                                  :   Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(9.0.sp), // Adjust the radii as needed
                        topRight: Radius.circular(9.0.sp),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.0.sp, 5.0.sp, 20.0.sp, 5.0.sp),
                      child: Container(
                        color: status == 'complete'
                            ? Colors.green.withOpacity(0.1)
                            : status == 'pending'
                                ?  Color.fromARGB(255, 77, 77, 174)
                                : status == 'Overdue'
                                    ?
                                    //Color(0xFF00CED1)
                         Colors.red.withOpacity(0.1)
                                    // : Color.fromARGB(
                                    //     255, // Alpha component (fully opaque)
                                    //     194, // Red component
                                    //     24,  // Green component
                                    //     7,   // Blue component
                                    //   ),
                                    :   Colors.red.withOpacity(0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            status == 'complete'
                                ? Text(
                                    'Complete',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11.5.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : status == 'pending'
                                    ? Text(
                                        'Pending',
                                          style: TextStyle(
                                          fontFamily: 'Poppins',
                                            fontSize: 11.5.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : status == 'Overdue'
                                        ? Text(
                                            'Overdue',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 11.5.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            'Pending',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 11.5.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                            Text(
                              '$assign',
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: 15.sp,right: 15.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '$title',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        admintype == 'employee'
                            ? Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  PopupMenuButton<String>(
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem<String>(
                                        value: 'view',
                                        child: Text('View',
                                            style: TextStyle(
                                                fontFamily: 'Poppins')),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'remark',
                                        child: Text('Remark',
                                            style: TextStyle(
                                                fontFamily: 'Poppins')),
                                      ),
                                      if (assignid == mainid &&
                                          status != 'complete')
                                        const PopupMenuItem<String>(
                                          value: 'edit',
                                          child: Text('Update',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins')),
                                        ),
                                      if (assignid == mainid)
                                        const PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Text('Delete',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins')),
                                        ),
                                      if (status == 'incomplete' ||
                                          status == 'Overdue')
                                        const PopupMenuItem<String>(
                                          value: 'mark',
                                          child: Text('Mark as Completee',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins')),
                                        ),
                                      if (status == 'incomplete')
                                        const PopupMenuItem<String>(
                                          value: 'share',
                                          child: Text('Share',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins')),
                                        ),
                                    ],
                                    onSelected: (String value) {
                                      if (value == 'view') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Viewtask(id: '$id')),
                                        );
                                      } else if (value == 'remark') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Remark(id: '$id')),
                                        );
                                      } else if (value == 'edit') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              // builder: (context) => Edit(id: '$id', task:'all', audiopath: '')),
                                              builder: (context) => Edit(
                                                  id: '$id',
                                                  task: 'all',
                                                  audiopath: '',
                                                  backto: 'alllist')),
                                        );
                                      } else if (value == 'mark') {
                                        completetask('$id');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ListScreen(
                                                admin_type:
                                                    admintype.toString()),
                                          ),
                                        );
                                        // MaterialPageRoute(
                                        //   builder: (context) => CompletedTask(
                                        //       admin_type: admintype.toString()),
                                        // );
                                      } else if (value == 'delete') {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: const Text(
                                                'Are You Sure to Delete?',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins'),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deletedata('$id');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListScreen(
                                                                admin_type:
                                                                    admintype
                                                                        .toString()),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'OK',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else if (value == 'share') {
                                        String phoneNumber = '91$mobile';
                                        String message = 'Title: $title\n' +
                                            'Start Time: $date $starttime\n' +
                                            'End Time: $deadline $endtime\n' +
                                            'Assigned by: $assignedby';
                                        launchWhatsApp(phoneNumber, message);
                                      }
                                    },
                                    icon: Icon(Icons.more_vert,
                                    size: 18.sp,),
                                  ),

                                  // Positioned(
                                  //   top: 0,
                                  //   child: Icon(Icons.more_vert),
                                  // ),
                                ],
                              )
                            : PopupMenuButton<String>(
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem<String>(
                                    value: 'view',
                                    child: Text('View',
                                        style:
                                            TextStyle(fontFamily: 'Poppins')),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'remark',
                                    child: Text('Remark',
                                        style:
                                            TextStyle(fontFamily: 'Poppins')),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Update',
                                        style:
                                            TextStyle(fontFamily: 'Poppins')),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete',
                                        style:
                                            TextStyle(fontFamily: 'Poppins')),
                                  ),
                                  status == 'incomplete' || status == 'Overdue'
                                      ? const PopupMenuItem<String>(
                                          value: 'mark',
                                          child: Text('Mark as Complete',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins')),
                                        )
                                      : const PopupMenuItem<String>(
                                          value: '',
                                          child: Text(''),
                                        ),
                                  status == 'incomplete'
                                      ? const PopupMenuItem<String>(
                                          value: 'share',
                                          child: Text('Share',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins')),
                                        )
                                      : const PopupMenuItem<String>(
                                          value: '',
                                          child: Text(''),
                                        )
                                ],
                                onSelected: (String value) {
                                  if (value == 'view') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Viewtask(id: '$id')),
                                    );
                                  } else if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          //builder: (context) => Edit(id: '$id',  task:'all', audiopath: '')),
                                          builder: (context) => Edit(
                                              id: '$id',
                                              task: 'all',
                                              audiopath: '',
                                              backto: 'alllist')),
                                    );
                                  } else if (value == 'delete') {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text(
                                            'Are You Sure to Delete?',
                                            style: TextStyle(
                                                fontFamily: 'Poppins'),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deletedata('$id');
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ListScreen(
                                                            admin_type: admintype
                                                                .toString()),
                                                  ),
                                                );
                                              },
                                              child:Text(
                                                'OK',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (value == 'remark') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Remark(id: '$id')),
                                    );
                                  } else if (value == 'mark') {
                                    completetask('$id');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListScreen(
                                            admin_type: admintype.toString()),
                                      ),
                                    );
                                    // MaterialPageRoute(
                                    //   builder: (context) => CompletedTask(
                                    //       admin_type: admintype.toString()),
                                    // );
                                  } else if (value == 'share') {
                                    String phoneNumber = '91$mobile';
                                    String message =
                                        'Hello, I want to share this task with you: $title';
                                    launchWhatsApp(phoneNumber, message);
                                  }
                                },
                                icon: Icon(Icons.more_vert),
                              ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0.5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.sp,right: 15.sp,top: 5.sp),
                    child: Row(
                     //inAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 18.sp,
                          color: Colors.black,
                        ),
                      SizedBox(width: 3.w),
                        Text(
                          '$date',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.0.sp,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Icon(Icons.access_time,
                          size: 18.sp,),
                        SizedBox(width: 3.w),
                        Text(
                          '$deadline',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.0.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 15.sp,right: 15.sp,top: 7.sp,bottom: 7.sp),
                      child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                           SizedBox(width:9.w),
                          Text(
                            '$starttime',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.0.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width:25.5.w),
                          Text(
                            '$endtime',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.0.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ))
                ]),
              ),
            ),
          );
        }));
  }
}
