import 'package:tezos_swap_frontend/services/tezster/michelson_parser/michelson_parser.dart';

class TezosLanguageUtil {
  static String translateMichelsonToMicheline(String code) {
    var result = MichelsonParser.parseMichelson(code);
    return result;
  }

  static String translateMichelineToHex(p) {
    return MichelsonParser.translateMichelineToHex(p);
  }
}