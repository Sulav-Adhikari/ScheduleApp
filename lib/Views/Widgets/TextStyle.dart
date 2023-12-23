import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle headStyle(){
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      )
  );
}

TextStyle titleStyle(){
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    )
  );
}
TextStyle hintStyle(){
  return GoogleFonts.lato(
      textStyle:  const TextStyle(
        fontSize: 14,
        color: Colors.grey,
        fontWeight: FontWeight.w300,
      )
  );
}