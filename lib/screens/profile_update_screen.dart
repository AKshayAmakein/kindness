import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/controllers/auth_controller.dart';

class ProfileUpdateScreen extends StatelessWidget {
  AuthController _controller = AuthController.to;
  final String uid;
  final String name;
  final String state;
  ProfileUpdateScreen(
      {required this.uid, required this.name, required this.state});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Update'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _controller.nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              TextFormField(
                controller: _controller.stateController,
                decoration: InputDecoration(
                  labelText: "state",
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              TextField(
                controller: _controller.passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "New Password",
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              TextField(
                controller: _controller.ConfirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_controller.nameController.text == "" ||
                        _controller.stateController.text == "" ||
                        _controller.passwordController.text.trim() == "" ||
                        _controller.ConfirmPasswordController.text.trim() ==
                            "" ||
                        _controller.passwordController.text.trim() ==
                            _controller.ConfirmPasswordController.text.trim()) {
                      Get.snackbar("All fields are required!", "");
                    } else {
                      _controller.updateProfile(name, state, uid,
                          _controller.passwordController.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(Get.width, Get.height * 0.05)),
                  child: Text('Update'))
            ],
          ),
        ),
      ),
    );
  }
}
