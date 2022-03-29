import 'package:flutter/material.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/components/form_error.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? email;
  String? password;
  String? confirmPassword;
  final List<String?> errors = [];

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
    return SafeArea(
      child: Column(
        children: [
          usernameField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          emailField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          passwordField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          confirmPasswordField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          DefaultButton(
            text: "Continue",
            press: () {},
          ),
        ],
      ),
    );
  }

  TextFormField usernameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => username = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(kUsernamelNullError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(kUsernamelNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Username",
        hintText: "Username",
        suffixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  TextFormField emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Email",
        suffixIcon: Icon(Icons.email),
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(kPassNullError);
        } else if (value.length >= 8) {
          removeError(kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Password",
        //floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField confirmPasswordField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(kPassNullError);
        } else if (value.length >= 8) {
          removeError(kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter Password",
        //floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: Icon(Icons.lock),
      ),
    );
  }
}
