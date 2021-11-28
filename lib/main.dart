import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/models.dart';
import 'package:shop/models/product_list_observable.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/pages.dart';
import 'package:shop/utils/utils.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductListObservable>(
          ///* Toda vez que eu inicializo um ProductListObservable e eu ainda
          ///* não tenho um token valido eu vou inicializar por meio da função que está no
          ///* parametro create: inicializarei com um token vazio e uma lista vazia
          create: (_) => new ProductListObservable(),

          ///* O proximo parametro será a função que irá fazer o update
          ///* do ProxyProvider que depende do Auth Provider anterior. Essa função utiza 3
          ///* parametros (context, dependente ,previous)
          update: (contextArg, authArg, previousArg) {
            return ProductListObservable(
              authArg.getToken ?? '',
              previousArg?.itemsObservables ?? [],
              authArg.getUserId ?? '',
            );

            ///* Esse token pode não estar disponível, então, se não estiver deve retornar ''
            ///* Caso os itens não estejam disponíveis então passo lista vazia. Os itens podem
            ///* não existir ainda também, por isso a interrogação lá.
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
            create: (_) => new OrderList(),
            update: (contextArg, authArg, previousArg) {
              return OrderList(
                authArg.getToken ?? '',
                previousArg?.items ?? [],
                authArg.getUserId ?? '',
              );
            }),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: AuthOrHomePage(),

        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
          //AppRoutes.HOME: (ctx) => ProductOverviewPage(),
          AppRoutes.AUTH: (ctx) => AuthPage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
          AppRoutes.CART_PAGE: (ctx) => CartPage(),
          AppRoutes.ORDERS: (ctx) => OrdersPage(),
          AppRoutes.PRODUCT_PAGE: (ctx) => ProductPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
          //AppRoutes.CART
        },

        // ==== THEMAS
        theme: ThemeData(
          //* ================= appBarTheme ======================
          // appBarTheme: AppBarTheme(
          //   textTheme: ThemeData.light().textTheme.copyWith(
          //         headline6: TextStyle(
          //           fontFamily: 'OpenSans',
          //           fontSize: 20,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          // ),

          //* ================= font Family ===================
          fontFamily: 'Lato',

          //* ================= textTheme ======================
          //todo par é variavel com textscale, todo impar é fixo
          textTheme: TextTheme(
            button: TextStyle(
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
                color: Colors.white),
            caption: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
            subtitle1: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
            subtitle2: TextStyle(
                fontSize: 14.0 * MediaQuery.textScaleFactorOf(context),
                fontStyle: FontStyle.italic),
            bodyText2: TextStyle(
                fontSize: 14.0 * MediaQuery.textScaleFactorOf(context),
                fontFamily: 'OpenSans'),
            bodyText1: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline2: TextStyle(
                fontSize: 10.0 * MediaQuery.textScaleFactorOf(context),
                fontStyle: FontStyle.normal),
            headline3: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
            headline4: TextStyle(
                fontSize: 12.0 * MediaQuery.textScaleFactorOf(context),
                fontStyle: FontStyle.italic),
            headline5: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
            headline6: TextStyle(
                fontSize: 14.0 * MediaQuery.textScaleFactorOf(context),
                fontStyle: FontStyle.italic),
            overline: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
          ),
          //fontSize: 18 * MediaQuery.textScaleFactorOf(context)
          //mudando de tema dark/light : https://www.youtube.com/watch?v=SEXlV2t8Kn4
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          // Define the default brightness and colors.

          //* ================= colorTheme Gerais ======================
          primaryColor: Colors.purple,
          //accentColor: Colors.red,
          secondaryHeaderColor: Colors.deepOrange,
          errorColor: Colors.redAccent,

          //* ================= colorTheme Especificas ======================

          buttonBarTheme: ButtonBarThemeData(),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            primary: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            textStyle: Theme.of(context).textTheme.headline6,
          )),

          //* ================== Brilho Theme =====================
          brightness: Brightness.light,
        ),
      ),
    );
  }
}
