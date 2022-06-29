import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:personalshopper/screens/sign_in/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/components/form_error.dart';
import 'package:personalshopper/screens/homepage/home_screen.dart';

import 'package:http/http.dart' as http;

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
  String? name;
  String? phone;
  String? address;
  String? selectedState;
  String? role;

  // State List for Dropdown Menu
  final List<String> state = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Penang',
    'Perak',
    'Perlis',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
  ];

  final List<String?> errors = [];

  int index = 0; // Indexing for multi-form page

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
      child: IndexedStack(
        index: index,
        children: [
          Column(
            children: [
              usernameField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              emailField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              passwordField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              confirmPasswordField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              roleDropDown(),
              SizedBox(height: getProportionateScreenHeight(30)),
              FormError(errors: errors),
              DefaultButton(
                  text: "Continue",
                  press: () {
                    setState(() {
                      index++;
                    });
                  }),
            ],
          ),
          Column(
            children: [
              nameField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              phoneField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              addressField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              stateDropDown(),
              SizedBox(height: getProportionateScreenHeight(30)),
              DefaultButton(
                  text: "Register",
                  press: () async {
                    _registerValidator(username, email, password, name, phone,
                        address, selectedState, role);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  // Dropdown Field for User Role
  DropdownButtonFormField2<String> stateDropDown() {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: const Text(
        'State',
        style: TextStyle(fontSize: 16),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 40, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: state
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select state';
        }
      },
      onChanged: (value) {
        selectedState = value.toString();
      },
      onSaved: (value) {
        selectedState = value.toString();
      },
    );
  }

  // Dropdown Field for User Role
  DropdownButtonFormField2<String> roleDropDown() {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: const Text(
        'User Role',
        style: TextStyle(fontSize: 16),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 40, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: ['Personal Shopper', 'Customer']
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select user role';
        }
      },
      onChanged: (value) {
        role = value.toString();
      },
      onSaved: (value) {
        role = value.toString();
      },
    );
  }

  TextFormField usernameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (newValue) => username = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(kUsernamelNullError);
      //   }
      // },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(kUsernamelNullError);
      //     return "";
      //   }
      //   return null;
      // },
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
      onChanged: (newValue) => email = newValue,
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
      onChanged: (newValue) => password = newValue,
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
      onChanged: (newValue) => confirmPassword = newValue,
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
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter Password",
        //floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField nameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (newValue) => name = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(kUsernamelNullError);
      //   }
      // },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(kUsernamelNullError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: const InputDecoration(
        labelText: "Full Name",
        hintText: "Full Name",
        suffixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  TextFormField phoneField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onChanged: (newValue) => phone = newValue,
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
      onChanged: (newValue) => address = newValue,
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
      decoration: const InputDecoration(
        labelText: "Address",
        hintText: "Address",
        suffixIcon: Icon(Icons.home),
      ),
    );
  }

  Future<bool> _register(username, email, password, name, phone, address,
      selectedState, role) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://192.168.0.119:3000/sign_up/'));
    request.body = json.encode({
      "email": email,
      "password": password,
      "username": username,
      "name": name,
      "address": address,
      "phone": phone,
      "state": selectedState,
      "role": role
    });
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

  void _registerValidator(username, email, password, name, phone, address,
      selectedState, role) async {
    var result = await _register(
        username, email, password, name, phone, address, selectedState, role);
    if (result == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, SignInScreen.routeName, (_) => false);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Email or Password"),
          content: const Text("You have entered an invalid email or password"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop,
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    }
  }
}
