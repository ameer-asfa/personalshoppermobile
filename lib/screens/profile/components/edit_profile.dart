import 'dart:convert';
import 'dart:developer';
import 'package:personalshopper/models/Shopper.dart';
import 'package:personalshopper/screens/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personalshopper/apiConstant.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:personalshopper/components/default_button.dart';
import 'package:personalshopper/models/Customer.dart';
import 'package:personalshopper/size_config.dart';

import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static String routeName = "/editprofile";

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? username;
  String? email;
  String? password;
  String? confirmPassword;
  String? name;
  String? phone;
  String? address;
  String? selectedState;
  String? currentState;
  String? role;
  late String _userId;
  late String _userRole;

  TextEditingController? _usernameController;
  TextEditingController? _emailController;
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _addressController;

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

  late Customer customerModel;
  late Shopper shopperModel;

  getCustomerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _userRole = prefs.getString('user_role')!;
    final response = await http.get(
        Uri.parse('${apiConstant.restApiUrl}/profile/' +
            (_userRole == 'Customer' ? 'customer/' : 'shopper/') +
            prefs.getString("id")!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(const Duration(seconds: 3));
    var parse = json.decode(response.body);

    setState(() {
      customerModel = Customer.fromJson(json.decode(response.body));
      _usernameController = TextEditingController(text: parse['username']);
      _emailController = TextEditingController(text: parse['email']);
      _nameController = TextEditingController(text: parse['name']);
      _phoneController = TextEditingController(text: parse['phone']);
      _addressController = TextEditingController(text: parse['address']);
      currentState = parse['state'];
      username = parse['username'];
      email = parse['email'];
      name = parse['name'];
      phone = parse['phone'];
      address = parse['address'];
      selectedState = parse['state'];
      _userId = prefs.getString("id")!;
    });
  }

  @override
  void initState() {
    getCustomerInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenHeight(10)),
          child: Column(
            children: [
              usernameField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              emailField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              nameField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              phoneField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              addressField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              stateDropDown(),
              SizedBox(height: getProportionateScreenHeight(30)),
              DefaultButton(
                  text: "Save",
                  press: () async {
                    _updateValidator(
                        username, email, name, phone, address, selectedState);
                  }),
            ],
          ),
        ),
      ),
    );
  }

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
      hint: Text(
        currentState.toString(),
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

  TextFormField usernameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (newValue) => username = newValue,
      controller: _usernameController,
      //initialValue: username1,
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
      controller: _emailController,
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

  TextFormField nameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (newValue) => name = newValue,
      controller: _nameController,
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
      controller: _phoneController,
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
      controller: _addressController,
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

  Future<bool> _updateProfile(
      username, email, name, phone, address, selectedState) async {
    if (_userRole == 'Customer') {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'PATCH',
          Uri.parse(
              '${apiConstant.restApiUrl}/profile/update/customer/' + _userId));
      request.body = json.encode({
        "email": email,
        "username": username,
        "address": address,
        "phone": phone,
        "state": selectedState,
        "name": name
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
    } else {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'PATCH',
          Uri.parse(
              '${apiConstant.restApiUrl}/profile/update/shopper/' + _userId));
      request.body = json.encode({
        "email": email,
        "username": username,
        "address": address,
        "phone": phone,
        "state": selectedState,
        "name": name
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
  }

  void _updateValidator(
      username, email, name, phone, address, selectedState) async {
    var result = await _updateProfile(
        username, email, name, phone, address, selectedState);
    if (result == true) {
      Navigator.pushNamed(context, ProfileScreen.routeName);
    } else {}
  }
}
