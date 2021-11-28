import 'dart:math';

import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  static late bool isLargeScreen;
  static late double smallerDimension;
  static late double badgeConstraints;
  static const double maxBodyWidth = 7.68; // 768px
  static const double maxBadgewidth = 3.6;

  //calculo da RESPONSIVIDADE (tela de origem: 320 x 533)
  static const widthDeviceOrigin = 320;
  static const heightDeviceOrigin = 533;
  static const relationScreenOrigin = heightDeviceOrigin / widthDeviceOrigin;
  static late double deviceCompensation;
  static late int flexScreenCompensation;

  int _flexScreenCompensation() {
    int _flexScreenCompensation = 1;
    if (screenWidth > widthDeviceOrigin) {
      //se o tamanho
      if (screenWidth * relationScreenOrigin < screenHeight) {
        _flexScreenCompensation =
            ((screenHeight - (screenWidth * relationScreenOrigin)) *
                    100 /
                    (screenWidth * relationScreenOrigin))
                .round();
        print('O flexScreen ficou...$_flexScreenCompensation');

        return _flexScreenCompensation;
      }
    }
    print('O flexScreen ficou...1');
    return 1;
  }

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    isLargeScreen = safeBlockHorizontal >= maxBodyWidth;

    safeBlockHorizontal = min(safeBlockHorizontal, maxBodyWidth);
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    smallerDimension = min(safeBlockHorizontal, safeBlockVertical);
    badgeConstraints = min(smallerDimension, maxBadgewidth);

    //== Responsividade
    deviceCompensation =
        (SizeConfig.screenHeight / SizeConfig.heightDeviceOrigin);
    flexScreenCompensation = _flexScreenCompensation();
  }
}
