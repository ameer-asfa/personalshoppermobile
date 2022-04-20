import 'package:flutter/material.dart';
import 'package:personalshopper/screens/sign_up_personal_details/components/body.dart';
import 'package:personalshopper/size_config.dart';

class SignUpPersonalScreen extends StatelessWidget {
  const SignUpPersonalScreen({Key? key}) : super(key: key);

  static String routeName = '/sign_up_personal_details';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Body(),
    );
  }
}
