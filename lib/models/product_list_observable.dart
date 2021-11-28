import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/models.dart';
import 'package:shop/utils/utils.dart';

///?Essa classe foi criada para ser uma Provider(provedora de informações)
///?As outras classes são notificadas com os daddos dessa classe(por meio dos NotifyListeners)

class ProductListObservable with ChangeNotifier {
  List<Product> _itemsObservables = []; //dummyProducts;
  final String _token;
  final String
      _userIdFromFireBase; //colocado aqui especificamente para ser possível fazer o get da coleção do isFavorite que depende do userId

  ProductListObservable(
      [this._token = '',
      this._itemsObservables = const [],
      this._userIdFromFireBase = '']);

  ///* ===== História desse contrutor parametrizado =====
  ///* Antes o construtor não era parametrizado, era do tipo standard.
  ///* Agora ele foi transformado num construtor parametrizado porque este construtor será
  ///* utilizado para criar a lista de produtos pelo ProxyProvider create.
  ///* O create do proxyProvider usa o parametro previous para carregar a ultima
  ///* lista de produtos carregada anteriormente. Esse contrutor também é inicializado
  ///* com o parametro _token que alimenta a função loadProductsFromFirebase
  ///* =====================================================================
  //antes esses _itemsObservables eram carregados pelo dammyProducts.
  //Agora eles são carregados pelo initState() do overviewPage

  //como é privada list temos que ter um get
  //esses ... é pra fazer uma copia dos dados originais.
  //De acordo com o valor de _showFavoriteOnly eu vou ter como dados
  //os favoritados ou não favoritados.
  List<Product> get itemsObservables => [..._itemsObservables];

  List<Product> get favoriteItems =>
      _itemsObservables.where((prod) => prod.isFavorite).toList();
//?=========================================================================
  int get itemsCount {
    return _itemsObservables.length;
  }

//?=========================================================================

//?===================== ***  LOAD-PRODUCTS  ***  =========================================
  Future<void> loadProductsFromFirebase() async {
    _itemsObservables.clear();

    //O loadProductFrom... será chamado a cada initState da OverviewPage e isso gera
    //imagens repetidas, por isso tem que limpar.
    final response = await http
        .get(Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'));
    //vamos carregar os dados(advindos do FireBase)  por meio dessa função e substituir os
    //dammyProducts acima. Vamos carregar e substituir no initState do overviewPage.
    final responseForFavorite = await http.get(
      Uri.parse(
          '${Constants.USER_FAVORITES_URL}/$_userIdFromFireBase.json?auth=$_token'),
      //o id não envia pois estou aqui adicionando um novo produto
      //converte para json
    );

    //* ======== testes para saber se a resposta retorna null ou vazio ========
    if (response.body == 'null') //!Se eu colocar null sem as aspas da erro
      return; //Se não tem nada no banco de dados, então retorna sem carregar nada. Aí fica valendo o [] lá na delacração de _itemsObservables

    Map<String, dynamic> favData = responseForFavorite.body == 'null'
        ? {}
        : jsonDecode(responseForFavorite.body);

    //* ===================================================================
//!higorgustavo@gmail.com  qqqqqq
    Map<String, dynamic> data = jsonDecode(response.body);
    print('Esse é o conteúdo do response.body: ${response.body}');
    _itemsObservables = [];
    data.forEach((productId, productData) {
      final isFavoriteFromFirebase = favData[productId] ?? false;
      // print(
      //     'Esse é o valor inserido em cada $productId no isFavorite: ${favData[_userIdFromFireBase][productId]}');

      _itemsObservables.add(
        //cria o _itemsObservables que será usado lá no body do productOverviewPage quando ele chamar o ProductGrid
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: double.parse('${productData['price']}'),
          imageUrl: productData['imageUrl'],
          //? isFavorite: productData['isFavorite'], //Não é necessário mais coletar o isFavorite
          //? nesta coleção products pois a marcação de favorito será
          //? feita em outra coleção do banco de dados.
          isFavorite: isFavoriteFromFirebase,
        ),
      );
    });
    print(
        'quando o notifyListeners for chaamado o valor de _itemsObservables é: $_itemsObservables');
    notifyListeners(); //Sem esse notifyListeners o _itemObservables é iniciado normalmente como []
  }

//?=========================================================================
  Future<void> saveProductFromDataForm(Map<String, Object> dataFromForm) {
    print('\n Metodo SAveProductDataForm foi acionado');

    bool hasId = dataFromForm['id'] != null;
    // ============ Variáveis a serem salvas =================
    print('\n Valores Transferidos a serem salvos');
    print('name: ${dataFromForm['name']}');
    print('price: ${dataFromForm['price']}');

    print('description: ${dataFromForm['description']}');

    print('imageUrl: ${dataFromForm['imageUrl']}');
    // ============ Variáveis a serem salvas =================

    //Verifica se não tem id. Se não tiver id então cria um id com o
    //random e add normalmente.
    //Se tiver um id então tem que verificar se é o caso de se fazer um
    //update (pois se o id já existir então tem que fazer o update dos dados)
    //ou se é o caso de só add mesmo

    final newProduct = Product(
      id: hasId
          ? dataFromForm['id'].toString()
          : Random().nextDouble().toString(),
      name: dataFromForm['name'].toString(),
      description: dataFromForm['description'].toString(),
      price: double.parse(dataFromForm['price'].toString()),
      imageUrl: dataFromForm['imageUrl'].toString(),
    );

    if (hasId) {
      //chama metodo que faz o update do id
      return updateIdOnProduct(newProduct);
    } else {
      //chama metodo que add o produto já com o id
      return addProduct(newProduct);
    }
  }

//?=========================================================================
  Future<void> updateIdOnProduct(Product productToUpdateOrAdd) async {
    int indexToKnowWherePutTheNew = _itemsObservables
        .indexWhere((item) => item.id == productToUpdateOrAdd.id);
    //Se o indexTo... for -1 então o id é novo e o produto deve ser add
    //Se o indexTo.... for >=0 então é o caso de se fazer o update
    //mas com certeza será >= pois se
    if (indexToKnowWherePutTheNew >= 0) {
      await http.patch(
        Uri.parse(
          '${Constants.PRODUCT_BASE_URL}/${productToUpdateOrAdd.id}.json?auth=$_token',
        ),
        body: jsonEncode(
          {
            "name": productToUpdateOrAdd.name,
            "description": productToUpdateOrAdd.description,
            "price": productToUpdateOrAdd.price,
            "imageUrl": productToUpdateOrAdd.imageUrl,
            //a parte de isFavorite não é usada no gerenciamento de produtos
          },
          //o id não envia pois estou aqui adicionando um novo produto
        ), //converte para json
      );

      _itemsObservables[indexToKnowWherePutTheNew] = productToUpdateOrAdd;
      //Se o indexTo...for 2 então o _itemObservables[2] deve ser sobrescrito pelo productToUpdate
      notifyListeners();
      return Future.value();
    } else if (indexToKnowWherePutTheNew == -1) {
      //se
      return addProduct(productToUpdateOrAdd);
    }
    return Future.value();
  }

//?=========================================================================
  Future<void> removeProductFromId(Product productToRemove) async {
    int indexToKnowWherePutTheNew =
        _itemsObservables.indexWhere((item) => item.id == productToRemove.id);
    //Se o indexTo... for -1 então o id é novo e o produto deve ser add
    //Se o indexTo.... for >=0 então é o caso de se fazer o update
    //mas com certeza será >= pois se
    final productRemovedWithoutServerConfirmation =
        _itemsObservables[indexToKnowWherePutTheNew];
    _itemsObservables.remove(productRemovedWithoutServerConfirmation);
    //Se o indexTo...for 2 então o _itemObservables[2] deve ser sobrescrito pelo productToUpdate
    notifyListeners();

    if (indexToKnowWherePutTheNew >= 0) {
      //Aqui eu tive que guardar a respose numa var pois vou utilizá-la
      //para verificar se houve algum problema já que a remoção é otimista: primeiro eu
      //removo da vista do usuário e depois eu removo do banco de dados
      final response = await http.delete(
        Uri.parse(
          '${Constants.PRODUCT_BASE_URL}/${productToRemove.id}.json?auth=$_token',
        ),
      );

      if (response.statusCode >= 400) {
        //o erro da familia dos 400 é um erro do cliente
        _itemsObservables.insert(
            indexToKnowWherePutTheNew, productRemovedWithoutServerConfirmation);
        notifyListeners();
        throw new HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        ); //Essa exceção foi lançada mas não foi tratada aqui. Ela será tratada lá
        //no componente icons.delete - onPressed do productItem
      }
    }
  }

  //?=========================================================================
  //Essa função é do tipo Future e o que ela retorna é um then do future que
  //será respondido. Isso pode ser feito pois o then retorna um future e eu coloquei
  //o generics para ser <void>

  Future<void> addProduct(Product product) {
    //! Não há tratamento de erro
    var urlForAddNewPost = Uri.parse(
      '${Constants.PRODUCT_BASE_URL}.json?auth=$_token',
    );

    final postProduct = http.post(
      urlForAddNewPost,
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          //"isFavorite": product.isFavorite
        },
        //o id não envia pois estou aqui adicionando um novo produto
      ), //converte para json
    );
    return postProduct.then<void>(
      (response) {
        print('Printado depois que a resposta voltar do FireBase');
        print(jsonDecode(response.body));
        //Quando recebemos a resposta nós recebemos um json com string inicial 'name'

        final idReceivedFromFirebase = jsonDecode(response.body)['name'];
        _itemsObservables.add(
          Product(
            name: product.name,
            id: idReceivedFromFirebase,
            price: product.price,
            description: product.description,
            imageUrl: product.imageUrl,
            //isFavorite: product.isFavorite,
          ),
        ); //aqui há o salvamento dos dados em memoria
        notifyListeners();
        //print('Print depois do post sem esperar a resposta');
      },
    );
  }
}

/* //! Essa parte é a solução de filtro de favoritos global. Ela tem uma parte no botão OnSelected do menu
class ProductListObservable with ChangeNotifier {
  List<Product> _itemsObservables = dummyProducts;
  bool _showFavoriteOnly = false;

  //como é privada list temos que ter um get
  //esses ... é pra fazer uma copia dos dados originais.
  //De acordo com o valor de _showFavoriteOnly eu vou ter como dados
  //os favoritados ou não favoritados.
  List<Product> get itemsObservables {
    if (_showFavoriteOnly) {
      return _itemsObservables.where((prod) => prod.isFavorite).toList();
    }
    return [..._itemsObservables];
  }

  void addProduct(Product product) {
    _itemsObservables.add(product);
    notifyListeners();
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }
}
*/
