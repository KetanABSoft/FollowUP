import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:followup/screens/Taskincompleted.dart';
import 'package:followup/constant/string_constant.dart';
import 'package:followup/screens/create_lead_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'add_task.dart';
import 'total_task_screen.dart';
import 'Notifications_screen.dart';
import 'OverdueTask.dart';
import 'Profile.dart';
import 'TaskCompleted.dart';
import 'TaskReceive.dart';
import 'TaskSend.dart';
import 'package:flutter/services.dart';
import 'notification_services.dart';

String? id;
var mainid;
String? userid;
String? cmpid;
String? admintype;
String? listall;
String? completed;
String? receive;
String? send;
String? token;
int notificationCount = 0;
bool _isExitConfirmed = false;

Future fcmtoken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  admintype = preferences.getString('admintype');
  String? token = await FirebaseMessaging.instance.getToken();

  id = preferences.getString('id');
  var urlString = AppString.constanturl + 'update_fcm';

  Uri uri = Uri.parse(urlString);
  var response = await http.post(uri,
      body: {"fcm_token": '$token', "admintype": '$admintype', "id": '$id'});
}

Future<bool> onWillPopnew(BuildContext context) async {
  print("hiiii");
  if (_isExitConfirmed) {
    return true;
  } else {
    final confirmExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit App', style: TextStyle(fontFamily: 'Poppins')),
          content: Text('Do you want to exit the app?',
              style: TextStyle(fontFamily: 'Poppins')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No', style: TextStyle(fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: () {
                _isExitConfirmed = true;
                Navigator.of(context).pop(true);
              },
              child: Text('Yes', style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );

    if (confirmExit == true) {
      // User confirmed their intention to exit the app
      return true;
    } else {
      // User canceled the exit, so prevent it
      return false;
    }
  }
}

NotificationServices notificationServices = NotificationServices();

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
  Timer? timer;
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    fetchcount();
    print(notificationCount);
    fetchlist();
    fcmtoken();
  }

  dynamic jsonData;

  void fetchcount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id');
    cmpid = preferences.getString('cmpid');
    admintype = preferences.getString('admintype');
    String currentTime = preferences.getString('preferencetime') ?? "";

    var url = Uri.parse(AppString.constanturl + 'getnotificationscount');
    final response = await http.post(url, body: {
      "id": id,
      "cmpid": cmpid,
      "admintype": admintype,
      "date": currentTime,
    });

    var jsondata = jsonDecode(response.body);

    setState(() {
      notificationCount = int.parse(jsondata['count']);
    });
  }

  Future<void> fetchlist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString('id');
    cmpid = preferences.getString('cmpid');
    admintype = preferences.getString('admintype');
    //String apiUrl = 'http://testfollowup.absoftwaresolution.in/getlist.php?Type=gettaskcount';
    String apiUrl = AppString.constanturl + 'gettaskcount';
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {'id': userid, 'cmpid': cmpid, 'admintype': admintype},
    );
    if (response.statusCode == 200) {
      setState(() {
        jsonData = jsonDecode(response.body);
        String list = jsonData['alllist'];
        String incompleted = jsonData['incompleted'];
        String completed = jsonData['completed'];
        String receive = jsonData['receive'];
        String send = jsonData['send'];
        double overdue = double.parse(jsonData['overdue'].toString());

        try {
          double doubleValue1 = double.parse(list);
          double doubleValue2 = double.parse(completed);
          double doubleValue3 = double.parse(receive);
          double doubleValue4 = double.parse(send);
          double doubleValue5 = double.parse(incompleted);
          double doubleValue6 = overdue;

          taskData[0] = TaskData(
            taskName: 'Task',
            taskValue: doubleValue1.isFinite ? doubleValue1 : 0,
            taskColor: Colors.blue,
          );
          taskData[1] = TaskData(
            taskName: 'Pending',
            taskValue: doubleValue5.isFinite ? doubleValue5 : 0,
            taskColor: Color.fromARGB(255, 77, 77, 174),
          );
          taskData[2] = TaskData(
            taskName: 'Overdue',
            taskValue: doubleValue6.isFinite ? doubleValue6 : 0,
            taskColor: Colors.red.withOpacity(0.9),
          );
          taskData[3] = TaskData(
            taskName: 'Completed',
            taskValue: doubleValue2.isFinite ? doubleValue2 : 0,
            taskColor: Colors.green.withOpacity(0.9),
          );
          taskData[4] = TaskData(
            taskName: 'Send',
            taskValue: doubleValue4.isFinite ? doubleValue4 : 0,
            taskColor: Color.fromARGB(255, 230, 200, 32),
          );
          taskData[5] = TaskData(
            taskName: 'Receive',
            taskValue: doubleValue3.isFinite ? doubleValue3 : 0,
            taskColor: Colors.orange,
          );
        } catch (e) {
          print('Error parsing data: $e');
          // Assign default values or handle the error as per your app's requirements
        }
      });
    } else {
      print('Error fetching data. Status code: ${response.statusCode}');
    }
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  int _currentIndex = 0;
  @override
  bool get wantKeepAlive => true;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 1) {
        // Profile tab is pressed
        _handleAddTask(context);
      } else if (_currentIndex == 2) {
        _handleAddLead(context);
      } else if (_currentIndex == 3) {
        _handleNotifications(context);
      } else if (_currentIndex == 4) {
        _handleProfile(context);
      } else {
        _handleDashboard(context);
      }
    });
  }

  final List<TaskData> taskData = [
    TaskData(
      taskName: 'Task',
      taskValue: 0, // Use a placeholder or default value
      taskColor: Colors.blue,
    ),
    TaskData(
      taskName: 'Pending',
      taskValue: 0, // Use a placeholder or default value
      taskColor: Color.fromARGB(255, 77, 77, 174),
    ),
    TaskData(
      taskName: 'Overdue',
      taskValue: 0, // Use a placeholder or default value
      taskColor: Colors.red.withOpacity(0.9),
    ),
    TaskData(
      taskName: 'Completed',
      taskValue: 0, // Use a placeholder or default value
      taskColor: Colors.green.withOpacity(0.9),
    ),
    TaskData(
      taskName: 'Send',
      taskValue: 0, // Use a placeholder or default value
      taskColor: Color.fromARGB(255, 230, 200, 32),
    ),
    TaskData(
      taskName: 'Receive',
      taskValue: 0, // Use a placeholder or default value
      taskColor: Colors.orange,
    ),
  ];

  final List<String> items = [
    'Total Task',
    'Task Pending',
    'Task Overdue',
    'Task Completed',
    'Task Send',
    'Task Receive'
  ];
  final List<String> icons = [
    'assets/totaltask.png',
    'assets/Pendingtask.png',
    'assets/Overduetask.png',
    'assets/Completedtask.png',
    'assets/Taskreceived.png',
    'assets/Tasksend.png',
  ];
  final List<Color> colors = [
    Colors.blue,
    Color.fromARGB(255, 77, 77, 174),
    Colors.red.withOpacity(0.9),
    Colors.green.withOpacity(0.9),
    Color.fromARGB(255, 230, 200, 32),
    Colors.orange,
  ];
  void _handleDashboard(BuildContext context) {
    Get.to(DashboardScreen());
  }

  void _handleProfile(BuildContext context) {
    Get.to(profilemanagement());
  }

  void _handleAddTask(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('titleaudio');
    preferences.remove('startdateaudio');
    preferences.remove('deadlinedateaudio');
    preferences.remove('starttimeaudio');
    preferences.remove('endtimeaudio');
    preferences.remove('picaudio');
    preferences.remove('selectedValues');
    Get.to(AddTask(audioPath: AppString.audiourl));
  }

  void _handleAddLead(BuildContext context) {
    Get.to(CreateLead(id: "0", task: ''));
  }

  void _handleCard1Tap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TotalTask(admin_type: admintype.toString()),
      ),
    );
  }

  void _handleNotifications(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NotificationScreen(admin_type: admintype.toString()),
      ),
    );
  }

  void _handleCardincompltedTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Taskincompletednew(admin_type: admintype.toString()),
      ),
    );
  }

  void handleoverduetask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OverdueTasknew(admin_type: admintype.toString()),
      ),
    );
  }

  void _handleCard2Tap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompletedTask(admin_type: admintype.toString()),
      ),
    );
  }

  void _handleCard3Tap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiveTask(admin_type: admintype.toString()),
      ),
    );
  }

  void _handleCard4Tap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendTask(admin_type: admintype.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPopnew(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:
              Color(0xff7c81dd), // Set app bar background color to transparent
          elevation: 0, // Remove app bar shadow
          title: Text(
            'Task Management',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white, // Set app bar text color to white
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 1.8.h, left: 12.sp, right: 12.sp),
          child: Column(
            children: [
              Container(
                height: 32.h, // Set the desired height for the chart
                child: TaskManagementChart(data: taskData),
              ),
              //SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(items.length, (index) {
                      return Card(
                        child: ListTile(
                          leading: Container(
                            width: 8.w, // Adjust the width as needed
                            height: 5.h, // Adjust the height as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0
                                  .sp), // Adjust the border radius as needed
                            ),
                            child: Image.asset(
                              icons[index], // Use the icon path from the list
                              width: 20.sp, // Adjust the icon width as needed
                              height: 20.sp, // Adjust the icon height as needed
                            ),
                          ),
                          title: Text(
                            '${items[index]}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.sp, // Font size
                              fontWeight: FontWeight.bold, // Font weight
                              color: Colors.black, // Text color
                            ),
                          ),
                          trailing: Text(
                            '${taskData[index].taskValue.toInt()}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.sp, // Font size
                              color: Colors.black, // Text color
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            switch (index) {
                              case 0:
                                _handleCard1Tap(context);
                                break;
                              case 1:
                                _handleCardincompltedTap();
                                break;
                              case 2:
                                handleoverduetask();
                              case 3:
                                _handleCard2Tap();
                                break;
                              case 4:
                                _handleCard4Tap();
                                break;
                              case 5:
                                _handleCard3Tap();
                                break;
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFD700),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30.sp),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5.sp,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Color(0xFFFFD700),
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            selectedItemColor: AppString.appgraycolor,
            unselectedItemColor: AppString.appgraycolor,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add Task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'New lead',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(Icons.notifications),
                    Positioned(
                      right: 0,
                      top: -4,
                      child: Container(
                        padding: EdgeInsets.all(3.sp),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          notificationCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskData {
  final String taskName;
  final double taskValue;
  final Color taskColor;

  TaskData({
    required this.taskName,
    required this.taskValue,
    required this.taskColor,
  });
}

class TaskManagementChart extends StatelessWidget {
  final List<TaskData> data;

  TaskManagementChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TaskData, String>> series = [
      charts.Series<TaskData, String>(
        id: 'Tasks',
        data: data,
        domainFn: (TaskData task, _) => task.taskName,
        measureFn: (TaskData task, _) => task.taskValue,
        colorFn: (TaskData task, _) =>
            charts.ColorUtil.fromDartColor(task.taskColor),
        labelAccessorFn: (TaskData task, _) => '${task.taskValue.toInt()}',
      ),
    ];

    bool allValuesZero = data.every((task) => task.taskValue == 0);

    if (allValuesZero) {
      // If all values are zero, display a gray pie chart
      return Container(
        width: 50.w, // Adjust the width as needed
        height: 50.h, // Adjust the height as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Create a circular shape
          color: Colors.grey, // Set the background color to gray
        ),
        child: Center(
          child: Text(
            '0',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      try {
        return charts.PieChart(
          series,
          animate: true,
          defaultRenderer: charts.ArcRendererConfig<String>(
            arcWidth: 50,
            arcRendererDecorators: [charts.ArcLabelDecorator()],
          ),
        );
      } catch (e, stackTrace) {
        print('PieChart rendering error: $e\n$stackTrace');
        return Container();
      }
    }
  }
}
