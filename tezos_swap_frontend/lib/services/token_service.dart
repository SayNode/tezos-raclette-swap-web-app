import 'dart:convert';
import 'package:flutter/services.dart' as root_bundle;
import 'package:get/get.dart';
import '../models/token.dart';

class TokenService extends GetxService{
  late List<Token> _tokens;

  List<Token> get tokens => _tokens;

  Future<bool> init() async {
    _tokens = await loadTokens();
    return true;
  }

  Future<List<Token>> loadTokens() async {
    //read json file
    final jsondata =
        await root_bundle.rootBundle.loadString('data/token.json');
        //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;
    //map json and initialize using DataModel
    return list.map((e) => Token.fromJson(e)).toList();
  }
}
