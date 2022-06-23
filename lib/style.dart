import 'package:flutter/material.dart';

const Color mainColor=Color(0xFF81D0D6);
Color bgColor=Colors.white;
Color txtColor=Colors.black;
final ibgColor=Colors.grey.withOpacity(0.1); //inactive color
const iTxColor=Colors.black38;

const double cardSize=150;

const TextStyle sTS=TextStyle(fontSize:12);
const TextStyle mTS=TextStyle(fontSize:16);
const TextStyle lTS=TextStyle(fontSize:20);

void changeToDarkMode(){
  bgColor= const Color(0xFF3a3a3c);
  txtColor=Colors.white;
}

MaterialColor mainMColor=MaterialColor(
  mainColor.value,
  const <int, Color>{
    50: mainColor ,
    100: mainColor,
    200: mainColor,
    300: mainColor,
    400: mainColor,
    500: mainColor,
    600: mainColor,
    700: mainColor,
    800: mainColor,
    900: mainColor,
  },
);
