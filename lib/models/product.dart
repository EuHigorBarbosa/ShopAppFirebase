import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'dart:convert';

import 'package:shop/utils/utils.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite; //esse é o único atributo que vai ser modificado (aula 310).
  //Eu coloquei o mixin changeNotifier aqui para que eu consiga notificar
  //os meus listeners quando ele for modificado.

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite(
      String productId, String token, String userId) async {
    //Alteração otimista - primeiro no productItem
    isFavorite = !isFavorite;
    notifyListeners();
    print(
        'Este é o endereço: Uri.parse ${Constants.PRODUCT_BASE_URL}/$userId/$productId.json?auth=$token');
    //Aqui eu tive que guardar a respose numa var pois vou utilizá-la
    //para verificar se houve algum problema já que a remoção é otimista: primeiro eu
    //removo da vista do usuário e depois eu removo do banco de dados
    final response = await http.put(
      Uri.parse(
          '${Constants.USER_FAVORITES_URL}/$userId/$productId.json?auth=$token'),
      body: jsonEncode(
          isFavorite), //o id não envia pois estou aqui adicionando um novo produto
      //converte para json
    );

    if (response.statusCode >= 400) {
      //o erro da familia dos 400 é um erro do cliente
      isFavorite = !isFavorite;
      notifyListeners();
      throw new HttpException(
        msg: 'Não foi possível favoritar o produto.',
        statusCode: response.statusCode,
      ); //Essa exceção foi lançada mas não foi tratada aqui. Ela será tratada lá
      //no componente icons.delete - onPressed do productItem
    }
  }

//?=========================================================================

}
