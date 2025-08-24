
import 'dart:ui';

import 'package:flutter/material.dart';

class Helper {

  static Map<String, String> propertyTypeMap = {
    "UNFINISHED_APARTMENT": "شقة عظم",
    "FINISHED_APARTMENT": "شقة مشطبة",
    "VILLA": "فيلا",
    "HOUSE": "منزل مستقل",
    "WAREHOUSE": "مخزن",
    "LAND": "ارض",
  };

  static Map<String, String> currencyMap = {
    "دولار": "Dollar",
    "دينار": "Dinar",
    "شيقل": "Shekel",
  };

  static final Map<String, String> areaUnitMap = {
    "متر مربع": "Square Meter",
    "دونم": "Dunam",
  };
  static Map<String, Color> propertyTypeColorMap = {
    "UNFINISHED_APARTMENT": Colors.pink.shade200,
    "FINISHED_APARTMENT": Colors.orange.shade200,
    "VILLA": Colors.green.shade200,
    "HOUSE": Colors.blue.shade200,
    "WAREHOUSE": Colors.purple.shade200,
    "LAND": Colors.yellow.shade200,
  };

}
