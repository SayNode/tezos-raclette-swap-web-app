import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:tezos_swap_frontend/services/tezster/gas_fee_calculator.dart';
import 'package:tezos_swap_frontend/services/tezster/models/key_store_model.dart';
import 'package:tezos_swap_frontend/services/tezster/models/operation_model.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:tezos_swap_frontend/services/tezster/tezos_language_util.dart';
import 'package:tezos_swap_frontend/services/tezster/tezos_node_reader.dart';


callContract() async{

  var server = '';

var keyStore = KeyStoreModel(
      publicKey: 'edpkvQtuhdZQmjdjVfaY9Kf4hHfrRJYugaJErkCGvV3ER1S7XWsrrj',
      secretKey:
          'edskRgu8wHxjwayvnmpLDDijzD3VZDoAH7ZLqJWuG4zg7LbxmSWZWhtkSyM5Uby41rGfsBGk4iPKWHSDniFyCRv3j7YFCknyHH',
      publicKeyHash: 'tz1QSHaKpTFhgHLbqinyYRjxD5sLcbfbzhxy',
    );

var signer = await createSigner(
        writeKeyWithHint(keyStore.secretKey, 'edsk'));


var contractAddress = 'KT1KA7DqFjShLC4CPtChPX8QtRYECUb99xMY';

var resultInvoke = await sendContractInvocationOperation(
        server,
        signer,
        keyStore,
        contractAddress,
        10000,
        100000,
        1000,
        100000,
        '',
        '"Cryptonomicon"',);

print(resultInvoke);
}



sendContractInvocationOperation(
      String server,
      SoftSigner signer,
      KeyStoreModel keyStore,
      String contract,
      int amount,
      int fee,
      int storageLimit,
      int gasLimit,
      entrypoint,
      String parameters,
      {TezosParameterFormat parameterFormat = TezosParameterFormat.Micheline,
      offset = 54}) async {
    var counter = await TezosNodeReader.getCounterForAccount(
            server, keyStore.publicKeyHash) +
        1;
    var transaction = constructContractInvocationOperation(
        keyStore.publicKeyHash,
        counter,
        contract,
        amount,
        fee,
        storageLimit,
        gasLimit,
        entrypoint,
        parameters,
        parameterFormat);
    var operations = await appendRevealOperation(server, keyStore.publicKey,
        keyStore.publicKeyHash, counter - 1, [transaction]);
    return sendOperation(server, operations, signer, offset);
  }

  Future<Map<String, Object>> sendOperation(String server,
      List<OperationModel> operations, SoftSigner signer, int offset) async {
    var blockHead = await TezosNodeReader.getBlockAtOffset(server, offset);
    var blockHash = blockHead['hash'].toString().substring(0, 51);
    var forgedOperationGroup = forgeOperations(blockHash, operations);
    var opSignature = signer.signOperation(Uint8List.fromList(hex.decode(
        TezosConstants.OperationGroupWatermark + forgedOperationGroup)));
    var signedOpGroup = Uint8List.fromList(
        hex.decode(forgedOperationGroup) + opSignature.toList());
    var base58signature = readSignatureWithHint(
        opSignature, signer.getSignerCurve());
    var opPair = {'bytes': signedOpGroup, 'signature': base58signature};
    var appliedOp = await preapplyOperation(
        server, blockHash, blockHead['protocol'], operations, opPair);
    var injectedOperation = await injectOperation(server, opPair);

    return {'appliedOp': appliedOp[0], 'operationGroupID': injectedOperation};
  }

  constructContractInvocationOperation(
      String publicKeyHash,
      int counter,
      String contract,
      int amount,
      int fee,
      int storageLimit,
      int gasLimit,
      entrypoint,
      String parameters,
      TezosParameterFormat parameterFormat) {
    var estimate = Estimate(gasLimit * 1000, storageLimit, 162, 250, fee);

    OperationModel transaction = OperationModel(
      destination: contract,
      amount: amount.toString(),
      counter: counter,
      fee: estimate.suggestedFeeMutez.toString(),
      source: publicKeyHash,
      gasLimit: estimate.gasLimit,
      storageLimit: estimate.storageLimit,
    );

    if (parameters != null) {
      if (parameterFormat == TezosParameterFormat.Michelson) {
        var michelineParams =
            TezosLanguageUtil.translateMichelsonToMicheline(parameters);
        transaction.parameters = {
          'entrypoint': entrypoint.isEmpty ? 'default' : entrypoint,
          'value': jsonDecode(michelineParams)
        };
      } else if (parameterFormat == TezosParameterFormat.Micheline) {
        transaction.parameters = {
          'entrypoint': entrypoint.isEmpty ? 'default' : entrypoint,
          'value': jsonDecode(parameters)
        };
      } else if (parameterFormat == TezosParameterFormat.MichelsonLambda) {
        var michelineLambda =
            TezosLanguageUtil.translateMichelsonToMicheline('code $parameters');
        transaction.parameters = {
          'entrypoint': entrypoint.isEmpty ? 'default' : entrypoint,
          'value': jsonDecode(michelineLambda)
        };
      }
      
    } else if (entrypoint != null) {
      transaction.parameters = {'entrypoint': entrypoint, 'value': []};
    }
    return transaction;
  }

  String forgeOperations(
      String branch, List<OperationModel> operations) {
    String encoded = TezosMessageUtils.writeBranch(branch);
    operations.forEach((element) {
      encoded += TezosMessageCodec.encodeOperation(element);
    });
    return encoded;
  }

  enum TezosParameterFormat {
  Michelson,
  Micheline,
  MichelsonLambda,
}
class TezosConstants {
  static const OperationGroupWatermark = "03";

  static const DefaultTransactionStorageLimit = 496;
  static const DefaultTransactionGasLimit = 10600;

  static const DefaultDelegationFee = 1258;
  static const DefaultDelegationStorageLimit = 0;
  static const DefaultDelegationGasLimit = 1101;

  static const DefaultKeyRevealFee = 1270;
  static const DefaultKeyRevealStorageLimit = 0;
  static const DefaultKeyRevealGasLimit = 1100;

  static const HeadBranchOffset = 54;
}



Uint8List writeKeyWithHint(
    String key,
    String hint,
  ) {
    if (hint == 'edsk' ||
        hint == 'edpk' ||
        hint == 'sppk' ||
        hint == 'p2pk' ||
        hint == '2bf64e07' ||
        hint == '0d0f25d9') {
      return bs58check.decode(key).sublist(4);
    } else
      throw Exception("Unrecognized key hint, '$hint'");
  }

  String readKeysWithHint(
    Uint8List key,
    String hint,
  ) {
    String uint8ListToString = String.fromCharCodes(key);
    String stringToHexString = hex.encode(uint8ListToString.codeUnits);
    String concatinatingHexStringWithHint = hint + stringToHexString;
    List<int> convertingHexStringToListOfInt =
        hex.decode(concatinatingHexStringWithHint);
    String base58String = bs58check.encode(Uint8List.fromList(convertingHexStringToListOfInt));
    return base58String;
  }

  createSigner(Uint8List secretKey, {int validity = 60}) {
    return SoftSigner.createSigner(secretKey, validity);
  }