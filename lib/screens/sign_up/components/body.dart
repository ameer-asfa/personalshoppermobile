import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:personalshopper/size_config.dart';
import 'form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Register Account",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              const Text(
                "Enter username, email and password \nto sign up",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              const SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}
