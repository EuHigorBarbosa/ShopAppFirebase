import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/components.dart';
import 'package:shop/models/product_list_observable.dart';
import 'package:shop/utils/utils.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) {
    //Essa função será chamada quando o scroll for refreshado - olhe o parametro onREfresh:
    return Provider.of<ProductListObservable>(context, listen: false)
        .loadProductsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final ProductListObservable products =
        Provider.of<ProductListObservable>(context);
    print('O builder que inicia a listview que tem o REfreshIndicator iniciou');
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCT_FORM,
              );
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        backgroundColor: Colors.blue,
        color: Colors.white,
        strokeWidth: 4,
        onRefresh: () => _refreshProducts(
            context), //Quando for chamada vai carregar a lista com a função LoadP....
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (ctx, i) => Column(
              children: [
                ProductItem(productItem: products.itemsObservables[i]),
                Divider(),
              ],
            ),
            itemCount: products.itemsCount,
          ),
        ),
      ),
    );
  }
}
