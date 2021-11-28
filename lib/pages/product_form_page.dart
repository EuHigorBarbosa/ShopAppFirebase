import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/models.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late FocusNode _nameFocus;
  late FocusNode _priceFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _urlFocus;
  final _imageUrlController = TextEditingController();
  //Esse controller foi criado para termos acesso à informação do que o usuario digitou
  //antes de submeter o formulário. Temos acesso a essa informação pelo get _imageUrlController.text.
  //Existem também o set value e o set
  final _formKey = GlobalKey<FormState>();
  //Existe esse negocio de chave glogal e existe esse negocio de tipo FormState
  //utilizando-se essa chave você pode manusear metodos do tipo
  //.currentState.save()
  //.currentWidget
  //.currentContext
  bool _isLoadingResponseFromNet = false;
//vou controlar a barra de espera por esta variavel. Se ela for true e iniciei a espera
//e quando a responsta chegar eu utilizo o then para fazer ela retornar para false e acabar
//com a espera.
  var _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _nameFocus = FocusNode();
    _priceFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _urlFocus = FocusNode();
    _urlFocus.addListener(updateImage);
    print('INIT STATE INICIADO');
    //adicionei ouvinte para poder carregar a imagem apos o setfocus sair da caixa
    //de texto da url.
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _nameFocus.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();

    _urlFocus.removeListener(updateImage);
    _urlFocus.dispose();

    super.dispose();
  }

  void _clearAllTextFiels() {
    _formKey.currentState?.reset();
    print('REset de todos os campos');
    _imageUrlController.clear();
    setState(() {}); //para haver o update da imagem
    FocusScope.of(context).requestFocus(_nameFocus);
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile =
        true; /*url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('image=9');*/
    print('Retorno da validação do url = ${isValidUrl && endsWithFile}');
    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    //Essa função _submitForm era void. Mas fizemos ela ser Future pois só queremos sair
    //do formulário quando recebermos a resposta do FireBase.
    print('O método on Submit foi acionado\n');

    final isValid = _formKey.currentState?.validate() ?? true;
    print('CONSIDERADO DADO VALIDO = isValid = $isValid');

    if (isValid) {
      _formKey.currentState?.save();

      //o currentState pode não estar disponível, por isso devo utilizar essa ?
      //Quando dou um save nessa globalKey eu estou dando um save no meu Form - mais
      //precisamente na parte do FormState.
      //Quando uso o metodo .save eu estou dizendo:  Saves every [FormField] that is a descendant of this [Form].

      //========Variaveis que foram salvas:
      // print('o valor das variáveis a serem salvas são:');
      // print('name: ${_formData['name']}');
      // print('price: ${_formData['price']}');

      // print('description: ${_formData['description']}');

      // print('imageUrl: ${_formData['imageUrl']}');
      //=============================================

      //Antes de iniciar a requisição Future eu coloco o isLoadingResponseFromNet como true
      setState(() => (_isLoadingResponseFromNet = true));
      try {
        await Provider.of<ProductListObservable>(
          context,
          listen: false,
        ).saveProductFromDataForm(_formData);
        //Se ocorrer um erro aqui ele não vai mudar de tela. Só muda de tela
        //se o salvamento ocorrer sem erro.
        Navigator.of(context).pop();
      } catch (error) {
        //e aqui entre a requisição Future e o then a gente trata o erro
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
                'Ocorreu um erro! Contacte nosso suporte e informe esse erro!'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } finally {
        //executa mesmo com erro ou sem erro
        setState(() => (_isLoadingResponseFromNet = false));
        print('Antes de carregar a tela');
      }
      //só vai sair do form quando o then do future save for respondido.

      ///Quando chamamos o provider fora do metodo build (por meio de uma função de onPreessed
      ///por exemplo) o sistema do provider não vai ser notificado a cada
      ///modificação. Ele será notificado somente no evento associado(como o pressionar
      ///do botão). Por isso o listen deve obrigatoriamente ser false.

    }
  }

  void updateImage() {
    //Ele simplesmente quer que o setState seja atualizado para que o
    //ImageNetwork carregue a url do TExtFild.

    //Ele vai carregar de acordo com um evento que é a mudança de foco.
    //O listener foi adicionado no _urlFocus. Toda vez que houver uma variação
    //no estado do _urlFocus então um setState irá ser executado por meio do
    //_urlFocus.listener(updateImage)

    setState(() {}); //Um setState vazio já é suficiente
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('DID CHANGE DEPENDENCIES INICIADO');
    print('O valor de _formData.isEmpty é ${_formData.isEmpty}');

    if (_formData.isEmpty) {
      final productReceived = ModalRoute.of(context)?.settings.arguments;

      print(
          'O valor de productReceived  é null? =>: ${productReceived == null}');

      if (productReceived != null) {
        final product = productReceived as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
      // (_formData['name'] == null)
      //     ? print('null para nome')
      //     : print('${_formData['name'].toString()}');
      // (_formData['price'] == null)
      //     ? print('null para price')
      //     : print('${_formData['price'].toString()}');
      // (_formData['description'] == null)
      //     ? print('null para description')
      //     : print('${_formData['description'].toString()}');
      // (_formData['imageUrl'] == null)
      //     ? print('null para imageUrl')
      //     : print('${_formData['imageUrl'].toString()}');
      // (_formData['id'] == null)
      //     ? print('null para id')
      //     : print('${_formData['id'].toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('O Form chegou a ser buildado');
    print('O produto clicado tem o nome de : ${_formData['name'].toString()}');
    print(
        'O produto clicado tem o price de : ${_formData['price'].toString()}');
    print(
        'O produto clicado tem o description de : ${_formData['description'].toString()}');
    print(
        'O produto clicado tem o imageUrl de : ${_formData['imageUrl'].toString()}');
    print('O produto clicado tem o id de : ${_formData['id'].toString()}');

    // print('O produto clicado tem o price de : ${productReceived.price}');

    // print(
    //     'O produto clicado tem o description de : ${productReceived.description}');

    // print('O produto clicado tem o imageUrl de : ${productReceived.imageUrl}');

    // print('Teste de casting para string');

    //Inicializando os campos do formulario quando o usuario aperta edit
    // *** Campos Name, price e description

    // *** Campo imageUrl */

    //é necessário salvar no _formData o id recebido pelo botão edit
    //pois quando o usuario for salvar um product vindo do edit, o sistema vai
    //precisar do id para não duplicar o produto na lista mas sim editá-lo

    // print('Construindo widget inicial build');
    // print(
    //     'tipo: ${_formDataInicial['name'].toString()} e valor: ${_formDataInicial['name']}\n');
    // print(
    //     'tipo: ${_formDataInicial['price'].toString()} e valor: ${_formDataInicial['price']}\n');
    // print(
    //     'tipo: ${_formDataInicial['description'].toString()} e valor: ${_formDataInicial['description']}\n');
    // print(
    //     'tipo: ${_formDataInicial['imageUrl'].toString()} e valor: ${_formDataInicial['imageUrl']}\n');

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_left),
        ),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoadingResponseFromNet
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    //Text('https://picsum.photos/250?image=9'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //!===============================================
                      child: TextFormField(
                        initialValue: (_formData['name'] == null)
                            ? ''
                            : _formData['name'].toString(),
                        focusNode: _nameFocus,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          errorBorder: new OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.orange,
                              width: 2.1,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        onSaved: (name) {
                          print('O name do formulário para ser salvo é: $name');
                          if (name != null) {
                            _formData['name'] = name;
                          } else {
                            _formData['name'] = '';
                          }
                        },
                        validator: (_name) {
                          print('iniciada a validação do name');
                          final name = _name ?? '';
                          //aqui eu garanto que não receberei uma string nula
                          if (name.trim().isEmpty) {
                            return ' O nome não foi digitado. Ele é obrigatório.';
                          }

                          if (name.trim().length < 3) {
                            return 'Nome é obrigatório';
                          }
                          print('Name passou no teste de validação');
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        //!===============================================
                        initialValue: (_formData['price'] == null)
                            ? ''
                            : _formData['price'].toString(),
                        focusNode: _priceFocus,
                        decoration: InputDecoration(labelText: 'Preço'),
                        textInputAction: TextInputAction.next,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        onSaved: (price) {
                          print(
                              'O price do formulário para ser salvo é: $price');

                          if (price != null) {
                            _formData['price'] = price;
                          } else {
                            _formData['price'] = '';
                          }
                        },
                        validator: (_price) {
                          print('iniciada a validação do price');

                          final price = _price ?? '';
                          //aqui eu garanto que não receberei uma string nula
                          if (price.trim().isEmpty || price == '') {
                            return ' O valor não foi digitado. Ele é obrigatório.';
                          }

                          if (double.tryParse(price.trim()) == null) {
                            return 'O que foi digitado não é um número válido';
                          }

                          if (double.tryParse(price.trim()) != null &&
                              double.tryParse(price.trim())! <= 0.0) {
                            return 'Digite um número MAIOR que zero';
                          }
                          //falta validação de não colocar letras
                          print('price passou no teste de validação');
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        //!===============================================
                        initialValue: (_formData['description'] == null)
                            ? ''
                            : _formData['description'].toString(),

                        focusNode: _descriptionFocus,
                        decoration: InputDecoration(labelText: 'Descrição'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_urlFocus);
                        },
                        onSaved: (description) {
                          print(
                              'O description do formulário para ser salvo é: $description');
                          if (description != null) {
                            _formData['description'] = description;
                          } else {
                            _formData['description'] = '';
                          }
                        },
                        validator: (_description) {
                          print('iniciada a validação do Description');

                          final description = _description ?? '';
                          //aqui eu garanto que não receberei uma string nula
                          if (description.trim().isEmpty) {
                            return ' A descrição não foi digitada. Ela é obrigatória.';
                          }

                          if (description.trim().length < 3) {
                            return 'Descrição é obrigatório';
                          }
                          print('description passou no teste de validação');

                          return null;
                        },
                      ),
                    ),
                    // FittedBox(
                    //   child: Image.network(
                    //     'https://picsum.photos/250?image=9',
                    //     height: 100,
                    //     width: 100,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                  //!===============================================
                                  //initialValue: _imageUrlController.text,
                                  focusNode: _urlFocus,
                                  decoration: InputDecoration(
                                    labelText: 'URL da imagem',
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        _imageUrlController.clear();
                                        setState(() {});
                                        FocusScope.of(context)
                                            .requestFocus(_nameFocus);
                                      },
                                    ),
                                  ),
                                  textInputAction: TextInputAction
                                      .done, //aqui vai haver a submissão do formulario
                                  keyboardType: TextInputType.url,
                                  controller: _imageUrlController,
                                  onFieldSubmitted: (_) => _submitForm(),
                                  //Esse underline aí é pra indicar que eu preciso do parametro para
                                  //fazer minha assinatura de função ficar ok. Mas eu não usaria esse
                                  //parametro internamente...é só uma opção, daria na mesma se eu colocasse
                                  //um nome de argumento como foo mas eu poderia, ao ler, não pegar a ideia
                                  //especifica desse uso nessa ocasião especifica
                                  onSaved: (url) {
                                    print(
                                        'O url do formulário para ser salvo é: $url');
                                    if (url != null) {
                                      _formData['imageUrl'] = url;
                                    } else {
                                      _formData['imageUrl'] = '';
                                    }
                                  },
                                  validator: (_imageUrl) {
                                    print('iniciada a validação do _imageUrl');

                                    final imageUrl = _imageUrl ?? '';
                                    if (!isValidImageUrl(imageUrl)) {
                                      return 'Informe url válida';
                                    }
                                    print('url passou no teste de validação');
                                    return null;
                                  }),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                //width: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                //alignment: Alignment.center,
                                child: SizedBox.expand(
                                  child: FittedBox(
                                    fit: ((_imageUrlController.text.isEmpty) ||
                                            (!_imageUrlController
                                                    .text.isEmpty &&
                                                !isValidImageUrl(
                                                    _imageUrlController.text)))
                                        ? BoxFit.contain
                                        : BoxFit.fill,
                                    child: ((_imageUrlController
                                                .text.isEmpty) ||
                                            (!_imageUrlController
                                                    .text.isEmpty &&
                                                !isValidImageUrl(
                                                    _imageUrlController.text)))
                                        ? Text(
                                            'Informe a Url\n\nToque para carregar\na imagem')
                                        : Image.network(
                                            _imageUrlController.text,
                                            //fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text('Salvar'),
                          onPressed: _submitForm, //_submitForm(),
                        ),
                        TextButton(
                          child: Text('Limpe todos os campos'),
                          onPressed: () => _clearAllTextFiels.call(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
