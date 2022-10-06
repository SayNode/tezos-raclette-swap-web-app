import 'package:tezos_swap_frontend/models/contract_model.dart';

import '../services/wallet_connection.dart';

final WalletProvider walletProvider = WalletProvider();
const String testContract = 'KT1LWRzrgyHcB8LtMHUoEvy2D39NzndF3TmG';
const String networkUri = 'https://jakartanet.smartpy.io';
const String network = 'jakartanet';
List<Contract>? contracts;
