import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/components.dart';
import 'package:shop/components/order_widget.dart';
import 'package:shop/models/models.dart';

class OrdersPage extends StatelessWidget {
  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<OrderList>(context, listen: false)
  //       .loadOrdersFromFirebase()
  //       .then((_) => setState(() => _isLoading = false));
  //!Explicando a realação entre FireBase e os dados Nativos
  //O FireBase é a fonte dos dados e o destino final dos dados.
  //As classes que são changeNotifier distribuem todas as informações por
  //meio de seus getters e setteers. Seus notifyListeners() fazem todos os
  //consumers ouvirem instantaneamente. O BD só é alterado quando necessário.

  //Não há uma conexão direta entre o BD e o usuario. O aplicativo usa os dados do aplicativo
  //O BD é usado quando convém. Os dois são mantidos. Os dados do Aplicativo são para
  //comunicação de espalhar dados e o BD são dados para persistir.
  Future<void> _refreshOrders(BuildContext context) {
    //Essa função será chamada quando o scroll for refreshado - olhe o parametro onREfresh:
    return Provider.of<OrderList>(context, listen: false)
        .loadOrdersFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false)
            .loadOrdersFromFirebase(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Enquanto espera retorna o Center
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              color: Colors.green,
            ));
          } else {
            //ainda tem o ConnectionState.none e . active e o .done que não usei
            //Se eu colocar qualquer outro aqui como condição para o else da erro.
            return RefreshIndicator(
              backgroundColor: Colors.blue,
              color: Colors.white,
              strokeWidth: 4,
              onRefresh: () => _refreshOrders(
                  context), //Quando for chamada vai carregar a lista com a função LoadP....
              child: Consumer<OrderList>(
                builder: (ctx, orders, childRemainImutable) => ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) {
                    print(
                        'Os produtos a serem colocados no order tem o valor ${orders.items[i].total}');
                    return OrderWidget(
                      order: orders.items[i],
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
    // body: _isLoading
    //     ? Center(child: CircularProgressIndicator())
    //     : ListView.builder(
    //         itemCount: orders.itemsCount,
    //         itemBuilder: (ctx, i) {
    //           print(
    //               'Os produtos a serem colocados no order tem o valor ${orders.items[i].total}');
    //           return OrderWidget(
    //             order: orders.items[i],
    //           );
    //         },
    //       ),
  }
}
