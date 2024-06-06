import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:followup/constant/conurl.dart';
import 'package:followup/screens/dashboard.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Lead_list.dart';


class LeadForm extends StatefulWidget {
  final String? id;
  final String? task;

  LeadForm({required this.id, required this.task});

  @override
  State<LeadForm> createState() => _LeadFormState();
}

File? _selectedImage = null;
final picker = ImagePicker();

class _LeadFormState extends State<LeadForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController CustomerName = TextEditingController();
  TextEditingController CompanyName = TextEditingController();
  TextEditingController ContactNo = TextEditingController();
  TextEditingController MailId = TextEditingController();
  TextEditingController Website = TextEditingController();
  TextEditingController Description = TextEditingController();
  TextEditingController OwnerName = TextEditingController();

  LocationData? currentLocation;
  String? leadImageUrl = null;
  String? imageUrl = null;

  @override
  void initState() {
    getLocation();
    getlead(widget.id);
    super.initState();
  }

  void myAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(
            'Please choose media to select',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                SizedBox(height: 1.h,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff8155BA),
                  ),
                  onPressed: () {
                    _captureImage();
                    // Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.camera, color: Colors.white),
                      Text(
                        'From Camera',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                      Navigator.pop(context);
                      },
                      child: Container(
                        height: 4.h, // Assuming you want to specify height in logical pixels
                        width: 20.w, // Assuming you want to specify width in logical pixels
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xff8155BA), // Use 'const' for color for better performance
                        ),
                        child: Center(
                          child: Text(
                            'Back',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _selectImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageUrl = null;
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        imageUrl = null;
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  // Widget _buildSelectedImage() {
  //   if (_selectedImage != null || imageUrl != null) {
  //     return imageUrl != null
  //         ? Image.network(imageUrl!)
  //         : Image.file(_selectedImage!);
  //   } else {
  //     return SizedBox();
  //   }
  // }

  Widget _buildSelectedImage() {
    if (_selectedImage != null || imageUrl != null) {
      return Container(
        height: 150, // Set the desired height here
        child: imageUrl != null
            ? Image.network(imageUrl!)
            : Image.file(_selectedImage!),
      );
    } else {
      return SizedBox();
    }
  }

  Future<void> getlead(id) async {
    var urlString = AppString.constanturl + 'getleaddetails';
    Uri uri = Uri.parse(urlString);
    var response = await http.post(uri, body: {
      "id": '$id',
    });
    var jsondata = jsonDecode(response.body);
    print(jsondata);
    CustomerName.text = jsondata['customer_name'] ?? "";
    CompanyName.text = jsondata['company_name'] ?? "";
    ContactNo.text = jsondata['contact_no'] ?? "";
    MailId.text = jsondata['mail_id'] ?? "";
    Website.text = jsondata['website'] ?? "";
    Description.text = jsondata['description'] ?? "";
    OwnerName.text = jsondata['owner_name'] ?? "";
    leadImageUrl = jsondata['lead_img'];
    if (leadImageUrl != null && leadImageUrl!.isNotEmpty) {
      setState(() {
        imageUrl = AppString.imageurl + '$leadImageUrl';
      });
    } else {
      setState(() {
        _selectedImage = null;
        imageUrl = null;
      });
    }
  }

  Future<void> getLocation() async {
    var location = Location();
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void savelead(customer_name, company_name, contact_no, mail_id, website, desc,
      owner_name) async {

  SharedPreferences preferences = await SharedPreferences.getInstance();
     id = preferences.getString('id');
    cmpid = preferences.getString('cmpid');

    var urlString = AppString.constanturl + 'create_lead';
    Uri uri = Uri.parse(urlString);
    var response = await http.post(uri, body: {
      "customer_name": customer_name,
      "company_name": company_name,
      "contact_number": contact_no,
      "mail_id": mail_id,
      "website": website,
      "description": desc,
      "owner_name": owner_name,
      "lat": '${currentLocation?.latitude}',
      "long": '${currentLocation?.longitude}',
      "emp_id": '${id}',
      "company_id": '${cmpid}',
    });

    var jsonResponse = json.decode(response.body);
    if (_selectedImage != null) {
      saveimage(jsonResponse['id']);
    }
    if (jsonResponse['result'] == "sucess") {
      Fluttertoast.showToast(
        backgroundColor: Color(0xff8155BA),
        textColor: Colors.white,
        msg: 'Lead Added Successfully.',
        toastLength: Toast.LENGTH_SHORT,
      );
      setState(() {
        _selectedImage == null;
        imageUrl == null;
        CustomerName.text = "";
        CompanyName.text = "";
        ContactNo.text = "";
        MailId.text = "";
        Description.text = "";
        OwnerName.text = "";
        Website.text = "";
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LeadList()),
      );
    }
  }

  // Future<void> saveimage(id) async {
  //   try {
  //     var urlString = AppString.constanturl + 'addLeadimage'; // Update the URL
  //     Uri uri = Uri.parse(urlString);
  //     var request = http.MultipartRequest('POST', uri);

  //     // Assuming _selectedImage is a File object representing the image you want to upload
  //     if (_selectedImage != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'image', // Field name for the image in your API
  //           _selectedImage!.path,
  //         ),
  //       );
  //       request.fields['id'] = id.toString();
  //       var response = await request.send();
  //       if (response.statusCode == 200) {
  //         setState(() {
  //           _selectedImage = null;
  //           imageUrl = null;
  //         });
  //         print('Image uploaded successfully');
  //       } else {
  //         print('Image upload failed with status code: ${response.statusCode}');
  //       }
  //     } else {
  //       print('No image selected for upload');
  //     }
  //   } catch (e) {
  //     print('Error during image upload: $e');
  //   }
  // }

  Future<void> saveimage(id) async {
    try {
      var urlString = AppString.constanturl + 'addLeadimage'; // Update the URL
      Uri uri = Uri.parse(urlString);
      var request = http.MultipartRequest('POST', uri);

      // Assuming _selectedImage is an XFile from an image picker
      if (_selectedImage != null) {
        String imagePath = _selectedImage!.path; // Get the file path from XFile

        // Compress the selected image
        List<int> compressedImage = await FlutterImageCompress.compressWithList(
          File(imagePath).readAsBytesSync(),
          quality: 80, // Adjust the compression quality as needed
        );

        var compressedFile = File(imagePath)..writeAsBytesSync(compressedImage);

        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // Field name for the image in your API
            compressedFile.path, // Use the compressed image path
          ),
        );

        request.fields['id'] = id.toString();
        var response = await request.send();
        if (response.statusCode == 200) {
          setState(() {
            _selectedImage = null;
            imageUrl = null;
          });
          print('Image uploaded successfully');
        } else {
          print('Image upload failed with status code: ${response.statusCode}');
        }
      } else {
        print('No image selected for upload');
      }
    } catch (e) {
      print('Error during image upload: $e');
    }
  }

  void updatelead(customer_name, company_name, contact_no, mail_id, website,
      desc, owner_name) async {
    var urlString = AppString.constanturl + 'update_lead';
    Uri uri = Uri.parse(urlString);
    var response = await http.post(uri, body: {
      "customer_name": customer_name,
      "company_name": company_name,
      "contact_number": contact_no,
      "mail_id": mail_id,
      "website": website,
      "description": desc,
      "owner_name": owner_name,
      "lat": '${currentLocation?.latitude}',
      "long": '${currentLocation?.longitude}',
      "id": widget.id
    });

    var jsondata = jsonDecode(response.body);
    if (_selectedImage != null) {
      saveimage(widget.id);
    }
    if (jsondata['result'] == "sucess") {
      Fluttertoast.showToast(
        backgroundColor: Color(0xff8155BA),
        textColor: Colors.white,
        msg: 'Lead Updated Successfully.',
        toastLength: Toast.LENGTH_SHORT,
      );
      setState(() {
        _selectedImage == null;
        imageUrl == null;
        CustomerName.text = "";
        CompanyName.text = "";
        ContactNo.text = "";
        MailId.text = "";
        Description.text = "";
        OwnerName.text = "";
        Website.text = "";
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LeadList()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff8155BA),
          elevation: 0,
          title:  Text(
            'Create Lead',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding:  EdgeInsets.all(12.0.sp),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 1.h,),
                      Container(
                        height: 8.5.h,
                        child: TextFormField(
                          controller: CustomerName,
                          decoration: const InputDecoration(
                            labelText: 'Customer Name',
                            helperText: "",
                            labelStyle: TextStyle(
                              color: Colors.black,
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
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(
                                r'[a-zA-Z ]')), // Allow letters and spaces
                          ],

                        ),
                      ),
                      SizedBox(height: 1.h,),
                      Container(
                        height: 8.5.h,
                        child: TextFormField(
                          controller: CompanyName,
                          decoration: const InputDecoration(
                            labelText: 'Company Name',
                            helperText:'',
                            labelStyle: TextStyle(
                              color: Colors.black,
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Company Name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 1.h,),
                      Container(
                        height: 8.5.h,
                        child: TextFormField(
                          controller: ContactNo,
                          decoration: const InputDecoration(
                            labelText: 'Contact number',
                            helperText: "",
                            labelStyle: TextStyle(
                              color: Colors.black,
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
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]')), // Allow only numbers
                            LengthLimitingTextInputFormatter(
                                10), // Limit the length to 10 characters
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Contact number is required';
                            }
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return 'Invalid contact number format';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        height: 8.5.h,
                        child: TextFormField(
                          controller: MailId,
                          decoration: const InputDecoration(
                            labelText: 'Mail Id',
                            helperText: "",
                            labelStyle: TextStyle(
                              color: Colors.black,
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
                        height: 1.h,
                      ),
                      Container(
                        height: 8.5.h,
                        child: TextFormField(
                          controller: Website,
                          decoration: const InputDecoration(
                            labelText: 'Website',
                            helperText: "",
                            labelStyle: TextStyle(
                              color: Colors.black,
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
                        height: 1.h,
                      ),
                      Container(
                        height: 12.5.h,
                        child: TextFormField(
                          controller: Description,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(
                              color: Colors.black,
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
                        height: 3.h,
                      ),
                      Container(
                        height: 8.5.h,
                        child: TextFormField(
                          controller: OwnerName,
                          decoration: const InputDecoration(
                            labelText: 'Owner name',
                            helperText: "",
                            labelStyle: TextStyle(
                              color: Colors.black,
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
                      // SizedBox(
                      //   height: 3.h,
                      // ),
                      //(_selectedImage != null)
                      _buildSelectedImage(),
                      // : SizedBox(
                      //     height: 10,
                      //   ),
                      if (widget.task != 'view')
                        ElevatedButton(
                          onPressed: () {
                            myAlert();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff8155BA)
                          ),
                          child: Text('Upload Photo',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              )),
                        ),
                      SizedBox(height: 2.h,),
                      if (widget.task != 'view')
                        (
                            Row(
                          children: [
                            Expanded(
                              child: (widget.id != '0')
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Color(0xff8155BA)
                                      ),
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AppString.appgraycolor,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (formKey.currentState!
                                            .validate()) {
                                          updatelead(
                                            CustomerName.text,
                                            CompanyName.text,
                                            ContactNo.text,
                                            MailId.text,
                                            Website.text,
                                            Description.text,
                                            OwnerName.text,
                                          );
                                        }
                                      },
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Color(0xff8155BA)
                                      ),
                                      child: Text('Save',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white
                                          )),
                                      onPressed: () {
                                        if (formKey.currentState!
                                            .validate()) {
                                          savelead(
                                              CustomerName.text,
                                              CompanyName.text,
                                              ContactNo.text,
                                              MailId.text,
                                              Website.text,
                                              Description.text,
                                              OwnerName.text);
                                        }
                                      }),
                            ),
                            SizedBox(
                                width:
                                    6.w
                            ), // You can adjust the spacing between buttons
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:Color(0xff8155BA)
                                ),
                                child: Text(
                                  'Show list',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color:Colors.white
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LeadList()),
                                  );
                                  setState(() {
                                    _selectedImage = null;
                                    imageUrl = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                        )
                    ],
                  ))),
        ));
  }
}
