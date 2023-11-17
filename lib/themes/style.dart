import 'package:flutter/material.dart';

/// @@ Text Size
const kFontSize2Xxs = 8.0;
const kFontSizeXxs = 10.0;
const kFontSizeXs = 12.0;
const kFontSizeS = 14.0;
const kFontSizeM = 16.0;
const kFontSizeL = 18.0;
const kFontSizeXL = 20.0;
const kFontSize2XL = 22.0;
const kFontSize3XL = 24.0;
const kFontSize4XL = 26.0;
const kFontSize5XL = 28.0;

/// @@ Custom => Text Size
const kFontSizeBigger1 = 32.0;
const kFontSizeBigger2 = 36.0;
const kFontSizeBigger3 = 40.0;
const kFontSizeBigger4 = 48.0;
const kFontSizeBigger5 = 56.0;
const kFontSizeBigger6 = 64.0;

/// @@ Colors
const kColorPrimary = Colors.blueAccent;
const kColorPrimaryDark = Colors.blue;
const kColorPrimaryLight = Colors.lightBlue;
const kColorWhite = Color(0xffffffff);
const kColorBlack = Color(0xff000000);
const kColorGreyF7 = Color(0xfff7f7f7);
const kColorRed = Color(0xffff0000);

/// @@ Gradient Colors

const kGradientColorLinearRight = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  stops: [0.6, 2.0],
  colors: [
    kColorPrimary,
    kColorPrimaryLight,
  ],
  tileMode: TileMode.clamp,
);

const kGradientColorLinearLeft = LinearGradient(
  begin: Alignment(-1.0, -1.0),
  end: Alignment(0.0, 1.0),
  stops: [0, 0.8],
  colors: [
    kColorPrimaryLight,
    kColorPrimary,
  ],
  tileMode: TileMode.clamp,
);
