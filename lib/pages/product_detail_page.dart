import 'package:flutter/material.dart';
import 'package:shop/components/components.dart';
import 'package:shop/models/product.dart';
import 'package:flutter/scheduler.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product productReceived =
        ModalRoute.of(context)!.settings.arguments as Product;
    print('Essa é a tag: ${productReceived.id}');
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(productReceived.name),
      //),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(productReceived.name),
              background: Stack(fit: StackFit.expand, children: [
                Hero(
                  tag: productReceived.id,
                  child:
                      Image.network(productReceived.imageUrl, fit: BoxFit.fill),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0, 0.8),
                      end: Alignment(0, 0),
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.6),
                        Color.fromRGBO(0, 0, 0, 0),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                'R\$ ${productReceived.price}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  productReceived.description,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 1000),
              Text('fim'),
            ]),
          )
        ], //é uma área que pode ser rolavel
      ),
    );
  }
}
