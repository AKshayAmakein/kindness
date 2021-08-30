import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var authState = ''.obs;
  var uuid = Uuid();
  String verificationID = '';
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
      getLoggedInUser();
    }
  }

  getLoggedInUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      if (value.exists) {
        Get.offAll(HomeScreenMain());
      } else {
        Get.offAll(ProfileSetup());
      }
    });
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

  Future searchFriends(String queryString) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: queryString)
        .where('name', isLessThan: queryString + 'z')
        .get();
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

  Future<void> loginGuest() async {
    try {
      await _auth.signInAnonymously().then((guest) {
        print("guest id:${guest.user!.uid}");
        Get.defaultDialog(title: "", middleText: "Please Wait...");
        _db.collection("users").doc(guest.user!.uid).set({
          'photourl': "",
          'name': "guest",
          'gender': "",
          'dob': "",
          'state': "",
          'uid': guest.user!.uid,
          'coins': 0,
          'friends': [],
        }).then((value) =>
            {Get.offAll(HomeScreenMain(), transition: Transition.size)});
      });
    } catch (e) {
      print(e);
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

  verifyPhone(String phone) async {
    try {
      await _auth.verifyPhoneNumber(
          timeout: Duration(seconds: 40),
          phoneNumber: phone,
          verificationCompleted: (AuthCredential authCredential) {},
          verificationFailed: (authException) {
            Get.snackbar("error", authException.message.toString());
          },
          codeSent: (String id, [int? forceResent]) {
            this.verificationID = id;
            authState.value = "Login Success";
            Get.snackbar("code send", "");
          },
          codeAutoRetrievalTimeout: (id) {
            this.verificationID = id;
          });
    } catch (e) {
      print("error$e");
      Get.snackbar("Phone Number info!", "Something went wrong");
    }
  }

  verifyOTP(
    String otp,
  ) async {
    try {
      var credential = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: this.verificationID, smsCode: otp));
      if (credential.user != null) {
        Get.snackbar("otp info", "Verified",
            snackPosition: SnackPosition.BOTTOM);
        Get.offAll(ProfileSetup());
      } else {
        Get.offAll(IntroductionOnScreen());
      }
    } catch (e) {
      print("error$e");

      Get.snackbar("otp info", "otp code is not correct!",
          snackPosition: SnackPosition.BOTTOM);
    }
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
