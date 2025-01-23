class CustomError{
  final String _error;
  String get error => _error; 

  CustomError(this._error);
}

class NetworkError extends CustomError{
  NetworkError(): super('Network error');
}