import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/apiConstant.dart';
import 'package:personalshopper/screens/product_details/components/top_rounded_container.dart';
import 'package:personalshopper/screens/profile/components/edit_profile.dart';
import 'package:personalshopper/screens/sign_in/sign_in_screen.dart';
import 'package:personalshopper/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String oldPassword;
  String? newPassword;
  late SharedPreferences prefs;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Getting user password for comparing old password and new one
  Future<void> getUserPassword() async {
    prefs = await SharedPreferences.getInstance();
    var _userRole = prefs.getString('user_role');

    final response = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/profile/' +
            (_userRole == 'Customer' ? 'customer/' : 'shopper/') +
            prefs.getString("id")!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(seconds: 3));
    var parse = json.decode(response.body);
    setState(() {
      oldPassword = parse['password'];
    });
  }

  @override
  void initState() {
    getUserPassword();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Edit Profile",
            icon: Icons.person,
            press: () => {
              Navigator.pushNamed(context, EditProfileScreen.routeName),
            },
          ),
          ProfileMenu(
            text: "Change Password",
            icon: Icons.lock,
            press: () => {changePasswordModalBottomSheet(context)},
          ),
          ProfileMenu(
              text: "Log Out",
              icon: Icons.logout,
              press: () async => {
                    prefs = await SharedPreferences.getInstance(),
                    prefs.clear(),
                    Navigator.pushNamed(context, SignInScreen.routeName),
                  }),
        ],
      ),
    );
  }

  Future<void> changePasswordModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Text(
                      "Change Password",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    currentPasswordField(),
                    const SizedBox(height: 20),
                    newPasswordField(),
                    const SizedBox(height: 20),
                    DefaultButton(
                      text: "Submit",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _updatePassword(newPassword);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Update password
  Future<bool> _updatePassword(newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    var _userId = prefs.getString('id')!;
    var _userRole = prefs.getString('user_role');

    if (_userRole == 'Customer') {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'PATCH',
          Uri.parse(
              '${apiConstant.restApiUrl}/profile/update_password/customer/' +
                  _userId));
      request.body = json.encode({"password": newPassword});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        Navigator.pop(context);
        return true;
      } else {
        print(response.reasonPhrase);
        return false;
      }
    } else {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'PATCH',
          Uri.parse(
              '${apiConstant.restApiUrl}/profile/update_password/shopper/' +
                  _userId));
      request.body = json.encode({"password": newPassword});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        Navigator.pop(context);
        return true;
      } else {
        print(response.reasonPhrase);
        return false;
      }
    }
  }

  TextFormField currentPasswordField() {
    return TextFormField(
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        } else if (value != oldPassword) {
          return 'Old password is incorrect';
        }
        return null;
      },
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(kPassNullError);
      //   } else if (value.length >= 8) {
      //     removeError(kShortPassError);
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(kPassNullError);
      //     return "";
      //   } else if (value.length < 8) {
      //     addError(kShortPassError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "Current Password",
        hintText: "Current Password",

        //floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: const Icon(Icons.lock),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  TextFormField newPasswordField() {
    return TextFormField(
      obscureText: true,
      onChanged: (newValue) => newPassword = newValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(kPassNullError);
      //   } else if (value.length >= 8) {
      //     removeError(kShortPassError);
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(kPassNullError);
      //     return "";
      //   } else if (value.length < 8) {
      //     addError(kShortPassError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "New Password",
        hintText: "New Password",

        //floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: const Icon(Icons.lock),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
