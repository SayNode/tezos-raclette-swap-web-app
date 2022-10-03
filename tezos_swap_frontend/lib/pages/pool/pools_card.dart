import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/pages/pool/new_position_card.dart';
import 'package:tezos_swap_frontend/pages/pool/positions_card.dart';
import 'package:tezos_swap_frontend/services/new_position_service.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';
import 'package:tezos_swap_frontend/utils/globals.dart';
import 'package:tezos_swap_frontend/utils/utils.dart';

class PoolCard extends StatefulWidget {
  final WalletProvider provider;
  const PoolCard({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<PoolCard> createState() => _PoolCardState();
}

class _PoolCardState extends State<PoolCard> {
  @override
  void initState() {
    Get.put(NewPositionService());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((() => (Get.put(NewPositionService()).newPosition.isTrue)
        ? NewPositionCard(provider: widget.provider)
        : PositionsCard()));
  }
}
