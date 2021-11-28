import 'package:flutter/widgets.dart';

//armazenar o estado que vamos manipular a partir do provider
class CounterState {
  int _value = 0;

  //metodos para manipular esse estado

  void inc() => _value++;
  void dec() => _value--;
  int get value => _value;

  bool diff(CounterState old) {
    return old._value != _value;
  }
}

class CounterProvider extends InheritedWidget {
  final CounterState state = CounterState();
  CounterProvider({required Widget child}) : super(child: child);

  static CounterProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  @override
  //Esse método é necessário implementar por padrão
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
