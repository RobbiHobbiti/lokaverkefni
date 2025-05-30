import 'package:flutter/material.dart';
import 'playerClass.dart';

class InventoryOverlay extends StatefulWidget {
  final Player player;
  final void Function(String) onDropItem;
  const InventoryOverlay({super.key, required this.player, required this.onDropItem});

  @override
  State<InventoryOverlay> createState() => _InventoryOverlayState();
}

class _InventoryOverlayState extends State<InventoryOverlay> {
  late List<String> items;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.player.inventory);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
      widget.player.inventory
        ..clear()
        ..addAll(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemImages = {
      'sword': 'assets/images/sword.png',
      'Rpg': 'assets/images/rpg.png',
    };

    return Center(
      child: Container(
        width: 520,
        height: 440,
        color: Colors.black.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Inventory', style: TextStyle(color: Colors.white, fontSize: 24)),
            Expanded(
              child: ReorderableListView(
                onReorder: _onReorder,
                children: [
                  for (final item in items)
                    ListTile(
                      key: ValueKey(item),
                      leading: itemImages[item] != null
                          ? Image.asset(itemImages[item]!, width: 128, height: 128)
                          : null,
                      title: Text(item, style: const TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Drop',
                        onPressed: () {
                          setState(() {
                            items.remove(item);
                            widget.player.inventory.remove(item);
                          });
                          widget.onDropItem(item);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}