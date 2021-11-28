import 'package:flutter/material.dart';

class AppColors {
  ///https://medium.com/@kevinnasc/como-utilizar-cores-hexadecimais-no-flutter-2bbdd50d37a9
  /// App colors v.3.0
  static const Color _mainBlack = Color(0xFF23292C);
  static const Color _darkerBlack = Color(0xFF17191E);
  static const Color _greenGray = Color(0XFF809796);
  static const Color _straw = Color(0XFFD6CEBD);
  static const Color _darkerStraw = Color(0XFFBAB3A3);
  static const Color _yellow = Color(0XFFFF9E15);
  static const Color _grey = Color(0XFFF2F2F2);
  static const Color _blue = Color(0XFF0645AD); // or #0B0080
  static const Color _focus = Colors.blue;
  static const Color _red = Color(0XFFCF6D5D);
  static const Color _diagonal = Color(0XFFDED6C9);
  static const Color _upper = Color(0XFF90C2C0);
  static const Color _best = Color(0XFF67AEAB);
  static const Color _lower = Color(0XFFEA9587);
  static const Color _worst = Color(0XFFCF6D5D);
  static const Color _alphaBlack = Colors.black26;
  static const Color _OpacBlack = Colors.black54;
  static const Color _shadow = Color(0X807A4910);
  static const Color _blackButton = Color(0XFF23292C);
  static const Color _disabledColor = Color(0XDDDDDDDD);
  static const Color _white = Color(0XFFFFFFFF);

  /// Logo
  static const Color loginLogo = _mainBlack;
  static const Color headerLogo = _white;
  static const Color logoShadow = _shadow;

  /// Background
  static const Color appBG = _grey;

  /// splash of InkWell
  static const Color splashInkWell = _white;
  //tile of grid
  static const Color tileOfGrid = _mainBlack;

  /// Meal Card
  //* Title:
  static const Color titleOfMealCard = _white;

  //* BackGroundTitle
  static const Color BackGroundTitle = _OpacBlack;

  /// Header
  static const Color appBarBG = _mainBlack;
  static const Color appBarFG = _white;
  static const Color appBarTextColor = _yellow;
  static const Color appBarYellowIcon = _yellow;
  static const Color appBarHintColor = _disabledColor;

  /// Footer
  static const Color footerBG = _mainBlack;
  static const Color footerInactiveIcons = _white;
  static const Color footerActiveIcons = _yellow;
  static const Color footerYellowText = _yellow;
  static const Color footerWhiteText = _white;

  /// Body
  /// Text
  static const Color regularText = _darkerBlack;
  static const Color titleText = _darkerBlack;
  static const Color yellowTitle = _yellow;
  static const Color linkText = _blue;

  /// Buttons
  static const Color grayButtonBG = _greenGray;
  static const Color grayButtonText = _white;
  static const Color yellowButtonBG = _yellow;
  static const Color yellowButtonText = _mainBlack;
  static const Color editionIconButton = _greenGray;
  static const Color scrollBackButtonFG = _greenGray;
  static const Color scrollBackButtonBG = _white;
  static const Color regularIconButton = _greenGray;
  static const Color redButtonBG = _red;
  static const Color redButtonText = _white;
  static const Color blackButtonBG = _blackButton;
  static const blackButtonText = _white;

  /// Icons
  static const Color checkIcon = _yellow;
  static const Color blackIcon = _mainBlack;

  ///Forms
  static const Color formLabel = _darkerBlack;
  static const Color formBorder = _straw;
  static const Color focusedBorder = _focus;
  static const Color radioInactiveButton = _straw;
  static const Color radioActiveButton = _greenGray;
  static const Color radioActiveItem = _white;
  static const Color textBoxPlaceholder = _darkerStraw;
  static const Color errorText = _red;
  static const Color fillColor = _white;
  static const Color disabledFillColor = _disabledColor;

  /// Cards

  static const cardBG = _white;

  /// Menu
  static const Color menuBG = _darkerBlack;
  static const Color menuItemBG = _mainBlack;
  static const Color menuActive = _yellow;
  static const Color menuInactive = _white;
  static const Color menuDivisor = _mainBlack;

  /// Assessment badges
  static const Color badgeInactive = _straw;
  static const Color badgeActive = _yellow;
  static const Color bagdeActiveNumber = _white;

  /// 9box cells
  static const Color neutralBox = _diagonal;
  static const Color goodBox = _upper;
  static const Color bestBox = _best;
  static const Color badBox = _lower;
  static const Color worstBox = _worst;

  /// 9box points
  static const Color regularPoint = _alphaBlack;
  static const Color selectedPoint = _yellow;

  static MaterialStateProperty<Color> materialColor({Color? color}) {
    return MaterialStateProperty.all(color ?? grayButtonBG);
  }
}
