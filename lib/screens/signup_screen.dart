import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/helpers/validator.dart';
import 'package:kindness/screens/login_screen.dart';
import 'package:kindness/components/strings.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController authController = AuthController.to;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
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
                    Image.asset(
                      appLogo,
                      height: Get.height / 7,
                    ),
                    SizedBox(
                      height: Get.height / 12,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign-Up',
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
                            obscureText: _obscureText,
                            controller: authController.passwordController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.deepOrange,
                                ),
                                labelText: "Password",
                                labelStyle: TextStyle(
                                  color: Colors.blue[700],
                                ),
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    !_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: kPrimary,
                                  ),
                                )),
                            validator: Validator().password,
                            onChanged: (value) => null,
                            onSaved: (value) =>
                                authController.passwordController.text = value!,
                            maxLines: 1,
                          ),
                          TextFormField(
                            controller:
                                authController.ConfirmPasswordController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.deepOrange,
                              ),
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(
                                color: Colors.blue[700],
                              ),
                            ),
                            validator: Validator().password,
                            obscureText: true,
                            onChanged: (value) => null,
                            onSaved: (value) => authController
                                .ConfirmPasswordController.text = value!,
                            maxLines: 1,
                          ),
                        ]),
                    SizedBox(
                      height: Get.height / 12,
                    ),
                    Column(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",
                              style: TextStyle(color: Colors.white)),
                          TextButton(
                              onPressed: () => Get.to(LoginScreen()),
                              child: Text("Log In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)))
                        ],
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            minimumSize: Size(Get.width, Get.height / 20),
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (authController.passwordController.text
                                      .trim() ==
                                  authController.ConfirmPasswordController.text
                                      .trim()) {
                                authController
                                    .registerWithEmailAndPassword(context);
                              } else {
                                Get.snackbar("password did not matches", "",
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: Duration(seconds: 10),
                                    backgroundColor:
                                        Get.theme.snackBarTheme.backgroundColor,
                                    colorText: Get
                                        .theme.snackBarTheme.actionTextColor);
                              }
                            }
                          }),
                    ])
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
