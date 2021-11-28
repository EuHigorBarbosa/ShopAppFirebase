import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget childOfBadge;
  final int value;
  final Color? color;

  const Badge({
    Key? key,
    required this.value,
    this.color,
    required this.childOfBadge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        childOfBadge,
        Positioned(
            right: 8,
            top: 8,
            child: Container(
              height: 16,
              width: 16,
              //alignment: Alignment.center,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color ?? Theme.of(context).errorColor,
              ),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  value.toString(),
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
      ],
    );
  }
}
