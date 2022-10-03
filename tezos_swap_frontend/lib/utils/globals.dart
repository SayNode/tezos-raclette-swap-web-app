import 'package:tezos_swap_frontend/models/contract_model.dart';

import '../services/wallet_connection.dart';

final WalletProvider walletProvider = WalletProvider();
const String contract = 'KT1X8CWYPQhg8bB18n5YAMGTHUHoR6uKZmQ9';
const String networkUri = 'https://jakartanet.smartpy.io';
const String network = 'jakartanet';
List<Contract>? contracts;
