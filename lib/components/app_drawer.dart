import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/models.dart';
import 'package:shop/utils/utils.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Bem Vindo Usuário'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.AUTH_OR_HOME,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.ORDERS,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Gerenciar Produtos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.PRODUCT_PAGE,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.computer),
            title: Text('Versão'),
            onTap: () => showDialog<bool>(
              context: context,
              barrierLabel: 'Barrier Label dismissifier',
              // aboutDialog
              // simpleDialog
              // simpleDialogoption
              builder: (ctx) => AboutDialog(
                  applicationName: 'O melhor aplicativo do mundo',
                  applicationLegalese: 'É legal em todo o mundo',
                  applicationIcon: Icon(Icons.star),
                  children: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
                        //é o pop que vai retornar o bool
                      },
                    ),
                  ]),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logoutFunction();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.AUTH_OR_HOME,
              );
            },
          ),
        ],
      ),
    );
  }
}
