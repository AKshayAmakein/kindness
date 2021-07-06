import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:file_picker/file_picker.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/model/states.dart';
import 'package:kindness/screens/home_screen_main.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class ProfileSetup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}



class _ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  File? photo;
  var radioValue;
  bool loading = false;
  late String uid;
  DateTime? birthday;
  String? state;
  String photourl = 'defaultImageUrl';
  AuthController authController = Get.find();
  double screenHeight = Get.height;
  double screenWidth = Get.width;

  @override
  void initState() {
    inputData();
    super.initState();
  }

  inputData() async {
    User user = await authController.getUser;
    uid = user.uid;
    print("uid:$uid");
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: Spinner())
        : Container(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: screenHeight, minWidth: screenWidth),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // SizedBox(
                    //   height: screenHeight / 30,
                    // ),
                    //Avatar(),
                    MyTextField(
                      title: 'Full Name',
                      keyBoardType: TextInputType.name,
                      Width: screenWidth,
                      controller: nameController,
                    ),
                    GenderRadio(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10),
                          child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              'Date of Birth',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              PickDate(context);
                            },
                            child: (birthday.isNull)
                                ? Text(
                                    'DD-MM-YYYY',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(color: kPrimary),
                                  )
                                : Text(
                                    '${birthday!.year}-${birthday!.month}-${birthday!.day}',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10),
                          child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              'Where are you from?',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              PickPlace(context);
                            },
                            child: (state.isNull)
                                ? Text(
                                    'Select Place',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(color: kPrimary),
                                  )
                                : Text(
                                    state!,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: kPrimary,
                              minimumSize: Size(
                                screenWidth * 0.7,
                                screenHeight * 0.065,
                              )),
                          onPressed: () {
                            submitDetails();
                          },
                          child: Text(
                            'Submit Details',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: kLight),
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Row GenderRadio(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text('Gender', style: Theme.of(context).textTheme.headline3),
        ),
        Row(
          children: [
            Radio(
              activeColor: kPrimary,
              value: 'M',
              onChanged: (val) {
                radioValue = val;
                setState(() {
                  print(radioValue);
                });
              },
              groupValue: radioValue,
            ),
            Text(
              'Male',
              style:
                  Theme.of(context).textTheme.headline3!.copyWith(fontSize: 14),
            ),
            Radio(
              activeColor: kPrimary,
              value: 'F',
              groupValue: radioValue,
              onChanged: (val) {
                radioValue = val;
                setState(() {
                  print(radioValue);
                });
              },
            ),
            Text(
              'Female',
              style:
                  Theme.of(context).textTheme.headline3!.copyWith(fontSize: 14),
            ),
            Radio(
              activeColor: kPrimary,
              value: 'O',
              groupValue: radioValue,
              onChanged: (val) {
                radioValue = val;
                setState(() {
                  print(radioValue);
                });
              },
            ),
            Text(
              'Other',
              style:
                  Theme.of(context).textTheme.headline3!.copyWith(fontSize: 14),
            )
          ],
        ),
      ],
    );
  }

  var firebase = FirebaseFirestore.instance;
  submitDetails() async {
    if (nameController.text == '' ||
        birthday.isNull ||
        state.isNull ||
        radioValue == null) {
      Get.snackbar(
        "Please fill all details",
        "",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (photo != null) {
      UploadTask photopath = uploadPhoto();
      setState(() {
        loading = true;
      });

      final snapshot = await photopath.whenComplete(() {});
      photourl = await snapshot.ref.getDownloadURL();
    }
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("profileUrl", photourl);
    // prefs.setString("uid", uid);
    // prefs.setString("username", name.text);
    firebase.collection('users').doc(uid).set({
      //'photourl': photourl,
      'name': nameController.text,
      'gender': radioValue.toString(),
      'dob': birthday,
      'state': state,
      'uid': uid
    }).then((value) {
      Get.snackbar(
        "Profile Details Submitted!!",
        "",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    });

    setState(() {
      loading = false;
    });

    Get.to(HomeScreenMain());
  }

  uploadPhoto() {
    DateTime time = DateTime.now();
    String filename = 'files/userImages/${uid + time.toString()}';
    try {
      final ref = FirebaseStorage.instance.ref(filename);

      UploadTask task = ref.putFile(photo!);

      return task;
    } catch (e) {
      print(e);
    }
  }

  void PickDate(context) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return Container(
            height: Get.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              maximumDate: DateTime.now(),
              minimumDate: DateTime(1947),
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (val) {
                print(val);
                birthday = val;
                setState(() {});
              },
              initialDateTime: DateTime(2017),
            ),
          );
        });
  }

  PickPlace(context) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Container(
              child: ListView.builder(
                itemCount: States.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: kSecondary,
                    onTap: () {
                      state = States[index];
                      print(state);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(States[index]),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.title,
    required this.keyBoardType,
    required this.Width,
    required this.controller,
  }) : super(key: key);

  final String title;
  final TextInputType keyBoardType;
  final double Width;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        width: Width,
        decoration: BoxDecoration(
            color: kLight,
            border: Border.all(width: 1, color: kDark),
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: controller,
          keyboardType: keyBoardType,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: title,
            labelStyle: Theme.of(context).textTheme.headline3,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          ),
        ),
      ),
    );
  }
}
//
// class Avatar extends StatefulWidget {
//   const Avatar({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _AvatarState createState() => _AvatarState();
// }
//
// class _AvatarState extends State<Avatar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: InkWell(
//             onTap: () async {
//               FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//               if (result != null) {
//                 setState(() {
//                   File file = File(result.files.single.path!);
//                   photo = file;
//                 });
//               }
//             },
//             child: (photo == null)
//                 ? BuildCircleAvatar(
//                     image: AssetImage('assets/images/profile.png'),
//                   )
//                 : BuildCircleAvatar(image: FileImage(photo!))));
//   }
// }
