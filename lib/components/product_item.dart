import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/models.dart';
import 'package:shop/utils/utils.dart';

class ProductItem extends StatelessWidget {
  final Product productItem;
  const ProductItem({Key? key, required this.productItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msgErrorOrExcpetionAlert = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red,
        backgroundImage: AssetImage('assets/images/ggg.jpg'),
        child: CircleAvatar(
          radius: 65,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(productItem.imageUrl),
        ),
      ),
      // leading: CircleAvatar(
      //   backgroundImage: NetworkImage(productItem.imageUrl),
      // ),
      title: Text(productItem.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM, arguments: productItem);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                //showDialog é uma Future
                showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Tem Certeza'),
                      content: Text('Quer remover o item do carrinho'),
                      actions: [
                        TextButton(
                          child: Text('Sim'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            //é o pop que vai retornar o bool do showDialog
                            //se true, então value é true e aí executa o if
                          },
                        ),
                        TextButton(
                          child: Text('Não'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        )
                      ],
                    );
                  },
                  //Transformei o then para async, coloquei um await para esperar a
                  //response do http.patch que ta dentro do removeProductFromId e
                  //se der algum erro ele será lançado lá e tratado aqui por meio
                  //de uma mensagem de snackbar
                ).then((value) async {
                  if (value ?? false) {
                    try {
                      await Provider.of<ProductListObservable>(context,
                              listen: false)
                          .removeProductFromId(productItem);
                    } catch (errorOrException) {
                      msgErrorOrExcpetionAlert.showSnackBar(
                        SnackBar(
                          content: Text(errorOrException.toString()),
                        ),
                      );
                    }
                  }
                });
              }, //onPreessed
            ),
          ],
        ),
      ),
    );
  }
}
