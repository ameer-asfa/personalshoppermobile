// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:personalshopper/components/default_button.dart';
// import 'package:personalshopper/components/form_error.dart';
// import 'package:personalshopper/models/Customer.dart';
// import 'package:personalshopper/screens/homepage/home_screen.dart';
// import 'package:personalshopper/screens/sign_up_personal_details/components/dropdown_button.dart';



// import '../../../constants.dart';
// import '../../../size_config.dart';

// class SignUpForm extends StatefulWidget {
//   const SignUpForm({Key? key}) : super(key: key);

//   @override
//   State<SignUpForm> createState() => _SignUpFormState();
// }

// class _SignUpFormState extends State<SignUpForm> {
//   final _formKey = GlobalKey<FormState>();
//   String? name;
//   String? phone;
//   String? address;
//   Customer? customer;
//   final List<String?> errors = [];

//   int index = 0;

//   void addError(String? error) {
//     if (!errors.contains(error)) {
//       setState(() {
//         errors.add(error);
//       });
//     }
//   }

//   void removeError(String? error) {
//     if (errors.contains(error)) {
//       setState(() {
//         errors.remove(error);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: IndexedStack(
//         index: index,
//         children: [
          
//           ),
//           Column(),
//         ],
//       ),
//     );
//   }

 
// }
