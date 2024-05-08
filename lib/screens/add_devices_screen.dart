import 'package:flutter/material.dart';
import 'package:app/services/storage_services.dart';

class AddDeviceScreen extends StatefulWidget {
  final String roomName;
  final VoidCallback onDeviceAdded;

  const AddDeviceScreen({
    Key? key,
    required this.roomName,
    required this.onDeviceAdded,
  }) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _controlTypes = [
    'Toggle',
    'Slider',
    'Increment/Decrement',
    'Dropdown',
    'Dial',
    'Video',
  ];
  List<String> _selectedControlTypes = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device'),
        backgroundColor: Colors.deepPurple[300],
        actions: [
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                StorageServices()
                    .addDeviceToRoom(widget.roomName, _controller.text,
                        _selectedControlTypes)
                    .then((_) {
                  widget.onDeviceAdded();
                  Navigator.pop(context);
                });
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Device Name',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
              ),
              cursorColor: Colors.white,
            ),
            ..._controlTypes.map((type) => CheckboxListTile(
                  title: Text(
                    type,
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _selectedControlTypes.contains(type),
                  onChanged: (bool? newValue) {
                    setState(() {
                      if (newValue == true) {
                        _selectedControlTypes.add(type);
                      } else {
                        _selectedControlTypes.remove(type);
                      }
                    });
                  },
                )),
          ],
        ),
      ),
      backgroundColor: Colors.deepPurple[300],
    );
  }
}
