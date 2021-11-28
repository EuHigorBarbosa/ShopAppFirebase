import 'package:flutter/material.dart';
//import 'package:shop/models/product.dart';
import 'package:shop/providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({
    Key? key,
  }) : super(key: key);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Exemplo Contador'),
        ),
        body: Column(
          children: [
            Text(CounterProvider.of(context)?.state.value.toString() ?? '0'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  CounterProvider.of(context)?.state.inc();
                });
                print(CounterProvider.of(context)?.state.value);
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  CounterProvider.of(context)?.state.dec();
                });
                print(CounterProvider.of(context)?.state.value);
              },
            )
          ],
        ));
  }
}
