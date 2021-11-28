import 'package:flutter/material.dart';

// //

  // @override
  // Widget build(BuildContext context) {
  //   return TextField(
  //     obscureText: false,
  //     decoration: InputDecoration(
  //       prefixIcon: Icon(Icons.email),
  //       hintText: 'Email',
  //       suffixIcon: Icon(Icons.cancel),
  //     ),
  //   );
  // }
//}

/*
===========
class CustomAppBar extends AppBar {
  CustomAppBar(
      {Widget? leading,
      Widget? title,
      List<Widget>? actions,
      bool? centerTitle,
      Color? actionsIconColor,
      double? iconSize,
      Color? iconColor,
      double? elevation,
      Widget? titleTextStyle,
      PreferredSizeWidget? bottom})
      : super(
          automaticallyImplyLeading: true,
          centerTitle: centerTitle ?? true,
          titleSpacing: 25.0,
          leadingWidth: 60,
          leading: leading,
          title: title,
          bottom: bottom,
          titleTextStyle: titleTextStyle != null
              ? AppTextStyles.boldText(size: 20.0, color: AppColors.appBarFG)
              : null,
          actions: actions != null
              ? actions +
                  [
                    SizedBox(
                      width: 15,
                    )
                  ]
              : actions,
          elevation: elevation ?? 4.0,
          iconTheme: IconThemeData(
              color: iconColor ?? AppColors.appBarFG, size: iconSize ?? 20.0),
          actionsIconTheme: IconThemeData(
              color: actionsIconColor ?? AppColors.appBarFG,
              size: iconSize ?? 20.0),
        );

  factory CustomAppBar.menuInicial({
    required String title,
    Function()? onPressed,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      leading:
          CustomIconButtons.menuInicial(onPressed: onPressed, isActive: true),
      actions: actions,
    );
  }

  
  factory CustomAppBar.categoryMeal({
    required String title,
    Function()? onPressed,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      leading:
          CustomIconButtons.setaVoltar(onPressed: onPressed, isActive: true),
      actions: actions,
      title: Text(
        title,
        style: AppTextStyles.appBarText,
      ),
    );
  }
*/