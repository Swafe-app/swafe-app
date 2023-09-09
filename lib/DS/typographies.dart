import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypographyInfo {
  final String name;
  final TextStyle style;

  TypographyInfo(this.name, this.style);
}

List<TypographyInfo> typographyList = [
  TypographyInfo(
      'Title XXLarge Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 36,
        letterSpacing: 0.0,
        height: 32 / 36,
      )),
  TypographyInfo(
      'Title XLarge Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 24,
        letterSpacing: 0.0,
        height: 32 / 24,
      )),
  TypographyInfo(
      'Title Large Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        letterSpacing: 0.0,
        height: 28 / 20,
      )),
  TypographyInfo(
      'Title Medium Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        letterSpacing: 0.0,
        height: 32 / 18,
      )),
  TypographyInfo(
      'Title Small Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: 0.0,
        height: 24 / 16,
      )),
  TypographyInfo(
      'Title XSmall Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.15,
        height: 24 / 14,
      )),
  TypographyInfo(
      'Subtitle large Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.4,
        height: 20 / 14,
      )),
  TypographyInfo(
      'Subtitle large Medium + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.4,
        height: 20 / 14,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Subtitle large Regular',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0.4,
        height: 20 / 14,
      )),
  TypographyInfo(
      'Subtitle medium Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0.4,
        height: 20 / 12,
      )),
  TypographyInfo(
      'Subtitle medium Medium + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0.4,
        height: 20 / 12,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Subtitle medium Regular',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        letterSpacing: 0.4,
        height: 20 / 12,
      )),
  TypographyInfo(
      'Subtitle small Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 10,
        letterSpacing: 0.4,
        height: 20 / 10,
      )),
  TypographyInfo(
      'Subtitle small Medium + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 10,
        letterSpacing: 0.4,
        height: 20 / 10,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Subtitle small Regular',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        letterSpacing: 0.4,
        height: 20 / 10,
      )),
  TypographyInfo(
      'Label Large Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.0,
        height: 20 / 14,
      )),
  TypographyInfo(
      'Label Large Medium + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.0,
        height: 20 / 14,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Label Large Regular + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0.0,
        height: 20 / 14,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Label Large Regular',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0.0,
        height: 20 / 14,
      )),
  TypographyInfo(
      'Label Medium Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0.0,
        height: 16 / 12,
      )),
  TypographyInfo(
      'Label Medium Medium + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0.0,
        height: 16 / 12,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Label Medium Regular',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        letterSpacing: 0.0,
        height: 16 / 12,
      )),
  TypographyInfo(
      'Label Medium Regular + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        letterSpacing: 0.0,
        height: 16 / 12,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Label Small Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 10,
        letterSpacing: 0.0,
        height: 14 / 10,
      )),
  TypographyInfo(
      'Label Small Medium + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 10,
        letterSpacing: 0.0,
        height: 14 / 10,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Label Small Regular',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        letterSpacing: 0.0,
        height: 14 / 10,
      )),
  TypographyInfo(
      'Body XLarge Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: 0.4,
        height: 20 / 16,
      )),
  TypographyInfo(
      'Body XLarge Regular',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        letterSpacing: 0.4,
        height: 20 / 16,
      )),
  TypographyInfo(
      'Body Large Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.4,
        height: 20 / 14,
      )),
  TypographyInfo(
      'Body Large Medium + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.4,
        height: 20 / 14,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Body Large Regular',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0.4,
        height: 20 / 14,
      )),
  TypographyInfo(
      'Body Medium Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0.4,
        height: 16 / 12,
      )),
  TypographyInfo(
      'Body Medium Medium + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0.4,
        height: 16 / 12,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Body Medium Regular',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        letterSpacing: 0.4,
        height: 16 / 12,
      )),
  TypographyInfo(
      'Body Small Medium',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 10,
        letterSpacing: 0.4,
        height: 14 / 10,
      )),
  TypographyInfo(
      'Body Small Medium + underline',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w500,
        fontSize: 10,
        letterSpacing: 0.4,
        height: 14 / 10,
        decoration: TextDecoration.underline,
      )),
  TypographyInfo(
      'Body Small Regular',
      GoogleFonts.overpass(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        letterSpacing: 0.4,
        height: 14 / 10,
      )),
];
