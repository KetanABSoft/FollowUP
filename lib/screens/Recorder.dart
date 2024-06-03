import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:followup/screens/AddTask.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:followup/constant/conurl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'dashboard.dart';

String? title;
String? startdate;
String? deadlinedate;
String? starttime;
String? endtime;
String? image;
var uuid = Uuid();
var uniqueId = uuid.v1();

class MyApp extends StatefulWidget {
  final String? title;
  final String? startdate;
  final String? deadlinedate;
  final String? starttime;
  final String? endtime;
  final String? image;

  MyApp({
    this.title,
    this.startdate,
    this.deadlinedate,
    this.starttime,
    this.endtime,
    this.image,
  });
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timer;
  int? randomNumber;
  int _secondsElapsed = 0;
  String statusText = "";
  bool isComplete = false;

  bool _playAudio = false;
  bool _isTimerRunning = false;
  ElevatedButton createElevatedButton({
    required IconData icon,
    required Color iconColor,
    required void Function() onPressFunc,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(6.0), backgroundColor: Colors.white,
        side: BorderSide(
          color: Colors.red,
          width: 4.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 9.0,
      ),
      onPressed: onPressFunc,
      icon: Icon(
        icon,
        color: iconColor,
        size: 38.0,
      ),
      label: Text(''),
    );
  }

  void _startTimer() {
    if (!_isTimerRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          _secondsElapsed++;
        });
      });
      _isTimerRunning = true;
    }
  }

  void _stopTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
      _isTimerRunning = false;
    }
  }

  String _getFormattedTime() {
    int minutes = _secondsElapsed ~/ 60;
    int seconds = _secondsElapsed % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  

  @override
  void initState() {
    super.initState();
    title = widget.title;
    startdate = widget.startdate;
    deadlinedate = widget.deadlinedate;
    starttime = widget.starttime;
    endtime = widget.endtime;
    image = widget.image;
    getdata();
  }

  void getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('titleaudio', title.toString());
    preferences.setString('startdateaudio', startdate.toString());
    preferences.setString('deadlinedateaudio', deadlinedate.toString());
    preferences.setString('starttimeaudio', starttime.toString());
    preferences.setString('endtimeaudio', endtime.toString());
    preferences.setString('imageaudio', image.toString());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      // appBar: AppBar(title: Text('Audio Recording and Playing')),
      appBar: AppBar(
        backgroundColor: Color(0xff8155BA),
        elevation: 0,
        title:  Text(
          'Record Audio',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DashboardScreen(),
            //   ),
            // );
            //Get.to(DashboardScreen());
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.h,
            ),
            Container(
              child: Center(
                child: Text(
                  _getFormattedTime(),
                  style: TextStyle(fontSize: 50.sp, color: Colors.red),
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // createElevatedButton(
                //   icon: Icons.mic,
                //   iconColor: Colors.red,
                //   onPressFunc: () async {
                //     startRecord();
                //   },
                // ),
                
                GestureDetector(
                  onTap: (){
                    startRecord();
                  },
                  child: Container(
                    height: 6.h,
                    width: 24.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.deepPurple,width: 2),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Icon(Icons.mic,size: 25.sp,color: Colors.red,),
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                // createElevatedButton(
                //     icon: Icons.stop,
                //     iconColor: Colors.red,
                //     onPressFunc: () {
                //       stopRecord();
                //     }),

                GestureDetector(
                  onTap: (){
                    stopRecord();
                  },
                  child: Container(
                    height: 6.h,
                    width: 24.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.deepPurple,width: 2),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Icon(Icons.stop,size: 25.sp,color: Colors.red,),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            // ElevatedButton(
            //   style:
            //       ElevatedButton.styleFrom(elevation: 11.0,    backgroundColor: Color(0xff8155BA),),
            //   child: Text('Upload', style: TextStyle(
            //       fontFamily: 'Poppins',color: Colors.white)),
            //   onPressed: () {
            //     stopRecord();
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => TaskForm(
            //           audioPath: recordFilePath,
            //         ),
            //       ),
            //     );
            //   },
            // ),


            GestureDetector(
              onTap: (){
                stopRecord();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskForm(
                      audioPath: recordFilePath,
                    ),
                  ),
                );
              },
              child: Container(
                height: 6.h,
                width: 30.w,
                decoration: BoxDecoration(
                    color: Color(0xff8155BA),
                    // border: Border.all(color: Colors.red,width: 2),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Center(child: Text("Upload",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18.sp),)),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    _startTimer();
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

  void pauseRecord() {
    _stopTimer();
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }

  void stopRecord() {
    _stopTimer();
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";
      isComplete = true;
      setState(() {});
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      setState(() {});
    }
  }

  String recordFilePath = '';

  void play() {
    print('recordFilePath' + recordFilePath);
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      //audioPlayer.play(recordFilePath, isLocal: true);
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    var newid = uuid.v1();
    //print("chkname: $newid");
    return sdPath + "/${newid}.mp3";
  }
}
