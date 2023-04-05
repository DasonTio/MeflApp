import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const double verticalPadding = 10;
const double horizontalPadding = 20;

const Color backgroundColor = Color(0xFFF5F5F5);
const Color blackColor = Colors.black;
const Color whiteColor = Colors.white;

const Color primaryColor = Color(0xFFFFCB14);
const Color lightPrimaryColor = Color(0xFFFFF2C2);

const Color accentColor = Color(0xFF1F1F29);

const double deafultRadius = 25.0;

TextStyle regularFont = GoogleFonts.inter(fontWeight: FontWeight.w400);
TextStyle mediumFont = GoogleFonts.inter(fontWeight: FontWeight.w500);
TextStyle semiBoldFont = GoogleFonts.inter(fontWeight: FontWeight.w600);
TextStyle boldFont = GoogleFonts.inter(fontWeight: FontWeight.w700);
TextStyle blackFont = GoogleFonts.inter(fontWeight: FontWeight.w800);
NumberFormat formatter = NumberFormat.compactSimpleCurrency(locale: 'id-ID');
NumberFormat moneyFormat = NumberFormat.currency(
  locale: 'id-ID',
  symbol: 'Rp',
  decimalDigits: 0,
);
