import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/loading.dart';
import 'package:kindness/screens/home_screen_main.dart';
import 'package:kindness/screens/introduction_screen.dart';
import 'package:kindness/screens/login_screen.dart';
import 'package:kindness/screens/profile_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rxn<User> firebaseUser = Rxn<User>();

  final RxBool admin = false.obs;
  var uuid = Uuid();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    //run every time auth state changes
    ever(firebaseUser, handleAuthChanged);
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ConfirmPasswordController.dispose();
    titleController.dispose();
    descController.dispose();
    super.onClose();
  }

  handleAuthChanged(_firebaseUser) async {
    if (_firebaseUser == null) {
      print('Send to signin');
      Get.offAll(IntroductionOnScreen());
    } else {
      checkIfUser();
    }
  }

  checkIfUser() {
    print("checking if user 123");

    String uid = FirebaseAuth.instance.currentUser!.uid;
    print("uid1234 : $uid");
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      print("network uid : ${value.get('uid')}");
      if (value.get('uid') == uid) {
        Get.offAll(HomeScreenMain());
      } else {
        Get.off(ProfileSetup());
      }
    });
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser!;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  //Method to handle user sign in using email and password
  signInWithEmailAndPassword(BuildContext context) async {
    showLoadingIndicator();
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        Get.to(HomeScreenMain());
      });
      emailController.clear();
      passwordController.clear();
      hideLoadingIndicator();
    } catch (error) {
      hideLoadingIndicator();
      Get.snackbar('Failed to login!', "$error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 7),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  // User registration using email and password
  registerWithEmailAndPassword(BuildContext context) async {
    showLoadingIndicator();
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((result) async {
        if (result.user != null) {
          Get.to(ProfileSetup());
          print('uID: ' + result.user!.uid.toString());
          print('email: ' + result.user!.email.toString());
        }
        emailController.clear();
        passwordController.clear();
      });
    } on FirebaseAuthException catch (error) {
      hideLoadingIndicator();
      Get.snackbar('failed !'.tr, error.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //password reset email
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    showLoadingIndicator();
    try {
      await _auth
          .sendPasswordResetEmail(email: emailController.text)
          .then((value) {
        Get.snackbar(
            'auth.resetPasswordNoticeTitle'.tr, 'auth.resetPasswordNotice'.tr,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      });
      //hideLoadingIndicator();

    } on FirebaseAuthException catch (error) {
      //hideLoadingIndicator();
      Get.snackbar('auth.resetPasswordFailed'.tr, error.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //check if user is an admin user
  isAdmin() async {
    await getUser.then((user) async {
      DocumentSnapshot adminRef =
          await _db.collection('admin').doc(user.uid).get();
      if (adminRef.exists) {
        admin.value = true;
      } else {
        admin.value = false;
      }
      update();
    });
  }

  // Sign out
  Future<void> signOut() async {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    ConfirmPasswordController.clear();
    titleController.clear();
    descController.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return await _auth.signOut();
  }

  createGoal(
      String uid,
      String category,
      bool status,
      DateTime startDate,
      DateTime endDate,
      File file,
      String name,
      String state,
      bool isVideo) async {
    uploadPhoto() {
      DateTime time = DateTime.now();
      String filename = 'files/userMedia/${uid + time.toString()}';
      try {
        final ref = FirebaseStorage.instance.ref(filename);

        UploadTask task = ref.putFile(file);

        return task;
      } catch (e) {
        print(e);
      }
    }

    String imgUrl = "";
    String videoUrl = "";

    try {
      UploadTask? photopath = uploadPhoto();
      final snapshot = await photopath!.whenComplete(() {});
      var mediaUrl = await snapshot.ref.getDownloadURL();
      if (isVideo) {
        videoUrl = mediaUrl;
      } else {
        imgUrl = mediaUrl;
      }
      String postId = uuid.v4();
      _db.collection("goals").doc(postId).set({
        "imgUrl": imgUrl,
        "videoUrl": videoUrl,
        "uid": uid,
        "title": titleController.text,
        "desc": descController.text,
        "goalCategory": category,
        "goalStatus": status,
        "startDate": startDate,
        "endDate": endDate,
        "time": DateTime.now(),
        "userName": name,
        "userState": state,
        "postId": postId
      }).then((value) {
        Get.snackbar('Goal created!', "",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 10),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      });
    } catch (e) {
      Get.snackbar('failed to submit!', "$e",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  updatePassword(password) async {
    try {
      await _auth.currentUser!.updatePassword(password).then((value) {
        Get.snackbar('Password changed!', "",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 10),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
        Get.to(LoginScreen());
      });
    } catch (e) {
      print(e);
    }
  }

  updateProfile(name, state, uid) async {
    try {
      _db
          .collection("users")
          .doc(uid)
          .update({"name": name, "state": state}).then((value) {
        Get.snackbar('Profile update!', "",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 10),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      });
    } catch (e) {
      print(e);
      Get.snackbar('failed to update!', "$e",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }
}
