import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/help_and_support_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:kindness/widgets/custome_app_bar.dart';

class RequestHelpScreen extends StatefulWidget {
  final String uid;
  final String name;
  final String profileUrl;
  final int coins;
  RequestHelpScreen(
      {required this.uid,
      required this.profileUrl,
      required this.name,
      required this.coins});
  @override
  _RequestHelpScreenState createState() => _RequestHelpScreenState();
}

class _RequestHelpScreenState extends State<RequestHelpScreen> {
  TextEditingController _requirementController = TextEditingController();

  TextEditingController _locationController = TextEditingController();

  TextEditingController _mobileNumberController = TextEditingController();

  TextEditingController _addressController = TextEditingController();

  TextEditingController _discController = TextEditingController();
  DateTime? reqTime;
  File? photo1;
  File? photo2;
  File? photo3;
  File? photo4;
  String photourl1 = "";
  String photourl2 = "";
  String photourl3 = "";
  String photourl4 = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
          leadingIcon: true,
          onTapLeading: () {
            Get.back();
          },
          title: 'Help & Support',
          coins: widget.coins,
        ),
      ),
      body: (loading)
          ? Spinner()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Request Help',
                      style: headlineTextStyle.copyWith(
                          color: textSecondary, fontSize: 15),
                    ),
                    SizedBox(
                      height: Get.height * 0.028,
                    ),
                    TextField(
                      controller: _requirementController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: textSecondary),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: textSecondary),
                        ),
                        labelText: "Your Money Requirement",
                        hintText: "How much money do you need?",
                        labelStyle: GoogleFonts.roboto(
                            color: textSecondary, fontWeight: FontWeight.w500),
                        hintStyle: GoogleFonts.roboto(color: Color(0xffa3a3a3)),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    TextField(
                      controller: _locationController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: textSecondary),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: textSecondary),
                        ),
                        labelText: "Location",
                        hintText: 'Select location',
                        labelStyle: GoogleFonts.roboto(
                            color: textSecondary, fontWeight: FontWeight.w500),
                        hintStyle: GoogleFonts.roboto(color: Color(0xffa3a3a3)),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    TextField(
                      controller: _addressController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: textSecondary),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: textSecondary),
                        ),
                        labelText: "Address",
                        hintText: 'Enter your Address',
                        labelStyle: GoogleFonts.roboto(
                            color: textSecondary, fontWeight: FontWeight.w500),
                        hintStyle: GoogleFonts.roboto(color: Color(0xffa3a3a3)),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: kDark),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: _mobileNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: textSecondary),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: textSecondary),
                          ),
                          labelText: "Mobile Number",
                          prefixText: "+91",
                          hintText: 'Enter Mobile Number',
                          labelStyle: GoogleFonts.roboto(
                              color: textSecondary,
                              fontWeight: FontWeight.w500),
                          hintStyle:
                              GoogleFonts.roboto(color: Color(0xffa3a3a3)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    TextField(
                      controller: _discController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      maxLength: 300,
                      decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: textSecondary),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: textSecondary),
                        ),
                        labelText: "More about requirement",
                        hintText: "Enter details here (Max 300 characters)",
                        labelStyle: GoogleFonts.roboto(
                            color: textSecondary, fontWeight: FontWeight.w500),
                        hintStyle: GoogleFonts.roboto(color: Color(0xffa3a3a3)),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: textSecondary),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload an Image (optional)',
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                color: textSecondary),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    setState(() {
                                      File file =
                                          File(result.files.single.path!);
                                      photo1 = file;
                                    });
                                    UploadTask photopath = uploadPhoto(photo1!);

                                    final snapshot =
                                        await photopath.whenComplete(() {});
                                    photourl1 =
                                        await snapshot.ref.getDownloadURL();
                                  }
                                },
                                child: Container(
                                  child: photo1 == null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              "https://firebasestorage.googleapis.com/v0/b/kindness-40bbd.appspot.com/o/files%2FuserMedia%2Fadd.png?alt=media&token=a65e2267-0671-4c45-80f1-34a245e8dadb",
                                          height: Get.height * 0.08,
                                          color: Colors.grey,
                                        )
                                      : Container(
                                          child: Image.file(
                                            photo1!,
                                            height: Get.height * 0.08,
                                          ),
                                        ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    setState(() {
                                      File file =
                                          File(result.files.single.path!);
                                      photo2 = file;
                                    });
                                    UploadTask photopath = uploadPhoto(photo2!);

                                    final snapshot =
                                        await photopath.whenComplete(() {});
                                    photourl2 =
                                        await snapshot.ref.getDownloadURL();
                                  }
                                },
                                child: photo2 == null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "https://firebasestorage.googleapis.com/v0/b/kindness-40bbd.appspot.com/o/files%2FuserMedia%2Fadd.png?alt=media&token=a65e2267-0671-4c45-80f1-34a245e8dadb",
                                        height: Get.height * 0.08,
                                        color: Colors.grey,
                                      )
                                    : Container(
                                        child: Image.file(
                                          photo2!,
                                          height: Get.height * 0.08,
                                        ),
                                      ),
                              ),
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    setState(() {
                                      File file =
                                          File(result.files.single.path!);
                                      photo3 = file;
                                    });
                                    UploadTask photopath = uploadPhoto(photo3!);

                                    final snapshot =
                                        await photopath.whenComplete(() {});
                                    photourl3 =
                                        await snapshot.ref.getDownloadURL();
                                  }
                                },
                                child: photo3 == null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "https://firebasestorage.googleapis.com/v0/b/kindness-40bbd.appspot.com/o/files%2FuserMedia%2Fadd.png?alt=media&token=a65e2267-0671-4c45-80f1-34a245e8dadb",
                                        height: Get.height * 0.08,
                                        color: Colors.grey,
                                      )
                                    : Container(
                                        child: Image.file(
                                          photo3!,
                                          height: Get.height * 0.08,
                                        ),
                                      ),
                              ),
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    setState(() {
                                      File file =
                                          File(result.files.single.path!);
                                      photo4 = file;
                                    });
                                    UploadTask photopath = uploadPhoto(photo4!);

                                    final snapshot =
                                        await photopath.whenComplete(() {});
                                    photourl4 =
                                        await snapshot.ref.getDownloadURL();
                                  }
                                },
                                child: photo4 == null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "https://firebasestorage.googleapis.com/v0/b/kindness-40bbd.appspot.com/o/files%2FuserMedia%2Fadd.png?alt=media&token=a65e2267-0671-4c45-80f1-34a245e8dadb",
                                        height: Get.height * 0.08,
                                        color: Colors.grey,
                                      )
                                    : Container(
                                        child: Image.file(
                                          photo4!,
                                          height: Get.height * 0.08,
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      'Select Date by which you need funds ',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500, color: textSecondary),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            _pickDate(context);
                          },
                          child: Container(
                            height: Get.height * 0.05,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(color: textSecondary),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'set Date',
                                      style: GoogleFonts.roboto(
                                          color: Color(0xffa3a3a3),
                                          fontSize: 14),
                                    ),
                                    Icon(
                                      Icons.date_range_outlined,
                                      color: Color(0xffa3a3a3),
                                      size: 18,
                                    ),
                                  ],
                                ),
                                reqTime == null
                                    ? Container()
                                    : Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${reqTime!.year}-${reqTime!.month}-${reqTime!.day}',
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.028,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _submitRequest();
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(Get.width, Get.height * 0.05)),
                        child: Text(
                          'Submit',
                          style: GoogleFonts.poppins(),
                        ))
                  ],
                ),
              ),
            ),
    );
  }

  void _pickDate(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return Container(
            height: Get.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              minimumDate: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day),
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (val) {
                print(val);
                reqTime = val;
                setState(() {});
              },
            ),
          );
        });
  }

  uploadPhoto(File photo) {
    DateTime time = DateTime.now();
    String filename =
        'files/help_and_support_Images/${widget.uid + time.toString()}';
    try {
      final ref = FirebaseStorage.instance.ref(filename);

      UploadTask task = ref.putFile(photo);

      return task;
    } catch (e) {
      print(e);
    }
  }

  void _submitRequest() {
    setState(() {
      loading = true;
    });
    if (_requirementController.text == "" ||
        _locationController.text == "" ||
        _addressController.text == "" ||
        _mobileNumberController.text == "" ||
        _discController.text == "") {
      Get.snackbar("All fields are required!", "",
          snackPosition: SnackPosition.BOTTOM);
    }
    setState(() {
      loading = false;
    });
    var requirements = int.parse(_requirementController.text);
    FirebaseFirestore.instance
        .collection("help_and_support")
        .doc(widget.uid)
        .set({
      "photoUrls": [photourl1, photourl2, photourl3, photourl4],
      "username": widget.name,
      "uid": widget.uid,
      "profileUrl": widget.profileUrl,
      "requirements": requirements,
      "location": _locationController.text,
      "address": _addressController.text,
      "phoneNumber": "+91" + _mobileNumberController.text,
      "time_when_needed": reqTime,
      "description": _discController.text,
      "requirement_fulfilled": 0, "status": false,
      // "optional_images":
    }).then((value) {
      Get.snackbar("Submitted", "", snackPosition: SnackPosition.BOTTOM);
      setState(() {
        loading = false;
      });
      Get.to(HelpAndSupportScreen(
          uid: widget.uid, name: widget.name, profileUrl: widget.profileUrl));
    });
  }
}
