import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/models.dart';
import 'package:shop/utils/utils.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context, listen: false);
    // esse atributo diz que se houver uma modificação nos daddos então será ouvido pelos listeners
    //estando false não será ouvido e renderizado por se modificar, exceto nos consumers.

    final cart = Provider.of<Cart>(context, listen: false);
    //?Essa linha de codigo faz com que o dado productItem esteja disponível para toda a classe.
    //? Mas tem uma forma de fazer que é mais interessante pois ganha-se performace. É utilizando
    //? o CONSUMER
    final auth = Provider.of<Auth>(context, listen: false);
    print('Essa é a tag: ${productItem.id}');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_DETAIL,
                  arguments: productItem,
                );
              },
              child: Hero(
                tag: productItem.id,
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/ggg.jpg'),
                  image: NetworkImage(productItem.imageUrl),
                  fit: BoxFit.cover,
                ),
              )
              // child: Image.network(
              //   productItem.imageUrl,
              //   fit: BoxFit.cover,
              // ),
              ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                onPressed: () async {
                  try {
                    await productItem.toggleFavorite(productItem.id,
                        auth.getToken ?? '', auth.getUserId ?? '');
                  } catch (errorOrException) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorOrException.toString()),
                      ),
                    );
                  }
                },
                icon: Icon(productItem.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            title: Text(
              productItem.name,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(productItem);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                //para esconder o snackbar anterior
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Produto adicionado com sucesso!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () =>
                          cart.undoAdd(productJustAdded: productItem),
                    ),
                  ),
                );

                print('retirou o just added ${productItem.id}');
              },
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).secondaryHeaderColor,
            ),
          )),
    );
  }
}
