// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle kAppBarTitleStyle(){
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w500
    )
  );
}

TextStyle kButtonTitleStyle(){
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500
    )
  );
}

TextStyle kCommonTextStyle(){
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500
    )
  );
}

TextStyle kSenderTextStyle(){
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.blueAccent,
      fontSize: 12,
      fontWeight: FontWeight.w300
    )
  );
}
