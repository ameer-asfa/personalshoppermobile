import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class headerButton extends StatelessWidget {
  const headerButton({
    Key? key,
    required this.iconSrc,
    required this.numberOfItems,
    required this.press,
  }) : super(key: key);

  final IconData iconSrc;
  final int numberOfItems;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(16)),
            height: getProportionateScreenHeight(100),
            width: getProportionateScreenWidth(53),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(iconSrc),
          ),
          if (numberOfItems != 0)
            Positioned(
              top: 10,
              right: 0,
              child: Container(
                height: getProportionateScreenHeight(16),
                width: getProportionateScreenWidth(16),
                decoration: BoxDecoration(
                  color: Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "$numberOfItems",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10),
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
