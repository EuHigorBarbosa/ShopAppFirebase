import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/components.dart';
import 'package:shop/utils/utils.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key3}) : super(key: key3);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // print(
    //     'deviceCompensation vale ${SizeConfig.screenHeight / SizeConfig.heightDeviceOrigin}');

    print(
        'É esperado o mesmo valor em >>>>>${SizeConfig.flexScreenCompensation}');
    print(
        'Este é o valor de SizeConfig.screenHeight: ${SizeConfig.screenHeight}');
    print(
        'Este é o valor de SizeConfig.heightDeviceOrigin : ${SizeConfig.heightDeviceOrigin}');
    print(
        'Este é o valor para deviceCompensation: ${SizeConfig.deviceCompensation}');
    print('Este é o valor da função: ${SizeConfig.flexScreenCompensation}');
    //============================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(215, 117, 255, 0.5),
                    Color.fromRGBO(255, 188, 117, 0.9),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Center(
                //width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Align(
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              'Minha Loja',
                              style: TextStyle(
                                fontSize: 30 * SizeConfig.deviceCompensation,
                                fontFamily: 'Anton',
                                color: Theme.of(context).bottomAppBarColor,
                              ),
                            ),
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        transform: Matrix4.rotationZ(-8 * pi / 180)
                          ..translate(-10.0),
                        //aqui foi need o operador cascade porque o translate retorna void
                        //veja as anotações da aula 303.
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepOrange.shade900,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, 2),
                              )
                            ]),
                        //alignment: Alignment.center,
                      ),
                      AuthForm(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
