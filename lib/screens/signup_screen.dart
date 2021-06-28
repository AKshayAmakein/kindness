import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/helpers/validator.dart';
import 'package:kindness/screens/login_screen.dart';

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
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 48.0),
                  TextFormField(
                    controller: authController.emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                    ),
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
                        ),
                        labelText: "Password",
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
                            color: kprimary,
                          ),
                        )),
                    validator: Validator().password,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.passwordController.text = value!,
                    maxLines: 1,
                  ),
                  TextFormField(
                    controller: authController.ConfirmPasswordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                      labelText: "Confirm Password",
                    ),
                    validator: Validator().password,
                    obscureText: true,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.passwordController.text = value!,
                    maxLines: 1,
                  ),
                  ElevatedButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          authController.signInWithEmailAndPassword(context);
                        }
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                          onPressed: () => Get.to(LoginScreen()),
                          child: Text("Log In"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
