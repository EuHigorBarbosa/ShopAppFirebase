import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/models.dart';
import 'package:shop/pages/pages.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    //return auth.isAuth ? ProductOverviewPage() : AuthPage();
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.error != null) {
          return Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? ProductOverviewPage() : AuthPage();
        }
      },
    );
  }
}
