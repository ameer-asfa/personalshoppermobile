import 'package:flutter/material.dart';
import 'package:personalshopper/constants.dart';
import 'package:personalshopper/screens/sign_up/sign_up_screen.dart';
import 'package:personalshopper/size_config.dart';

class NoAccount extends StatelessWidget {
  const NoAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              color: kPrimaryColor,
            ),
          ),
        )
      ],
    );
  }
}
