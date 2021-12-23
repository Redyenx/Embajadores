import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class CustomColors {
  Color contextColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? const Color.fromRGBO(255, 255, 255, 1.0)
        : const Color.fromRGBO(55, 55, 55, 0.9);
  }

  Color iconsColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? const Color.fromRGBO(232, 89, 89, 0.9019607843137255)
        : const Color.fromRGBO(13, 174, 194, 0.9019607843137255);
  }

  Color iconsInvertColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? const Color.fromRGBO(13, 174, 194, 0.9019607843137255)
        : const Color.fromRGBO(205, 27, 27, 0.9019607843137255);
  }

  Color textColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? const Color.fromRGBO(0, 0, 0, 0.9019607843137255)
        : const Color.fromRGBO(13, 174, 194, 0.9019607843137255);
  }

  Color textButtonColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? const Color.fromRGBO(255, 255, 255, 0.9019607843137255)
        : const Color.fromRGBO(73, 17, 173, 0.9019607843137255);
  }

  Color textDetailsColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? const Color.fromRGBO(73, 17, 173, 0.9019607843137255)
        : const Color.fromRGBO(255, 255, 255, 0.9019607843137255);
  }

  Color shadowTextColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? const Color.fromRGBO(73, 17, 173, 0.9019607843137255)
        : const Color.fromRGBO(13, 174, 194, 0.9019607843137255);
  }

  Color shadowColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? const Color.fromRGBO(232, 89, 89, 0.9019607843137255)
        : const Color.fromRGBO(13, 148, 165, 0.9019607843137255);
  }

  Color borderColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? const Color.fromRGBO(226, 161, 161, 0.7686274509803922)
        : const Color.fromRGBO(108, 200, 211, 0.8862745098039215);
  }
}
