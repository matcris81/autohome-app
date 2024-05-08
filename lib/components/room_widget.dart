import 'package:app/routes.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  final Map<String, dynamic> roomData;
  final bool isRemovalMode;
  final VoidCallback onRemove;

  const RoomWidget({
    super.key,
    required this.roomData,
    this.isRemovalMode = false,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.room,
          arguments: roomData['name'],
        );
      },
      borderRadius: BorderRadius.circular(20.0),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.image, size: 50, color: Colors.white),
                  Text(
                    roomData['name'],
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${(roomData['devices'] is List ? roomData['devices'].length : 0)} Devices',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (isRemovalMode)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: onRemove,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
