/// 1 - Cria uma variável do tipo AnimationController - ela serve para:
/// 2 - Cria uma variável do tipo Animation _heightAnimation ... que será do tipo de animação que se deseja
/// fazer, se for animar height, então o tipo é Size, se for opacity, então o tipo é double
/// 3 - Dentro do initState eu devo instanciar uma variável criada do tipo AnimationController
/// colocando um parametro que é o Vsync<TickerProvider> dispara uma callback a cada frame e
/// também a duração da animação
///     4 - Para poder preencher esse Vsync com um Ticker temos que usar de um
///     mixin with SingleTickerProviderStateMixin
/// 5 - Ainda no initState eu devo configurar uma animation instanciando a classe Tween(); pra
/// determinar os pontos de inicio e fim e a curva
/// 6 - Liberar o controller instanciado no @override void dispose é necessário.
/// ============= implementação na UI ================
/// 7 - O objeto a ser animado tem o height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
/// 8 - Determina a direção de animação utilizando um metodo do _controller.forward() e _controller.reverse().
/// você pode perceber que  o AnimationController tem alguns gets e sets que ajudam
/// 9 - Depois temos que fazer com que o setState seja um listener da Animation que
/// foi criada...pra isso adicionamos uma callback setState(()={}) neste listener
/// e assim, a cada modificação da animação a callback do listener será acionada

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/exceptions.dart';
import 'package:shop/models/models.dart';
import 'package:shop/utils/utils.dart';

enum AuthMode { SignUp, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

//higorgustavo@gmail.com
class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  //Existe esse negocio de chave glogal e existe esse negocio de tipo FormState
  //utilizando-se essa chave você pode manusear metodos do tipo
  //.currentState.save()
  //.currentWidget
  //.currentContext
  //Aqui ele iniciou o enum como login..ao inves de usar uma variavel qualquer
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

//faz verificações pra saber se está em login ou em signUp
  bool _isLogin() => _authMode == AuthMode.Login;
  //bool _isSignup() => _authMode == AuthMode.SignUp;
  //paramos de usar ao começar a fazer as animações. Antes foi útil.

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  ///Essa classe receberá um tipo generics que vai ser o tipo de
  ///critério de dado que desejo animar, poderia ser altura, opacidade, etc
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 300,
        ));

    ///Esse this quer dizer: o vsync (responsável por conter a callback a ser chamada 60FPS)
    ///é a propria classe que eu estou agora pois ela implementa e tem os metodos necessários
    ///pra se transformar num ticker provider. A cada 100 millisengundo ele chama 6 vezes

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.decelerate,
    ));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -2.5),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.decelerate,
    ));
    //_heightAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.SignUp;
        _controller?.forward();
      } else {
        _authMode = AuthMode.Login;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    print('A função _submit() foi acionada');
    final isValid = _formKey.currentState?.validate() ?? false;
    //Isso é uma verificação para entender se esse formulario é válido.
    //ou seja: se há um estado vinculado a esse formulário e se esse estado é valido
    //O estado pode não estar presente...por isso se usa o ?
    // Mesmo o estado presente ele pode não ser válido
    if (!isValid) return;

    setState(() => _isLoading = true);
    _formKey.currentState?.save();
    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_isLogin()) {
        //Se eu estiver com login eu vou enviar uma requisição de login
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        //do contrario vou enviar requisição pra registrar
        await auth.signUp(
          _authData['email']!,
          _authData['password']!,
        );
        //Eu posso colocar o ! dizendo que essas informações estarão presentes
        //por eu ter feito a validação do form antes de passar esses dados aqui
      }
    } on AuthException catch (error) {
      print('Um erro do tipo AuthException foi detectado');
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro não catalogado');
    } finally {
      print('A execução dos procedimentos de erro finalizou');
    }

    //_authData
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final deviceSize = MediaQuery.of(context).size;
    //variavel utilizada para fazer com que o container do card fique a 75% da tela
    final deviceRelation = deviceSize.height / deviceSize.width;
    print('Tamanho da tela x: ${deviceSize.width}');
    print('Tamanho da tela y: ${deviceSize.height}');
    print('Relação entre y/x: $deviceRelation');
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        //height: _isLogin() ? 250 : 300,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        //height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
        width: deviceSize.width * 0.75,
        padding: EdgeInsetsDirectional.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (email) => _authData['email'] = email ?? '',
                  validator: (_email) {
                    final email = _email ?? '';
                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'password'),
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (password) => _authData['password'] = password ?? '',
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password.isEmpty || password.length < 5) {
                      return 'Informe uma senha válida';
                    }
                    return null;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                      minHeight: _isLogin() ? 0 : 20,
                      maxHeight: _isLogin() ? 0 : 120),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirmar password'),
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        //para que a validação não seja disparada na validação do login eu posso fazer
                        //essa condicional de seguranca:
                        validator: _isLogin()
                            ? null
                            : (_password) {
                                //Para ter acesso ao campo digitado no textfield acima pra fazer
                                //a confirmação eu vou precisar utilizar o textEditingController()
                                final password = _password ??
                                    ''; //Estrategia para trabalhar com certeza com valor não null
                                if (password != _passwordController.text) {
                                  return 'Senhas digitadas não conferem';
                                } // Se a confi
                              },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                (_isLoading)
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(_isLogin() ? 'ENTRAR' : 'REGISTRAR')),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 8),
                        ),
                      ),
                SizedBox(
                  height: 25,
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?'),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
