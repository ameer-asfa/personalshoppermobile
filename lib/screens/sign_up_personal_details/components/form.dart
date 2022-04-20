import 'package:flutter/material.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/components/form_error.dart';
import 'package:personalshopper/screens/homepage/home_screen.dart';
import 'package:personalshopper/screens/sign_up_personal_details/components/dropdown_button.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
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
          firstNameField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          lastNameField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          phoneField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          addressField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          const StateDropDown(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Register",
            press: () => Navigator.pushNamed(context, HomeScreen.routeName),
          ),
        ],
      ),
    );
  }

  TextFormField firstNameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => firstName = newValue,
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
        labelText: "First Name",
        hintText: "First Name",
        suffixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  TextFormField lastNameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => lastName = newValue,
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
        labelText: "Last Name",
        hintText: "Last Name",
        suffixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  TextFormField phoneField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phone = newValue,
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
        labelText: "Phone Number",
        hintText: "Phone Number",
        suffixIcon: Icon(Icons.phone_android),
      ),
    );
  }

  TextFormField addressField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => address = newValue,
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
        labelText: "Address",
        hintText: "Address",
        suffixIcon: Icon(Icons.home),
      ),
    );
  }
}
