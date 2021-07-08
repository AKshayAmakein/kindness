import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/model/states.dart';
import 'package:kindness/screens/change_password_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final String uid;

  ProfileUpdateScreen({
    required this.uid,
  });
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  AuthController _controller = AuthController.to;
  String? state;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Update'),
      ),
      body: _isLoading
          ? Center(
              child: Spinner(),
            )
          : Center(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controller.nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                            onPressed: () {
                              PickPlace(context);
                            },
                            child: (state.isNull)
                                ? Text(
                                    'Select Place',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  )
                                : Text(
                                    state!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(color: kPrimary),
                                  )),
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                            } else if (_controller.nameController.text == "" ||
                                state.isNull) {
                              Get.snackbar("All fields are required!", "");
                              setState(() {
                                _isLoading = false;
                              });
                              return;
                            } else
                              print('updating ....');
                            _controller
                                .updateProfile(
                              _controller.nameController.text,
                              state!,
                              widget.uid,
                            )
                                .then((value) {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(Get.width, Get.height * 0.05)),
                          child: Text('Update')),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: kLight,
                          ),
                          onPressed: () {
                            Get.to(ChangePasswordScreen());
                          },
                          child: Text(
                            "Change Password?",
                            style: TextStyle(color: kPrimary),
                          ))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  PickPlace(context) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Container(
              child: ListView.builder(
                itemCount: States.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: kSecondary,
                    onTap: () {
                      state = States[index];
                      print(state);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(States[index]),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
