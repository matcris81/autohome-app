import 'package:app/components/device_widget.dart';
import 'package:app/data_types/icons_list.dart';
import 'package:app/routes.dart';
import 'package:app/screens/add_devices_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/services/storage_services.dart';

class RoomScreen extends StatefulWidget {
  final String roomName;

  const RoomScreen({super.key, required this.roomName});

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  List<dynamic> devices = [];
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    List<dynamic> rooms = await StorageServices().readRooms();
    final room = rooms.firstWhere(
      (room) => room['name'] == widget.roomName,
      orElse: () => null,
    );
    if (room != null) {
      setState(() {
        devices = room['devices'];
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  Future<void> _removeDevice(String deviceName) async {
    await StorageServices().removeDeviceFromRoom(widget.roomName, deviceName);
    _loadDevices();
  }

  Future<void> _showImagePicker(BuildContext context, String deviceName) async {
    final String? selectedImagePath = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          height: MediaQuery.of(context).size.height / 2,
          child: GridView.count(
            crossAxisCount: 4,
            children: List.generate(ImageAssetsList.images.length, (index) {
              return InkWell(
                onTap: () =>
                    Navigator.pop(context, ImageAssetsList.images[index]),
                child: Image.asset(ImageAssetsList.images[index]),
              );
            }),
          ),
        );
      },
    );

    if (selectedImagePath != null) {
      _changeDeviceImage(deviceName, selectedImagePath);
    }
  }

  Future<void> _changeDeviceImage(
      String deviceName, String newImagePath) async {
    await StorageServices().changeDeviceImage(
      widget.roomName,
      deviceName,
      newImagePath,
    );

    _loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.roomName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple[300],
        actions: [
          TextButton(
            onPressed: _toggleEditMode,
            child: Text(
              _isEditMode ? 'Done' : 'Edit',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: devices.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return DeviceTile(
                  device: devices[index],
                  roomName: widget.roomName,
                  deviceControl: AppRoutes.deviceControl,
                  isRemovalMode: _isEditMode,
                  onRemove: () => _removeDevice(devices[index]['name']),
                  onChangeIcon: () =>
                      _showImagePicker(context, devices[index]['name']),
                );
              },
            )
          : const Center(
              child: Text('No devices found',
                  style: TextStyle(color: Colors.white)),
            ),
      floatingActionButton: _isEditMode
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDeviceScreen(
                      roomName: widget.roomName,
                      onDeviceAdded: () => _loadDevices(),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
      backgroundColor: Colors.deepPurple[300],
    );
  }
}
