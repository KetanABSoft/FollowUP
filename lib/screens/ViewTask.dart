import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:followup/constant/conurl.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'ListAll.dart';
import 'package:audioplayers/audioplayers.dart';

import 'dashboard.dart';

class Viewtask extends StatefulWidget {
  final String id;
  Viewtask({required this.id});

  @override
  State<Viewtask> createState() => _ViewtaskState();
}

//class _ViewtaskState extends State<Viewtask> {
class _ViewtaskState extends State<Viewtask> with WidgetsBindingObserver {
  TextEditingController startdatenew = TextEditingController();
  TextEditingController starttimenew = TextEditingController();
  TextEditingController endtimenew = TextEditingController();
  TextEditingController endtdatenew = TextEditingController();
  TextEditingController titlenew = TextEditingController();
  TextEditingController selectassignenew = TextEditingController();

  final AudioPlayer audioPlayer = AudioPlayer();
  ScrollController controller = ScrollController();
  String? title;
  String? startdate;
  String? enddate;
  String? starttime;
  String? endtime;
  String? assign;
  String? imageUrl;
  String? audiourl;
  String? image;
  String? audio;
  String? admintype;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    fetchTaskData();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      
      audioPlayer.stop();
    }
  }

  void fetchTaskData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    admintype = preferences.getString('admintype');
    var urlString = AppString.constanturl + 'gettask';
    Uri uri = Uri.parse(urlString);
    var response = await http.post(uri, body: {
      "taskid": widget.id,
    });

    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      setState(() {
        title = jsondata['title'];
        startdate = jsondata['startdate'];
        enddate = jsondata['enddate'];
        starttime = jsondata['starttime'];
        endtime = jsondata['endtime'];
        assign = jsondata['assign'];
        image = jsondata['image'];
        audio = jsondata['audio'];

        if (image != '') {
          imageUrl = AppString.imageurl + '$image';
        }
        startdatenew.text = startdate.toString();
        starttimenew.text = starttime.toString();
        endtimenew.text = endtime.toString();
        endtdatenew.text = enddate.toString();
        titlenew.text = title.toString();
        selectassignenew.text = assign.toString();
        if (audio != '') {
          audiourl = AppString.audiourl + '$audio';
        }
      });
    }
  }

  void playAudio(String audioUrl) async {
    print('audiourl' '$audiourl');
    final String audio = audioUrl;
    audioPlayer.play(UrlSource(audio));
  }

  void pauseAudio() {
    audioPlayer.pause();
    print('Audio paused');
  }

  void backbutton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListScreen(
          admin_type: admintype.toString(),
        ),
      ),
    );
  }

  Future<bool> onwillpop(BuildContext context) async {
    print("hiii");
    audioPlayer.pause();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xff8155BA),
        backgroundColor: Color(0xff7c81dd),
        elevation: 0,
        title: Text(
          'View Task',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed logic for the floating button here
          // This code will be executed when the button is pressed
          audioPlayer.pause();
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back,
            color:Colors.white), // Change the icon as needed
        backgroundColor: Color(0xff7c81dd), // Change the color as needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Adjust the position as needed
      body: WillPopScope(
        onWillPop: () => onwillpop(context),
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(left: 8.sp,right: 8.sp,top: 12.sp),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              elevation: 5,
              child: Padding(
                padding:  EdgeInsets.all(10.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 5.5.h,
                      width: 45.w,
                      child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        controller: titlenew,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black, // Change the label color here
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight:  Radius.circular(7),
                                bottomLeft:  Radius.circular(7),
                                bottomRight:  Radius.circular(7),
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight:  Radius.circular(7),
                                bottomLeft:  Radius.circular(7),
                                bottomRight:  Radius.circular(7),
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight:  Radius.circular(7),
                                bottomLeft:  Radius.circular(7),
                                bottomRight:  Radius.circular(7),
                              )
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 5.5.h,
                            width: 45.w,
                            child: TextFormField(
                              readOnly: true,
                              enabled: false,
                              controller: startdatenew,
                              decoration: InputDecoration(
                                icon: const Icon(Icons.date_range),
                                labelText: 'Start Date',
                                labelStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black, // Change the label color here
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12.0.sp),
                        Flexible(
                          child: Container(
                            height: 5.5.h,
                            width: 45.w,
                            child: TextFormField(
                              readOnly: true,
                              enabled: false,
                              controller: endtdatenew,
                              decoration: InputDecoration(
                                icon: const Icon(Icons.date_range),
                                labelText: 'End date',
                                labelStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color:
                                  Colors.black, // Change the label color here
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 5.5.h,
                            width: 45.w,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: starttimenew,
                              decoration: InputDecoration(
                                icon: Icon(Icons.timer),
                                labelText: 'Start Time',
                                labelStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color:
                                  Colors.black, // Change the label color here
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width:
                                16.0), // Adjust the spacing between the text fields
                        Flexible(
                          child: Container(
                            height: 5.5.h,
                            width: 45.w,
                            child: TextField(
                              enabled: false,
                              controller: endtimenew,
                              decoration: InputDecoration(
                                icon: Icon(Icons.timer),
                                labelText: 'End Time',
                                labelStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color:
                                      Colors.black, // Change the label color here
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight:  Radius.circular(7),
                                      bottomLeft:  Radius.circular(7),
                                      bottomRight:  Radius.circular(7),
                                    )
                                ),
                              ),

                              readOnly:
                                  true, //set it true, so that user will not able to edit text
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Container(
                      height: 5.5.h,
                      width: 45.w,
                      child: TextFormField(
                        enabled: false,
                        controller: selectassignenew,
                        decoration: InputDecoration(
                          labelText: 'Assign Name',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black, // Change the label color here
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight:  Radius.circular(7),
                                bottomLeft:  Radius.circular(7),
                                bottomRight:  Radius.circular(7),
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight:  Radius.circular(7),
                                bottomLeft:  Radius.circular(7),
                                bottomRight:  Radius.circular(7),
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight:  Radius.circular(7),
                                bottomLeft:  Radius.circular(7),
                                bottomRight:  Radius.circular(7),
                              )
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Image  :  ',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        ),
                        SizedBox(
                            width:
                                16.0), // Adjust the spacing between the text fields
                        Flexible(
                          child: imageUrl != null
                              ? Image.network(
                                  '$imageUrl',
                                  height: 200, // Set the height
                                  width: 300,
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                  //color: Colors.grey,
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Audio  :  ',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        ),
                        SizedBox(
                            width:
                                10.0), // Adjust the spacing between the text fields
                        Flexible(
                          child: audio != ''
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff7c81dd),
                                  ),
                                  onPressed: () {
                                    String audioUrl = '$audiourl';
                                    playAudio(audioUrl);
                                  },
                                  child: Text('Play',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13.0,
                                          color: Colors.white)),
                                )
                              : SizedBox(),
                        ),
                        SizedBox(width: 5.0),
                        Flexible(
                          child: audio != ''
                              ? Container(
                                  //width: 150, // Set the width you desire
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff7c81dd),
                                    ),
                                    onPressed: () {
                                      pauseAudio();
                                    },
                                    child: Text(
                                      'Stop Audio',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13.0,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
