import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassmorphicSnackBar extends SnackBar {
  GlassmorphicSnackBar({
    required String message,
    super.key,
    Color super.backgroundColor = Colors.transparent,
    double blurSigma = 1.0,
    EdgeInsetsGeometry? margin,
    double borderRadius = 16.0,
  }) : super(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          duration: Duration(seconds: 10),
          margin: margin ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
}
