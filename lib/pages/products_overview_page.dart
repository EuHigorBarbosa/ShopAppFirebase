import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/components/components.dart';
import 'package:shop/models/models.dart';
import 'package:shop/utils/utils.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductOverviewPage extends StatefulWidget {
  ProductOverviewPage({Key? key, required}) : super(key: key);

  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading =
      true; //para indicar o estado de carregamento para o usuario.
  //Começa true pois o carregamento se inicia no initState do pageOverview

  @override
  void initState() {
    super.initState();
    print(
        'Este é o valor do _isLoading no inicio do processamento: $_isLoading em ${DateTime.now()}');
    //_isLoading = true; //apenas uma redundancia pra garantir.
    Provider.of<ProductListObservable>(context, listen: false)
        .loadProductsFromFirebase();
    setState(() {
      _isLoading = false;
      print(
          'Acabou de iniciar _isLoading: $_isLoading como false em ${DateTime.now()}');
    }); //ao terminar de carregar os dados ele informa ao usuario
  }

  @override
  Widget build(BuildContext context) {
    print('O build do OverviewPage está iniciando');
    print(
        'Esse é o valor dos itemsObservables: ${Provider.of<ProductListObservable>(context, listen: false).itemsObservables}');
    //!final ponteDeDados = Provider.of<ProductListObservable>(context);
    //Eu não estou mais coletando os dados do dammy_data e sim dos
    //itemsObservables que são a lista manipulada pelo subject da
    //classe ProductListObservable. Ele é quem notifica os listeners.
    //Para que eu não reconstrua toda a aplicação eu preciso utilizar
    //os CONSUMERS

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Text(
                "Vintage by Ailene",
                textAlign: TextAlign.center,
                style: (TextStyle(fontSize: 20)),
              ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                (selectedValue == FilterOptions.Favorite)
                    // ignore: unnecessary_statements
                    ? (_showFavoriteOnly = true)
                    : _showFavoriteOnly = false;
              });
            },
            /* //! Essa é parte da filtragem de favoritos da forma global
             onSelected: (FilterOptions selectedValue) {
              
              (selectedValue  == FilterOptions.Favorite)
                  ? ponteDeDados.showFavoriteOnly()
                  : ponteDeDados.showAll();
            },
            */
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.CART_PAGE,
                );
              },
              icon: Icon(Icons.shopping_cart),
            ),
            builder: (ctx, product, childOfConsumer) => Badge(
              value: product.itemsNumber,
              childOfBadge: childOfConsumer!,
            ),
          )
        ],
      ),
      // ================= Esse é o body da minha primeira tela - só isso
      // Se estiver carregando mostra o CircularProgressIndicator, se terminou mostra o grid
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(showFAvoriteOnly: _showFavoriteOnly),
    );
  }
}
