import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class CreateGoalScreen extends StatefulWidget {
  @override
  _CreateGoalScreenState createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  late String selectedValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController _controller = AuthController.to;
  bool status6 = false;
  File? _pickedImage;
  final picker = ImagePicker();
  void _pickImage() async {
    final pickedImageFile = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a goal'),
      ),
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.all(18),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("goal_category")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return new Text("fetch error");
            } else if (!snapshot.hasData) {
              return Center(child: Spinner());
            } else
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return Column(
                      children: [
                        DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSelectedItem: true,
                          items: [
                            ds["help"],
                            ds["nature"],
                            ds["rescue"],
                          ],
                          label: "Select category",
                          hint: "",
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
                              print(selectedValue);
                            });
                          },
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: kDark),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextFormField(
                                    controller: _controller.titleController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Title",
                                      labelStyle:
                                          Theme.of(context).textTheme.headline3,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                    ),
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
                                  child: TextFormField(
                                    controller: _controller.descController,
                                    maxLength: 100,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Description",
                                      labelStyle:
                                          Theme.of(context).textTheme.headline3,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Select an Image or Video for your goal',
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            _pickImage();
                                          },
                                          icon: Icon(
                                            Icons.camera_outlined,
                                            color: kPrimary,
                                            size: Get.height * 0.04,
                                          )),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.videocam_outlined,
                                            color: kPrimary,
                                            size: Get.height * 0.04,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Status of the Goal'),
                                    FlutterSwitch(
                                      activeText: "In progress.",
                                      inactiveText: "start",
                                      value: status6,
                                      valueFontSize: 10.0,
                                      width: 110,
                                      borderRadius: 30.0,
                                      showOnOff: true,
                                      onToggle: (val) {
                                        setState(() {
                                          status6 = val;
                                          print(status6);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          Size(Get.width, Get.height * 0.05)),
                                  onPressed: () {
                                    Get.bottomSheet(
                                      Container(
                                        height: Get.height * 0.5,
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey),
                                              width: Get.width * 0.2,
                                              height: Get.height * 0.002,
                                              margin: EdgeInsets.only(top: 6),
                                            ),
                                            _pickedImage == null
                                                ? Container()
                                                : Image.file(_pickedImage!)
                                          ],
                                        ),
                                      ),
                                      isDismissible: false,
                                    );
                                  },
                                  child: Text("Next"),
                                )
                              ],
                            ))
                      ],
                    );
                  });
          },
        ),
      ),
    );
  }
}
