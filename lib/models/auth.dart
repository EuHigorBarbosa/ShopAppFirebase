import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/exceptions/exceptions.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/data/data.dart';

//Link da documentação: https://firebase.google.com/docs/reference/rest/auth
class Auth with ChangeNotifier {
//Para que as informações dessa classe seja providas a todas as paginas
//é necessário que eu registre o ChangeNotifierProvider lá no MultiProvider do Main
//Aí sim será possivel acessar os dados por meio do contexto

  String? _token; //token do usuario
  String? _email; //e-mail do usuario
  String? _userId; //usuario ID
  DateTime? _expiryDate; //Data de expiração do token
  Timer? _logoutTimer;

  bool get isAuth {
    //A data de expiração do token está válido? (é depois de agora?)
    final isValidTokenDate = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValidTokenDate;
    //Se existir um token e ele for válido então OK OK OK
  }

  String? get getToken {
    //O token só será retornado se o usuario estiver autenticado
    return isAuth ? _token : null;
  }

  String? get getEmail {
    //O email só será retornado se o usuario estiver autenticado
    return isAuth ? _email : null;
  }

  String? get getUserId {
    //O id do usuario só será fornecido se o usuario estiver autenticado
    return isAuth ? _userId : null;
  }

  //definindo a url endpoint que será usada para fazer o SingUp(Registro)
  static const _urlSignIn =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=';

  static const _urlSignUp =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
  //Proximo passo é obter a chave de API da Web lá nas config do projeto Firebase
  static const _apeWebKey = 'AIzaSyBnKZN2wy1tVNVtDa0ROha6aF5-E4rBLwQ';

//==========================  SIGN UP (CADASTRO)  ========================
  //Para eu conseguir fazer esse metodo ser acessado lá no _submit do auth_form eu vou
  //acessar o provider
  Future<void> signUp(
      String emailReceivedFromForm, String passwordReceivedFromForm) async {
    print('A função SING UP foi acionada');
    print(Uri.parse(_urlSignUp + _apeWebKey));
    //!higorgustavo@gmail.com
    final response = await post(
      Uri.parse(_urlSignUp + _apeWebKey),
      body: jsonEncode(
        {
          "email": emailReceivedFromForm,
          "password": passwordReceivedFromForm,
          "returnSecureToken":
              true //essa sempre será true, não é algo que eu passo pra ele
        },
      ),
    );
    final body = jsonDecode(response.body);
    if (body['error'] != null) {
      print('Foi detectado um erro do tipo: ${body['error']['message']}');
      throw AuthException(body['error']['message']);
      //Isso lança a exception...trava o debugin...não trata nada
      //PRESTA ATENÇÃO: essa função lança uma exceção e para eu dar
      //um catch nela eu preciso envolver essa função com um try.
      //Vou fazer isso lá onde ela é chamada no auth_form -
      //dentro de  Future<void> _submit() async {
    } else {
      //Autentiquei e não tenho erro. Quero salvar os dados.
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );
      print('Email recebido para cadastro: $emailReceivedFromForm');
      print('senha recebido para cadastro: $passwordReceivedFromForm');
      print('Esse é o body passado: ${response.toString()}');

      Store.saveMapIntoSharedPreferences('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!
            .toIso8601String(), //posso garantir pois acabei de criar a data
      });

      _autoLogout();
      //a partir da entrada do usuario o seu token começa a expirar seu tempo válido
      // e caso esteja totalmente expirado está função faz o logout automaticamente

      notifyListeners();
    }
  }

//
//==========================  LOGIN  (JA CADASTROU)  ========================
  //Para eu conseguir fazer esse metodo ser acessado lá no _submit do auth_form eu vou
  //acessar o provider
  Future<void> login(
      String emailReceivedFromForm, String passwordReceivedFromForm) async {
    print('A função LOGIN foi acionada');

    //!higorgustavo@gmail.com

    final response = await post(
      Uri.parse(_urlSignIn + _apeWebKey),
      body: jsonEncode(
        {
          "email": emailReceivedFromForm,
          "password": passwordReceivedFromForm,
          "returnSecureToken":
              true //essa sempre será true, não é algo que eu passo pra ele
        },
      ),
    );
    //Toda vez que eu faço um post com email, senha e token:true eu recebo um conjunto de
    //dados com 5 que posso gravar eles pra tomar decisões. No resto do codigo abaixo eu só
    //não utilizo o refreshToken, as outras 4 eu gravo.
    final body = jsonDecode(response.body);
    if (body['error'] != null) {
      print('Foi detectado um erro do tipo: ${body['error']['message']}');
      throw AuthException(body['error']['message']);
      //Isso lança a exception...trava o debugin...não trata nada
      //PRESTA ATENÇÃO: essa função lança uma exceção e para eu dar
      //um catch nela eu preciso envolver essa função com um try.
      //Vou fazer isso lá onde ela é chamada no auth_form -
      //dentro de  Future<void> _submit() async {
    } else {
      //Autentiquei e não tenho erro. Quero salvar os dados.
      //Esses dados serão os dados persistidos dentro do meu celular.
      //vou utilizar para isso o metodo store.saveMap
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(body['expiresIn']),
      ));

      ///Aqui eu salvei os dados em forma de MAP no SharedPreferences
      Store.saveMapIntoSharedPreferences('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!
            .toIso8601String(), //posso garantir pois acabei de criar a data
      });
      //? Depois de salvar esses dados eu vou recuperá-los por meio do getMapFromSheredPreferences
      //? para recuperar eu vou utilizar a chave

      _autoLogout();
      //a partir da entrada do usuario o seu token começa a expirar seu tempo válido
      // e caso esteja totalmente expirado está função faz o logout automaticamente
      notifyListeners();
    }
  }

  ///Esse método tenta fazer o login automaticamente. Ele conseguirá caso os dados estiverem
  ///disponíveis no celular e a duração do token estiver válida. Caso ele não conseguir
  ///fazer o login automatico, então o usuario será redirecionado automaticamente para a
  ///tela de login normal.
  Future<void> tryAutoLogin() async {
    if (isAuth)
      return; //Se eu já estiver autenticado eu não vou precisar recuperar os dados no SPreferences

    final userData = await Store.getMapFromSheredPreferences('userData');
    //Aqui estou pegando o Map de dados utilizando a key 'userData'

    if (userData.isEmpty) return;
    //Se tiver sem dados retorna vazio.

    final expiryDate = DateTime.parse(userData['expiryDate']);
    //trata o dado de time

    if (expiryDate.isBefore(DateTime.now())) return;
    // se a data estiver expirada, retorna vazio e não pega os dados

    //! somente se passar por todos essas verificações é que eu pego os dados
    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    //dados recuperados e

    _autoLogout();
    //Verifica se o token ainda está valido

    notifyListeners();
  }

  ///Essa função é utilizada dentro de autoLogout para limpar os dados e sair corretamente.
  void logoutFunction() {
    print('logoutFuncion foi chamada at time:  ${DateTime.now()}');
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    _clearLogoutTimer();
    //da um clear pra não ficar mais de um timer rodando ao mesmo tempo eventualmente

    Store.remove('userData').then((_) => notifyListeners());
    //Quando o usuario sai é necessário o token seja finalizado
    //Essa informação só será notificada aos listeners quando
    //o future do remove retornar de forma bem sucedida.
  }

  /// Essa função serve só para zerar a variavel que vai receber o
  /// tempo restante para a expiração do token
  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  /// Essa função é responsável por fazer o logout quando o token expirar.
  /// Ela funciona como um teste. Toda vez que ela aparece no código quer
  /// dizer que se está fazendo um teste pra decidir se haverá logout por
  /// token expirado ou se vai continuar logado.
  void _autoLogout() {
    //print('AutoLogout  foi iniciada at time:  ${DateTime.now()}');

    _clearLogoutTimer();
    //Antes de inicializar o timer eu vou limpar o timer

    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    //print('o tempo para o token expirar é de: $timeToLogout');

    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logoutFunction);
    //print('AutoLogout  foi Finalizada at time:  ${DateTime.now()}');
  }
}
