import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:personalshopper/apiConstant.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/components/form_error.dart';
import 'package:personalshopper/helper/keyboard.dart';
import 'package:personalshopper/screens/homepage/home_screen.dart';
import 'package:personalshopper/size_config.dart';

import 'package:http/http.dart' as http;

import '../../../constants.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? email;
  String? password;

  void addError(String? error) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError(String? error) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          emailField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          passwordField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
              text: "Log In as Customer",
              press: () async {
                if (_formKey.currentState!.validate()) {
                  _loginValidator(email, password, 'Customer');
                }
              }
              // Navigator.pushNamed(context, HomeScreen.routeName),
              // if (_formKey.currentState!.validate()) {
              //   _formKey.currentState!.save();
              //   KeyboardUtil.hideKeyboard(context);
              // }
              ),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Log In as Personal Shopper",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _loginValidator(email, password, 'Personal Shopper');
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      obscureText: true,
      onChanged: (newValue) => password = newValue,
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
        labelText: "Password",
        hintText: "Password",

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

  TextFormField emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (newValue) => email = newValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter username';
        }
        return null;
      },
      // decoration: const InputDecoration(
      //   labelText: 'Username',
      //   errorBorder: OutlineInputBorder(
      //       borderSide: BorderSide(
      //     color: Colors.red,
      //   )),
      //   errorStyle: TextStyle(),
      //   border: OutlineInputBorder(), //InputBorder.none,
      //   contentPadding: EdgeInsets.only(top: 15.0),
      //   prefixIcon: Icon(
      //     Icons.person,
      //     color: Colors.black87,
      //   ),
      //   // hintText: 'Enter your email',
      // ),

      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(kEmailNullError);
      //   } else if (emailValidatorRegExp.hasMatch(value)) {
      //     removeError(kInvalidEmailError);
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(kEmailNullError);
      //     return "";
      //   } else if (!emailValidatorRegExp.hasMatch(value)) {
      //     addError(kInvalidEmailError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Email",
        suffixIcon: const Icon(Icons.email),
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

  // Login Function
  Future<bool> _login(email, password, role) async {
    final response = await http
        .post(Uri.parse('${apiConstant.restApiUrl}/login/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(<String, String>{
              'email': email,
              'password': password,
              'role': role
            }))
        .timeout(const Duration(seconds: 3));

    print(response);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      var parse = json.decode(response.body);
      prefs.setString('id', parse["id"]);
      prefs.setString('user_role', parse["role"]);
      String? userRole = prefs.getString('user_role');
      return true;
    } else {
      // showDialog(
      //   context: context,
      //   builder: (ctx) => AlertDialog(
      //     title: const Text("Invalid Email, Password or Role"),
      //     content:
      //         const Text("You have entered an invalid email, password or role"),
      //     actions: [
      //       ElevatedButton(
      //         onPressed: () => Navigator.of(context).pop(),
      //         child: const Text("Okay"),
      //       ),
      //     ],
      //   ),
      // );
      return false;
    }
    return false;
  }

  void _loginValidator(email, password, role) async {
    var result = await _login(email, password, role);

    if (result == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (_) => false);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Email, Password or Role"),
          content: const Text(
              "You have entered an invalid email or email or picked the wrong role"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    }
  }
}
