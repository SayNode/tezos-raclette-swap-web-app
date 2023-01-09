import 'package:tezos_swap_frontend/models/contract_model.dart';

import '../services/wallet_connection.dart';

final WalletProvider walletProvider = WalletProvider();
const String testContract = 'KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB';
const String networkUri = 'https://ghostnet.tezos.marigold.dev';
const String network = 'ghostnet';
List<Contract>? contracts;
