import 'package:app/services/database_service.dart';
import 'package:app/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:app/components/room_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> rooms = [];
  bool isRemovalMode = false;

  final StorageServices _storageServices = StorageServices();

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void checkHomeWiFi() {
    // Check if the device is connected to the home WiFi
    DatabaseServices().getData('${DatabaseServices().backendUrl}/get_bssid');
  }

  Future<void> _loadRooms() async {
    rooms = await _storageServices.readRooms();
    setState(() {});
  }

  void _toggleRemovalMode() {
    setState(() {
      isRemovalMode = !isRemovalMode;
    });
  }

  void _removeRoom(String roomName) async {
    await StorageServices().removeRoom(roomName);
    _loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        actions: [
          if (isRemovalMode)
            if (isRemovalMode)
              TextButton(
                onPressed: _toggleRemovalMode,
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurple[300],
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          children: [
            ListTile(
              leading: const Icon(Icons.add, color: Colors.white),
              title: const Text(
                'Add room',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.of(context).pushReplacementNamed('/add-room');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text(
                'Edit token',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.of(context).pushReplacementNamed('/token');
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove, color: Colors.white),
              title: const Text(
                'Remove room',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _toggleRemovalMode(); // Activate removal mode
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text(
                'Share home',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome to Swift 👋',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Your Rooms',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: rooms.isNotEmpty
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        return RoomWidget(
                          roomData: rooms[index],
                          isRemovalMode: isRemovalMode,
                          onRemove: () => _removeRoom(rooms[index]['name']),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No rooms added yet',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
