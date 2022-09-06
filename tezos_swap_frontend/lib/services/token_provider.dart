import 'package:flutter/material.dart';
import '../models/token.dart';

class TokenProvider extends ValueNotifier<Token?> {
  TokenProvider({Token? token}) : super(null);
  Token? _token;

  Token? get token => _token;
  
  set token(Token? token) {
    _token = token;
    notifyListeners();
  }
}
