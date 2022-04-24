import 'dart:convert';

import 'package:flutter/material.dart';
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
                if (_formKey.currentState!.validate())
                  _loginValidator(email, password);
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
                KeyboardUtil.hideKeyboard(context);
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
      ),
    );
  }

  // Login Function
  Future<bool> _login(email, password) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://192.168.1.34:3000/login/'));
    request.body = json.encode({"email": email, "password": password});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  void _loginValidator(email, password) async {
    var result = await _login(email, password);
    if (result == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (_) => false);
    } else {
      print("Pundek");
    }
  }
}
