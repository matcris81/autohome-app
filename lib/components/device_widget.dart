import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget {
  final String roomName;
  final Map<String, dynamic> device;
  final String deviceControl;
  final bool isRemovalMode;
  final VoidCallback onRemove;
  final VoidCallback
      onChangeIcon; // This might need to be updated to handle images

  DeviceTile({
    Key? key,
    required this.device,
    required this.deviceControl,
    required this.roomName,
    this.isRemovalMode = false,
    required this.onRemove,
    required this.onChangeIcon, // Ensure this is updated for handling image change
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The image to display, defaulting to a placeholder if not provided
    String imagePath = device['image'] ?? 'assets/images/placeholder.png';

    // Use an Image widget if an image path is provided, otherwise use a placeholder
    Widget imageWidget = Image.asset(
      imagePath,
      width: 70,
      height: 70,
    );

    return Card(
      color: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          List<String> controlTypes =
              List<String>.from(device['controlTypes'] ?? []);
          Navigator.pushNamed(
            context,
            deviceControl,
            arguments: {
              'deviceName': device['name'],
              'controlTypes': controlTypes,
              'roomName': roomName,
            },
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isRemovalMode
                ? IconButton(
                    icon: Icon(Icons.edit), // A button to change the image
                    onPressed: onChangeIcon,
                  )
                : imageWidget,
            const SizedBox(height: 8),
            Text(
              device['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
