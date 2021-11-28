class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado.',
    'OPERATION_NOT_ALLOWED': 'Opearação não permitida!',
    'TO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente. Tente mais tarde.',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado',
    'INVALID_PASSWORD': 'Senha informada não confere.',
    'USER_DISABLED': 'A conta do usuário está desabilitada.',
  };

  final String key; //

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro não conhecido';

    /// Funciona assim: criamos um map e estamos retornando o
    /// valor desse map de acordo com a chave apresentada.
    /// Essa chave será decodificada lá no _login(). Se der um erro
    /// esse erro virá com um body, dentro desse body temos algumas keys
    /// ('errors' e 'exception') que indicarão para o valor da
    /// key utilizada aqui
  }
}
