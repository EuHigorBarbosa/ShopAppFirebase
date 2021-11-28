import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/components.dart';
import 'package:shop/models/models.dart';

class ProductGrid extends StatelessWidget {
  final bool showFAvoriteOnly;

  ProductGrid({required this.showFAvoriteOnly});

  @override
  Widget build(BuildContext context) {
    final ponteDeDados = Provider.of<ProductListObservable>(context);
    //Esse ponte de Dados aí é a representação de uma instancia do tipo ProductListObservables
    //por ser uma instancia, tem acesso ao get daquela instancia que diz quem são os itensObservables
    List<Product> loadedProducts = []; //Receberá os dados logo abaixo

    if (showFAvoriteOnly == false) {
      loadedProducts = ponteDeDados.itemsObservables;
    } else {
      loadedProducts = ponteDeDados.favoriteItems;
    }
    print(
        'Esse é o valor do loadedProducts que vai ser usado no grid: ${loadedProducts}');
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider<Product>.value(
        //!Aula 231 para saber sobre esse .value aí!!!!
        value: loadedProducts[i],

        //?create: (_) => loadedProducts[i],    esta construção não é
        //?aconselhavel pois não há a construção do objeto que é CN. Aqui há o uso de
        //?um valor de um objeto já instanciado em final List<Product> loadedProducts =....
        //?itemBuilder: (ctx, i) => ChangeNotifierProvider<Product>(
        //?create: (_) => loadedProducts[i],
        //O GridView constroi itens
        //O item que o gridView construiu foi wrapped com o CNProvider. Agora eu vou poder usar dado
        //provido pelo CNProvider em qualquer de seus filhos e netos. E toda a árvore a partir dele será
        //renderizada quando o dado por ele observado se modificar nos pontos que há um notifyListen();
        //esse loadProducts[i]<Product> vai estar disponivel em qualquer elemento da arvore de componentes
        child: ProductGridItem(),
        //la dentro do ProductItem(), no build, dado provido pelo CNProvider que é do tipo <Product> vai ser
        //acessado vai estar disponível. Quando os notifyListeners() forem acionados haverá uma modificação
        //em todos os dados providos pelo CNProvider. E o CNProvider vai renderizar todos os seus filhos e netos
        //Essa renderização levará em conta os dados modificados providos pelo CNProvider.
      ),
      //sliver = uma area que pode ser rolável.
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
