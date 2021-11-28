class HttpException implements Exception {
  final String msg;
  final int statusCode;

  HttpException({required this.msg, required this.statusCode});

  @override
  String toString() {
    //esse toString vai nos possibilitar lançar o erro quando ele acontecer
    return msg;
  }
}
