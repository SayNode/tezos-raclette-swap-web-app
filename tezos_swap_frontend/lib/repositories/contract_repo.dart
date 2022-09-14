import 'dart:convert';
import 'package:flutter/services.dart' as root_bundle;
import '../models/contract_model.dart';

class ContractRepository {
  late List<Contract> _contracts;

  List<Contract> get contracts => _contracts;

  Future<bool> init() async {
    _contracts = await loadContracts();
    return true;
  }

  Future<List<Contract>> loadContracts() async {
    //read json file
    final jsondata =
        await root_bundle.rootBundle.loadString('data/contracts.json');
        //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;
    //map json and initialize using DataModel
    return list.map((e) => Contract.fromJson(e)).toList();
  }
}
