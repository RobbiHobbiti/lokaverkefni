import 'package:flutter/material.dart';
import 'playerClass.dart';

class InventoryOverlay extends StatelessWidget {
  final Player player;
  const InventoryOverlay({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    
    final itemImages = {
      'sword': 'assets/images/sword.png',
    };

    return Center(
      child: Container(
        width: 300,
        height: 200,
        color: Colors.black.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Inventory', style: TextStyle(color: Colors.white, fontSize: 24)),
            ...player.inventory.map((item) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (itemImages[item] != null)
                  Image.asset(itemImages[item]!, width: 64, height: 64),
                const SizedBox(width: 8),
                Text(item, style: const TextStyle(color: Colors.white)),
              ],
            )),
          ],
        ),
      ),
    );
  }
}