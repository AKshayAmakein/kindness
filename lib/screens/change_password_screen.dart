import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/helpers/validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureText = true;
  AuthController _controller = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change password'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              obscureText: _obscureText,
              controller: _controller.passwordController,
              keyboardType: TextInputType.visiblePassword,
              validator: Validator().password,
              decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: Icon(
                    Icons.lock,
                  ),
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      !_obscureText ? Icons.visibility : Icons.visibility_off,
                      color: kPrimary,
                    ),
                  )),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            TextFormField(
              controller: _controller.ConfirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              validator: Validator().password,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                prefixIcon: Icon(
                  Icons.lock,
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(Get.width, Get.height * 0.05)),
                onPressed: () {
                  if (_controller.passwordController.text.trim() !=
                      _controller.ConfirmPasswordController.text.trim()) {
                    Get.snackbar("Password do not match!", "");
                    return;
                  }
                  _controller.updatePassword(
                      _controller.passwordController.text.trim());
                },
                child: Text("update"))
          ],
        ),
      ),
    );
  }
}
