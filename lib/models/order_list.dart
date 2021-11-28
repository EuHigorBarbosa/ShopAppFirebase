import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/models.dart';
import 'package:shop/utils/utils.dart';

class OrderList with ChangeNotifier {
  final String _token;
  List<Order> _itemsOnListOrders = [];
  String _idUserOrder;

  OrderList(
      [this._token = '',
      this._itemsOnListOrders = const [],
      this._idUserOrder = '']);

  List<Order> get items {
    return [..._itemsOnListOrders];
  }

  int get itemsCount {
    return _itemsOnListOrders.length;
  }

  //?============================   ADD ORDER    =================================

  Future<void> addOrder(Cart cart) async {
    var _timeOfOrder = DateTime.now();
    //insere-se otimisticamente

    //insere-se no banco de dados criando uma nova arvore
    final urlForAddNewPost = Uri.parse(
        '${Constants.ORDER_BASE_URL}/$_idUserOrder.json?auth=$_token');

    final responsePostOrder = await http.post(
      urlForAddNewPost,
      body: jsonEncode(
        {
          "total": cart.totalAmount,
          "products": cart.items.values
              .map(
                (cartItem) => {
                  "id": cartItem.id,
                  "producId": cartItem.producId,
                  "name": cartItem.name,
                  "quantity": cartItem.quantity,
                  "price": cartItem.price,
                },
              )
              .toList(),
          "date": _timeOfOrder.toIso8601String(),

          /*class CartItem {
              final String id;
              final String producId;
              final String name;
              final int quantity;
              final double price;
          
          class Order {
            final String id;
            final double total;
            final List<CartItem> products;
            final DateTime date;*/
        },

        //o id não envia pois estou aqui adicionando um novo produto
      ),
      //converte para json
    );

    final idFromFireBase = jsonDecode(responsePostOrder.body)['name'];
    _itemsOnListOrders.insert(
      0,
      Order(
        id: idFromFireBase,
        total: cart.totalAmount,
        date: _timeOfOrder,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
    print('Order enviada ao FireBAse e retornou.....');
    _itemsOnListOrders.forEach((item) => print(
        '\${item.total}: ${item.total}..\${item.id}: ${item.id}..\${item.products}: ${item.products}..\${item.date}: ${item.date}..'));
    print(jsonDecode(responsePostOrder.body));

    if (responsePostOrder.statusCode >= 400) {
      //o erro da familia dos 400 é um erro do cliente
      //TODO: Remove order
      print('Remover cart dos cartItems');
      notifyListeners();
      //Lança os exceptions se der errado
      throw new HttpException(
        msg: 'Não foi possível realizar a Order.',
        statusCode: responsePostOrder.statusCode,
      ); //Essa exceção foi lançada mas não foi tratada aqui. Ela será tratada lá
      //no componente icons.delete - onPressed do productItem
      //? exceptions tratados lá no botão que faz a ordem em cart_page

    }
  }

  //?==================   LOAD ORDER  ===========================================
  Future<void> loadOrdersFromFirebase() async {
    print('O LoadProductsFromFireBase chegou a ser iniciado');

    List<Order> itemsOnListOrders =
        []; //Antes esse comando era: _itemsOnListOrders.clear();

    //O loadProductFrom... será chamado a cada initState da OverviewPage e isso gera
    //imagens repetidas, por isso tem que limpar.

    final response = await http.get(Uri.parse(
        '${Constants.ORDER_BASE_URL}/$_idUserOrder.json?auth=$_token'));
    //vamos carregar os dados(advindos do FireBase)  por meio dessa função e substituir os
    //dammyProducts acima. Vamos carregar e substituir no initState do overviewPage.
    if (response.body == 'null') //!Se eu colocar null sem as aspas da erro
      return; //Se não tem nada no banco de dados, então retorna sem carregar nada. Aí fica valendo o [] lá na delacração de _itemsObservables
    Map<String, dynamic> data = jsonDecode(response.body);
    print('Esse é o conteúdo do response.body do ORDER: ${response.body}');
    // print(
    //     'Qual o type do price do lugar zero? ${data[0]['price'].runtimeType}');
    data.forEach((orderId, orderData) {
      itemsOnListOrders.add(
        //cria o _itemsObservables que será usado lá no body do productOverviewPage quando ele chamar o ProductGrid
        Order(
          id: orderId,
          total: double.parse('${orderData['total']}'),
          date: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List<dynamic>).map((itemOfMap) {
            return CartItem(
                id: itemOfMap['id'],
                price: itemOfMap['price'].toDouble(),
                name: itemOfMap['name'],
                producId: itemOfMap['producId'],
                quantity: itemOfMap['quantity']);
          }).toList(),
        ),
      );
      _itemsOnListOrders = itemsOnListOrders.reversed
          .toList(); //fiz isso para os pedidos mais novos ficarem por cima
      notifyListeners(); //Sem esse notifyListeners o _itemObservables é iniciado normalmente como []
    });
  }
}




    // return postProduct.then<void>(
    //   (response) {
    //     print('Printado depois que a resposta voltar do FireBase');
    //     print(jsonDecode(response.body));
    //     //Quando recebemos a resposta nós recebemos um json com string inicial 'name'

    //     final idReceivedFromFirebase = jsonDecode(response.body)['name'];
    //     _itemsObservables.add(
    //       Product(
    //         name: product.name,