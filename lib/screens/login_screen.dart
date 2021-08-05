import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kindness/components/strings.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/helpers/validator.dart';
import 'package:kindness/screens/forgot_password_screen.dart';
import 'package:kindness/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
