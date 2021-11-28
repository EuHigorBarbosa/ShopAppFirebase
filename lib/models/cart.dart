import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/models/models.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  int get itemsNumber {
    int total = 0;
    _items.forEach((key, cartItemOfTotalList) {
      total += cartItemOfTotalList.quantity;
    });
    return total;
  }

  void addItem(Product productAdded) {
    if (_items.containsKey(productAdded.id)) {
      _items.update(
        productAdded.id,
        (preExistingItem) => CartItem(
            id: preExistingItem.id,
            producId: preExistingItem.producId,
            name: preExistingItem.name,
            quantity: preExistingItem.quantity + 1,
            price: preExistingItem.price),
      );
    } else {
      _items.putIfAbsent(
        productAdded.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          producId: productAdded.id,
          name: productAdded.name,
          quantity: 1,
          price: productAdded.price,
        ),
      );
    }
    print('Produto ${productAdded.id} adicionado');
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItemOfTotalList) {
      total += cartItemOfTotalList.price * cartItemOfTotalList.quantity;
      total = double.parse(total.toStringAsFixed(2));
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    print('Remoção do $productId do carrinho');
    notifyListeners();
  }

//atualizar o produto diminuindo a quantidade
  void undoAdd({required Product productJustAdded}) {
    //o nome que o prof deu foi removeSingleItem

    if (_items.containsKey(productJustAdded.id)) {
      _items.update(
        productJustAdded.id,
        (preExistingItem) => CartItem(
            id: preExistingItem.id,
            producId: preExistingItem.producId,
            name: preExistingItem.name,
            quantity: preExistingItem.quantity - 1,
            price: preExistingItem.price),
      );
      notifyListeners();
    } else {
      _items.remove(productJustAdded.id);
    }
    print('Produto ${productJustAdded.id} removido');
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
