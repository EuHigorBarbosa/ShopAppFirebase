import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Store {
  //utilizaremos esses metodos para salvar os dados dentro dessa area
  //de persistencia chamada de SharePreference.
  ///a) grava strings lá com chave para ser encontrada depois
  ///b) grava Maps lá com chave para ser encontrada depois
  ///c) le Strings gravadas lá
  ///d) le Maps gravados lá
  ///e) transofando um json num map

  static Future<bool> saveStringIntoSharedPreferences(
      String key, String value) async {
    //Esse método salva uma String dentro de sharedPreferences
    final prefs = await SharedPreferences
        .getInstance(); //pref é uma instancia de sheredPreferences
    return prefs.setString(key,
        value); //retorna bool pra dizer se foi ou não persistido no aparelho
  }

  static Future<bool> saveMapIntoSharedPreferences(
      String key, Map<String, dynamic> value) async {
    //Se eu passar um map ele vai converter pra json pra poder ser utilizado
    //como uma string no outro método saveString
    return saveStringIntoSharedPreferences(key, jsonEncode(value));
  }

  static Future<String> getStringFromSheredPreferences(String key,
      [String defaultValue = '']) async {
    //parametro defaut para caso não encontre o dado ele não retorne erro
    //Ler uma string que foi persistida dentro do meu dispositivo (no HD) pra usar
    // o dado que você gravou
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ??
        defaultValue; //getString retorna String? - então pra eu nunca cair nessa eu faço esse ??
  }

  static Future<Map<String, dynamic>> getMapFromSheredPreferences(
      String key) async {
    ///transforma uma string json em um Map<String, Dynamic> usando a função jsonDecode
    ///esse json string foi conseguido aplicando-se o getStringFromSheredPreferences em uma string json
    try {
      return jsonDecode(await getStringFromSheredPreferences(
          key)); //pode ser que retorne um getString inválido
    } catch (_) {
      return {}; //caso não consiga fazer o decode vai retornar um MAP vazio {}.
    }
  }

  //transofando um json num map
  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
