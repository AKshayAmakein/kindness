import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/helpers/validator.dart';
import 'package:kindness/screens/forgot_password_screen.dart';
import 'package:kindness/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = AuthController.to;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _otpController = TextEditingController();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color(0xffffffff),
              Color(0xffdadada),
              Color(0xff729dc3)
            ])),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/kindness-40bbd.appspot.com/o/files%2FappIcon%2Fkindness-app.png?alt=media&token=97186a8f-1bf3-4986-88f7-2f214ed0c6d2",
                      height: Get.height / 7,
                    ),
                    SizedBox(
                      height: Get.height / 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log-in',
                          style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        TextFormField(
                          controller: authController.emailController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.deepOrange,
                              ),
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Colors.blue[700],
                              )),
                          validator: Validator().email,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => null,
                          onSaved: (value) =>
                              authController.emailController.text = value!,
                        ),
                        TextFormField(
                          controller: authController.passwordController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.deepOrange,
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Colors.blue[700],
                              )),
                          validator: Validator().password,
                          obscureText: true,
                          onChanged: (value) => null,
                          onSaved: (value) =>
                              authController.passwordController.text = value!,
                          maxLines: 1,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Get.to(ForgotPasswordScreen()),
                            child: Text(
                              'Forgot your password?',
                              style: TextStyle(
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Get.height / 12,
                    ),
                    Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () => Get.to(SignUpScreen()),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              minimumSize: Size(Get.width, Get.height / 20),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                authController
                                    .signInWithEmailAndPassword(context);
                              }
                            }),
                        Text(
                          'Or',
                          style: GoogleFonts.abhayaLibre(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              minimumSize: Size(Get.width, Get.height / 20),
                            ),
                            child: Text(
                              'Login with Otp',
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              Get.defaultDialog(
                                title: "Login",
                                textCancel: "Cancel",
                                textConfirm: "Next",
                                confirmTextColor: Colors.white,
                                onConfirm: () {
                                  // authController.verifyPhone("+91${_phoneController.text}");
                                  if (_phoneController.text.length
                                      .isEqual(10)) {
                                    Get.defaultDialog(
                                        title: "Otp",
                                        textCancel: "Back",
                                        textConfirm: "Verify",
                                        onConfirm: () {
                                          if (_otpController.text.length
                                              .isEqual(6)) {
                                            return authController.verifyOTP(
                                              _otpController.text,
                                            );
                                          } else {
                                            return Get.snackbar(
                                                "otp", "must be 6 character");
                                          }
                                        },
                                        titleStyle: GoogleFonts.poppins(
                                            color: textSecondary,
                                            fontWeight: FontWeight.w500),
                                        content: TextField(
                                          controller: _otpController,
                                          decoration: InputDecoration(
                                            hintText: "123456",
                                          ),
                                        ));
                                    return authController.verifyPhone(
                                        "+91${_phoneController.text}");
                                  } else {
                                    return Get.snackbar(
                                        "Phone Number", "must be 10 character");
                                  }
                                },
                                content: Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: TextField(
                                    controller: _phoneController,
                                    decoration: InputDecoration(
                                      hintText: "1234567890",
                                      prefix: Text('+91'),
                                    ),
                                  ),
                                ),
                                titleStyle: GoogleFonts.poppins(
                                    color: textSecondary,
                                    fontWeight: FontWeight.w500),
                              );
                            }),
                        Text(
                          'Or',
                          style: GoogleFonts.abhayaLibre(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              authController.loginGuest();
                            },
                            child: Text('Guest User?'))
                      ],
                    ),
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
