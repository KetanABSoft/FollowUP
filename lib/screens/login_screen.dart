// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'package:validators/validators.dart';
// import '../constant/string_constant.dart';
// import 'dashboard.dart';
//
// String? token;
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//
//   TextEditingController _textEditingController = TextEditingController();
//   final TextEditingController username = TextEditingController();
//   final TextEditingController password = TextEditingController();
//
//   Future emplogin(String username, String password) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     var urlString = AppString.constanturl + 'employeelogin';
//     Uri uri = Uri.parse(urlString);
//     var response = await http.post(uri, body: {
//       "username": username,
//       "password": password,
//     });
//
//     final jsondata = json.decode(response.body);
//     print("jsondata");
//     print(jsondata);
//     if (jsondata['result'] == "failure") {
//       Fluttertoast.showToast(
//         backgroundColor: Color.fromARGB(255, 255, 94, 0),
//         textColor: Colors.white,
//         msg: jsondata['message'],
//         toastLength: Toast.LENGTH_SHORT,
//       );
//     } else if (jsondata['result'] == "success") {
//       Fluttertoast.showToast(
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         msg: jsondata['message'],
//         toastLength: Toast.LENGTH_SHORT,
//       );
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       preferences.setString('id', jsondata['userdata']['id']);
//       preferences.setString('cmpid', jsondata['userdata']['company_id']);
//       preferences.setString('admintype', jsondata['userdata']['admin_type']);
//       preferences.setString('idemp', jsondata['userdata']['admin']);
//
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => DashboardScreen()));
//     }
//   }
//
//   Future login(String username, String password) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     //var urlString = 'http://testfollowup.absoftwaresolution.in/getlist.php?Type=login';
//     var urlString = AppString.constanturl + 'login';
//
//     Uri uri = Uri.parse(urlString);
//     var response = await http.post(uri, body: {
//       "username": username,
//       "password": password,
//     });
//
//     final jsondata = json.decode(response.body);
//     print(jsondata);
//     if (jsondata['result'] == "failure") {
//       Fluttertoast.showToast(
//         backgroundColor: Color.fromARGB(255, 255, 94, 0),
//         textColor: Colors.white,
//         msg: jsondata['message'],
//         toastLength: Toast.LENGTH_SHORT,
//       );
//     } else if (jsondata['result'] == "success") {
//       Fluttertoast.showToast(
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         msg: jsondata['message'],
//         toastLength: Toast.LENGTH_SHORT,
//       );
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       preferences.setString('id', jsondata['userdata']['id']);
//       preferences.setString('cmpid', jsondata['userdata']['company_id']);
//       preferences.setString('admintype', jsondata['userdata']['admin_type']);
//       preferences.setString('idemp', jsondata['userdata']['id_emp']);
//
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => DashboardScreen()));
//     }
//   }
//
//   @override
//   void dispose() {
//     _textEditingController.clear();
//     super.dispose();
//   }
//
//   bool isEmailCorrect = false;
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: 100.h,
//         width: 100.w,
//         decoration: const BoxDecoration(
//           // color: Colors.red.withOpacity(0.1),
//             image: DecorationImage(
//                 image: NetworkImage(
//                   // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShp2T_UoR8vXNZXfMhtxXPFvmDWmkUbVv3A40TYjcunag0pHFS_NMblOClDVvKLox4Atw&usqp=CAU',
//                     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx7IBkCtYd6ulSfLfDL-aSF3rv6UfmWYxbSE823q36sPiQNVFFLatTFdGeUSnmJ4tUzlo&usqp=CAU'),
//                 fit: BoxFit.cover,
//                 opacity: 0.3)),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Column(
//               // crossAxisAlignment: CrossAxisAlignment.center,
//               // mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: 11.h,),
//                 Image.asset(
//                   'assets/loginlogo.jpeg',
//                   height: 17.h,
//                   width: 25.w,
//                 ),
//                 SizedBox(height: 2.h),
//                 Text(
//                   'Log In Now',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 20.0.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 1.5.h,),
//                 Text('Please login to continue using our app',
//                     style: TextStyle(fontFamily: 'Poppins')
//                   // style: GoogleFonts.indieFlower(
//                   //   textStyle: TextStyle(
//                   //       color: Colors.black.withOpacity(0.5),
//                   //       fontWeight: FontWeight.w300,
//                   //       // height: 1.5,
//                   //       fontSize: 15),
//                   // ),
//                 ),
//                 SizedBox(
//                   height: 3.h,
//                 ),
//                 Container(
//                   height: 25.h,
//                   width: 100.w,
//                   // height: isEmailCorrect ? 280 : 200,
//                   // // _formKey!.currentState!.validate() ? 200 : 600,
//                   // // height: isEmailCorrect ? 260 : 182,
//                   // width: MediaQuery.of(context).size.width / 1.1,
//                   decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             left: 20, right: 20, bottom: 20, top: 20),
//                         child: TextFormField(
//                           controller: username,
//                           onChanged: (val) {
//                             setState(() {
//                               isEmailCorrect = isEmail(val);
//                             });
//                           },
//                           decoration: const InputDecoration(
//                             focusedBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius:
//                                 BorderRadius.all(Radius.circular(10))),
//                             enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius:
//                                 BorderRadius.all(Radius.circular(10))),
//                             prefixIcon: Icon(
//                               Icons.person,
//                               color: AppString.appgraycolor,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             // fillColor: Color(0xFFFFD700),
//                             labelText: "Email",
//                             hintText: 'your-email@domain.com',
//                             labelStyle: TextStyle(
//                               color: (AppString.appgraycolor),
//                             ),
//                             // suffixIcon: IconButton(
//                             //     onPressed: () {},
//                             //     icon: Icon(Icons.close,
//                             //         color: Colors.purple))
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: Form(
//                           key: _formKey,
//                           child: TextFormField(
//                             controller: password,
//                             obscuringCharacter: '*',
//                             obscureText: true,
//                             decoration: const InputDecoration(
//                               focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide.none,
//                                   borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                               enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide.none,
//                                   borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                               prefixIcon: Icon(
//                                 Icons.person,
//                                 color: AppString.appgraycolor,
//                               ),
//                               filled: true,
//                               fillColor: Color(0xFFFFD700),
//                               labelText: "Password",
//                               hintText: '*********',
//                               labelStyle:
//                               TextStyle(color: AppString.appgraycolor),
//                             ),
//                             // validator: (value) {
//                             //   if (value!.isEmpty && value!.length < 5) {
//                             //     return 'Enter a valid password';
//                             //     {
//                             //       return null;
//                             //     }
//                             //   }
//                             // },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       // isEmailCorrect
//                       //     ? ElevatedButton(
//                       //         style: ElevatedButton.styleFrom(
//                       //             shape: RoundedRectangleBorder(
//                       //                 borderRadius:
//                       //                     BorderRadius.circular(10.0)),
//                       //             backgroundColor: isEmailCorrect == false
//                       //                 ? Colors.red
//                       //                 : Colors.purple,
//                       //             padding: EdgeInsets.symmetric(
//                       //                 horizontal: 131, vertical: 20)
//                       //             // padding: EdgeInsets.only(
//                       //             //     left: 120, right: 120, top: 20, bottom: 20),
//                       //             ),
//                       //         onPressed: () {
//                       //           if (_formKey.currentState!.validate()) {
//                       //             // If the form is valid, display a snackbar. In the real world,
//                       //             // you'd often call a server or save the information in a database.
//                       //             ScaffoldMessenger.of(context).showSnackBar(
//                       //               const SnackBar(
//                       //                   content: Text('Processing Data')),
//                       //             );
//                       //           }
//                       //           // Navigator.push(
//                       //           //     context,
//                       //           //     MaterialPageRoute(
//                       //           //         builder: (context) => loginScreen()));
//                       //         },
//                       //         child: Text(
//                       //           'Log In',
//                       //           style: TextStyle(fontSize: 17),
//                       //         ))
//                       //     : Container(),
//                     ],
//                   ),
//                 ),
//
//                 //this is button
//                 // const SizedBox(
//                 //   height: 30,
//                 // ),
//                 // ElevatedButton(
//                 //     style: ElevatedButton.styleFrom(
//                 //         shape: RoundedRectangleBorder(
//                 //             borderRadius: BorderRadius.circular(10.0)),
//                 //         backgroundColor: Colors.purple,
//                 //         padding: EdgeInsets.symmetric(
//                 //             horizontal: MediaQuery.of(context).size.width / 3.3,
//                 //             vertical: 20)
//                 //         // padding: EdgeInsets.only(
//                 //         //     left: 120, right: 120, top: 20, bottom: 20),
//                 //         ),
//                 //     onPressed: () {
//                 //       Navigator.push(
//                 //           context,
//                 //           MaterialPageRoute(
//                 //               builder: (context) => loginScreen()));
//                 //     },
//                 //     child: Text(
//                 //       'Sounds Good!',
//                 //       style: TextStyle(fontSize: 17),
//                 //     )), //
//                 SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () async {
//                         final SharedPreferences sharedPreferences =
//                         await SharedPreferences.getInstance();
//                         sharedPreferences.setString(
//                             'username', username.text);
//                         login(username.text, password.text);
//                         username.clear();
//                         password.clear();
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => LoginScreen()));
//                       },
//                       child: Text(
//                         'Login',
//                         style: TextStyle(
//                             color: AppString.appgraycolor,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12,
//                             fontFamily: 'poppins'),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 36, vertical: 18),
//                         backgroundColor: Color(0xFFFFD700),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16)),
//                         elevation: 0,
//                         shadowColor: Colors.transparent,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     ElevatedButton(
//                       onPressed: () async {
//                         final SharedPreferences sharedPreferences =
//                         await SharedPreferences.getInstance();
//                         sharedPreferences.setString(
//                             'username', username.text);
//                         emplogin(username.text, password.text);
//                         username.clear();
//                         password.clear();
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => LoginScreen()));
//                       },
//                       child: Text(
//                         'Employee Login',
//                         style: TextStyle(
//                             color: AppString.appgraycolor,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12,
//                             fontFamily: 'poppins'),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFFFD700),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 36, vertical: 18),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16)),
//                         elevation: 0,
//                         shadowColor: Colors.transparent,
//                       ),
//                     ),
//                   ],
//                 ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: [
//                 //     Text(
//                 //       'You have\'t any account?',
//                 //       style: TextStyle(
//                 //         color: Colors.black.withOpacity(0.6),
//                 //       ),
//                 //     ),
//                 //     TextButton(
//                 //       onPressed: () {},
//                 //       child: Text(
//                 //         'Sign Up',
//                 //         style: TextStyle(
//                 //             color: Colors.purple,
//                 //             fontWeight: FontWeight.w500),
//                 //       ),
//                 //     )
//                 //   ],
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:validators/validators.dart';
import '../constant/string_constant.dart';
import 'dashboard.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _textEditingController = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future emplogin(String username, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var urlString = AppString.constanturl + 'employeelogin';
    Uri uri = Uri.parse(urlString);
    var response = await http.post(uri, body: {
      "username": username,
      "password": password,
    });

    final jsondata = json.decode(response.body);
    print("jsondata");
    print(jsondata);
    if (jsondata['result'] == "failure") {
      Fluttertoast.showToast(
       // backgroundColor: Color.fromARGB(255, 255, 94, 0),
        backgroundColor: Color(0xff8155BA),
        textColor: Colors.white,
        msg: jsondata['message'],
        toastLength: Toast.LENGTH_SHORT,
      );
    } else if (jsondata['result'] == "success") {
      Fluttertoast.showToast(
        // backgroundColor: Colors.green,
        backgroundColor: Color(0xff8155BA),
        textColor: Colors.white,
        msg: jsondata['message'],
        toastLength: Toast.LENGTH_SHORT,
      );
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('id', jsondata['userdata']['id']);
      preferences.setString('cmpid', jsondata['userdata']['company_id']);
      preferences.setString('admintype', jsondata['userdata']['admin_type']);
      preferences.setString('idemp', jsondata['userdata']['admin']);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DashboardScreen()));
    }
  }

  Future login(String username, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //var urlString = 'http://testfollowup.absoftwaresolution.in/getlist.php?Type=login';
    var urlString = AppString.constanturl + 'login';

    Uri uri = Uri.parse(urlString);
    var response = await http.post(uri, body: {
      "username": username,
      "password": password,
    });

    final jsondata = json.decode(response.body);
    print(jsondata);
    if (jsondata['result'] == "failure") {
      Fluttertoast.showToast(
        //backgroundColor: Color.fromARGB(255, 255, 94, 0),
        backgroundColor: Color(0xff8155BA),
        textColor: Colors.white,
        msg: jsondata['message'],
        toastLength: Toast.LENGTH_SHORT,
      );
    } else if (jsondata['result'] == "success") {
      Fluttertoast.showToast(
        //backgroundColor: Colors.green,
        backgroundColor: Color(0xff8155BA),
        textColor: Colors.white,
        msg: jsondata['message'],
        toastLength: Toast.LENGTH_SHORT,
      );
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('id', jsondata['userdata']['id']);
      preferences.setString('cmpid', jsondata['userdata']['company_id']);
      preferences.setString('admintype', jsondata['userdata']['admin_type']);
      preferences.setString('idemp', jsondata['userdata']['id_emp']);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DashboardScreen()));
    }
  }

  @override
  void dispose() {
    _textEditingController.clear();
    super.dispose();
  }

  bool isEmailCorrect = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 45.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 22.sp,
                      width: 22.w,
                      height: 24.h,
                      child: FadeInUp(
                        duration: Duration(seconds: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 118.sp,
                      width: 20.w,
                      height: 17.h,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-2.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 28.sp,
                      top: 12.sp,
                      width: 18.w,
                      height: 17.h,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/clock.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: Container(
                          margin: EdgeInsets.only(top: 45.sp),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 33.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.sp,top: 25.sp,right: 10.sp),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      // child: Container(
                      //   padding: EdgeInsets.all(5),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(
                      //       color: Color.fromRGBO(143, 148, 251, 1),
                      //     ),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Color.fromRGBO(143, 148, 251, .2),
                      //         blurRadius: 20.0,
                      //         offset: Offset(0, 10),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Column(
                      //     children: <Widget>[
                      //       Container(
                      //         padding: EdgeInsets.all(8.0),
                      //         decoration: BoxDecoration(
                      //           border: Border(
                      //             bottom: BorderSide(
                      //               color: Color.fromRGBO(143, 148, 251, 1),
                      //             ),
                      //           ),
                      //         ),
                      //         child: TextField(
                      //           decoration: InputDecoration(
                      //             border: InputBorder.none,
                      //             hintText: "Email or Phone number",
                      //             hintStyle: TextStyle(color: Colors.grey[700]),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 5.h,),
                      //       Container(
                      //         padding: EdgeInsets.all(8.0),
                      //         child: TextField(
                      //           obscureText: true,
                      //           decoration: InputDecoration(
                      //             border: InputBorder.none,
                      //             hintText: "Password",
                      //             hintStyle: TextStyle(color: Colors.grey[700]),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.sp,right: 15.sp),
                        child: Container(
                            height: 6.h,
                            width: 90.w,
                            child: TextFormField(
                              controller: username,
                              decoration: InputDecoration(
                                labelText: "Enter Your Email Or Username",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11.sp),
                                ),
                                enabledBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11.sp),
                                ),
                                focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11.sp),
                                ),
                              ),
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h,),
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      // child: Container(
                      //   padding: EdgeInsets.all(5),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(
                      //       color: Color.fromRGBO(143, 148, 251, 1),
                      //     ),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Color.fromRGBO(143, 148, 251, .2),
                      //         blurRadius: 20.0,
                      //         offset: Offset(0, 10),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Column(
                      //     children: <Widget>[
                      //       Container(
                      //         padding: EdgeInsets.all(8.0),
                      //         decoration: BoxDecoration(
                      //           border: Border(
                      //             bottom: BorderSide(
                      //               color: Color.fromRGBO(143, 148, 251, 1),
                      //             ),
                      //           ),
                      //         ),
                      //         child: TextField(
                      //           decoration: InputDecoration(
                      //             border: InputBorder.none,
                      //             hintText: "Email or Phone number",
                      //             hintStyle: TextStyle(color: Colors.grey[700]),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 5.h,),
                      //       Container(
                      //         padding: EdgeInsets.all(8.0),
                      //         child: TextField(
                      //           obscureText: true,
                      //           decoration: InputDecoration(
                      //             border: InputBorder.none,
                      //             hintText: "Password",
                      //             hintStyle: TextStyle(color: Colors.grey[700]),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.sp,right: 15.sp),
                        child: Container(
                            height: 6.h,
                            width: 90.w,
                            child: TextFormField(
                              controller: password,
                              decoration: InputDecoration(
                                labelText: "Enter Your Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11.sp),
                                ),
                                enabledBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11.sp),
                                ),
                                focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11.sp),
                                ),
                              ),
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Padding(
                      padding: EdgeInsets.only(left: 10.sp,top: 15.sp,right: 10.sp),
                      child: Row(
                        children: [
                          Expanded(
                            child: FadeInUp(
                              duration: Duration(milliseconds: 1900),
                              child: GestureDetector(
                                onTap: () async {
                                  final SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setString(
                                      'username', username.text);
                                  login(username.text, password.text);
                                  username.clear();
                                  password.clear();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                                },
                                child: Container(
                                  height: 5.7.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      " Admin Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          Expanded(
                            child: FadeInUp(
                              duration: Duration(milliseconds: 1900),
                              child: GestureDetector(
                                onTap: () async {
                                  final SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                                  sharedPreferences.setString(
                                      'username', username.text);
                                  emplogin(username.text, password.text);
                                  username.clear();
                                  password.clear();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                                },
                                child: Container(
                                  height: 5.7.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Employee Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    FadeInUp(
                      duration: Duration(milliseconds: 2000),
                      child: Container(
                        height: 15.h,
                        child: Image.asset("assets/images/updated logo.png"),
                        // child: Text(
                        //   "Forgot Password?",
                        //   style: TextStyle(
                        //     color: Color.fromRGBO(143, 148, 251, 1),
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
