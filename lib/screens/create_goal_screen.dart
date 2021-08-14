import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/screens/all_goals_screen.dart';
import 'package:kindness/screens/goals_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateGoalScreen extends StatefulWidget {
  @override
  _CreateGoalScreenState createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  String selectedValue = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController _controller = AuthController.to;
  bool status6 = false;
  bool recurring = false;
  File? _pickedImage;
  final picker = ImagePicker();
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  late String uid;
  String name = "";
  String state = "";
  bool isVideo = false;

  getUserData() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      setState(() {
        name = value.get("name");
        state = value.get("state");
      });
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();

        startDate = args.value.startDate;
        endDate = args.value.endDate;
        print(startDate);
        print(endDate);
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  void _pickImageCamera() async {
    final pickedImageFile = await picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
  }

  void _pickVideoCamera() async {
    final pickedVideoFile = await picker.getVideo(source: ImageSource.camera);
    // await _playVideo(pickedVideoFile);
    setState(() {
      _pickedImage = File(pickedVideoFile!.path);
      isVideo = true;
    });
  }

  getUid() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void initState() {
    getUid();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Spinner()
          : Container(
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
                          List catag = ds['catagories'];
                          List<String> catagories =
                              new List<String>.from(catag);
                          return Column(
                            children: [
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      TextFormField(
                                        controller: _controller.titleController,
                                        decoration: InputDecoration(
                                          enabledBorder: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: textSecondary),
                                          ),
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(20.0),
                                            borderSide: BorderSide(
                                                color: textSecondary),
                                          ),
                                          labelText: "Title",
                                          hintText: 'Title of your Goal',
                                          labelStyle: GoogleFonts.roboto(
                                              color: textSecondary,
                                              fontWeight: FontWeight.w500),
                                          hintStyle: GoogleFonts.roboto(
                                              color: Color(0xffa3a3a3)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      DropdownSearch<String>(
                                        mode: Mode.MENU,
                                        showSelectedItem: true,
                                        items: catagories,
                                        label: "Select category",
                                        hint: "",
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValue = value!;
                                            print(selectedValue);
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      TextFormField(
                                        controller: _controller.descController,
                                        maxLength: 300,
                                        maxLines: 100,
                                        minLines: 5,
                                        decoration: InputDecoration(
                                          enabledBorder: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: textSecondary),
                                          ),
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(20.0),
                                            borderSide: BorderSide(
                                                color: textSecondary),
                                          ),
                                          labelText: "Description",
                                          hintText: 'Describe your Goal',
                                          labelStyle: GoogleFonts.roboto(
                                              color: textSecondary,
                                              fontWeight: FontWeight.w500),
                                          hintStyle: GoogleFonts.roboto(
                                              color: Color(0xffa3a3a3)),
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
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            child: IconButton(
                                                onPressed: () {
                                                  _pickImageCamera();
                                                },
                                                icon: Icon(
                                                  Icons.camera_outlined,
                                                  color: textSecondary,
                                                  size: Get.height * 0.04,
                                                )),
                                          ),
                                          (_pickedImage == null)
                                              ? Container(
                                                  width: 20,
                                                )
                                              : Icon(
                                                  Icons.done,
                                                  color: Colors.green,
                                                ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            child: IconButton(
                                                onPressed: () {
                                                  _pickVideoCamera();
                                                },
                                                icon: Icon(
                                                  Icons.videocam_outlined,
                                                  color: textSecondary,
                                                  size: Get.height * 0.04,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional
                                                .bottomStart,
                                            child: Text(
                                                "Select start and end date of your goal"),
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.02,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              (startDate == null)
                                                  ? Container()
                                                  : Container(
                                                      child: Text(
                                                        '${startDate!.year}-${startDate!.month}-${startDate!.day}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      SfDateRangePicker(
                                                                    backgroundColor:
                                                                        kLight,
                                                                    onSelectionChanged:
                                                                        _onSelectionChanged,
                                                                    selectionMode:
                                                                        DateRangePickerSelectionMode
                                                                            .range,
                                                                    initialSelectedRange: PickerDateRange(
                                                                        DateTime.now().subtract(const Duration(
                                                                            days:
                                                                                4)),
                                                                        DateTime.now().add(const Duration(
                                                                            days:
                                                                                3))),
                                                                  ),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    Text('Ok'),
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  icon: Icon(
                                                    Icons.date_range_outlined,
                                                    color: textSecondary,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              (endDate == null)
                                                  ? Container()
                                                  : Container(
                                                      child: Text(
                                                        '${endDate!.year}-${endDate!.month}-${endDate!.day}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: Get.height * 0.02),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Status of the Goal'),
                                          FlutterSwitch(
                                            activeText: "In progress.",
                                            inactiveText: "Start",
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
                                              minimumSize: Size(Get.width,
                                                  Get.height * 0.05)),
                                          onPressed: () {
                                            print(name);
                                            if (uid.isEmpty ||
                                                selectedValue == "" ||
                                                status6 == false ||
                                                startDate.isNull ||
                                                endDate.isNull ||
                                                name == "" ||
                                                state == "" ||
                                                _pickedImage.isNull) {
                                              Get.snackbar("Not Complete",
                                                  "All fields are required",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM);
                                              return;
                                            }
                                            setState(() {
                                              isLoading = true;
                                            });
                                            _controller
                                                .createGoal(
                                                    uid,
                                                    selectedValue,
                                                    status6,
                                                    startDate!,
                                                    endDate!,
                                                    _pickedImage!,
                                                    name,
                                                    state,
                                                    isVideo)
                                                .then((value) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              Get.to(GoalsScreen());
                                            });
                                          },
                                          child: Text('Create Goal'))
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
