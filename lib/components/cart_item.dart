import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/models.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      onDismissed: (_) {
        cart.removeItem(cartItem.producId);
      },
      confirmDismiss: (_) {
        //retorna um Future do tipo bool
        return showDialog<bool>(
            context: context,
            barrierLabel: 'Barrier Label dismissifier',
            // aboutDialog
            // simpleDialog
            // simpleDialogoption
            builder: (ctx) => AlertDialog(
                  title: Text('Tem Certeza'),
                  content: Text('Quer remover o item do carrinho'),
                  actions: [
                    TextButton(
                      child: Text('Sim'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                        //é o pop que vai retornar o bool
                      },
                    ),
                    TextButton(
                      child: Text('Não'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    )
                  ],
                ));
      },
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: InkWell(
                onTap: () {
                  Provider.of<Cart>(context).clear();
                },
                child: CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: FittedBox(
                      child: Text('${cartItem.price}'),
                    ),
                  ),
                ),
              ),
              title: Text('${cartItem.name}'),
              trailing: Text('${cartItem.quantity}x'),
              subtitle: Text(
                  'O valor total desse item é: R\$ ${double.parse((cartItem.quantity * cartItem.price).toStringAsFixed(2))}'),
            ),
          )),
    );
  }
}
