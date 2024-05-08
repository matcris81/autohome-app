import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class StorageServices {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/rooms.json');
  }

  Future<File> writeRooms(List<dynamic> rooms) async {
    final file = await _localFile;
    return file.writeAsString(json.encode(rooms));
  }

  Future<List<dynamic>> readRooms() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();

      print('contents: $contents');

      return json.decode(contents);
    } catch (e) {
      return [];
    }
  }

  Future<void> addDeviceToRoom(
      String roomName, String deviceName, List<String> controlTypes) async {
    List<dynamic> rooms = await readRooms();
    int roomIndex = rooms.indexWhere((room) => room['name'] == roomName);
    if (roomIndex != -1) {
      Map<String, dynamic> room = rooms[roomIndex];
      List<dynamic> devices = room['devices'];
      Map<String, dynamic> newDevice = {
        'name': deviceName,
        'controlTypes': controlTypes,
      };
      devices.add(newDevice);
      await writeRooms(rooms);
    }
  }

  Future<void> removeDeviceFromRoom(String roomName, String device) async {
    List<dynamic> rooms = await readRooms();
    int index = rooms.indexWhere((room) => room['name'] == roomName);
    if (index != -1 && rooms[index]['devices'].contains(device)) {
      rooms[index]['devices'].remove(device);
      await writeRooms(rooms);
    }
  }

  Future<void> removeRoom(String roomName) async {
    List<dynamic> rooms = await readRooms();
    rooms.removeWhere((room) => room['name'] == roomName);
    await writeRooms(rooms);
  }

  Future<void> changeDeviceImage(
      String roomName, String deviceName, String imagePath) async {
    List<dynamic> rooms = await readRooms();
    int roomIndex = rooms.indexWhere((room) => room['name'] == roomName);
    if (roomIndex != -1) {
      Map<String, dynamic> room = rooms[roomIndex];
      List<dynamic> devices = room['devices'];
      int deviceIndex =
          devices.indexWhere((device) => device['name'] == deviceName);
      if (deviceIndex != -1) {
        Map<String, dynamic> device = devices[deviceIndex];

        // Update this line to store the image path
        device['image'] = imagePath;

        await writeRooms(rooms);
      }
    }
  }

  // Map<String, dynamic> serializeIconData(IconData icon) {
  //   return {
  //     'codePoint': icon.codePoint,
  //     'fontFamily': icon.fontFamily,
  //     'fontPackage': icon.fontPackage,
  //   };
  // }

  // IconData deserializeIconData(Map<String, dynamic> iconMap) {
  //   return IconData(
  //     iconMap['codePoint'],
  //     fontFamily: iconMap['fontFamily'],
  //     fontPackage: iconMap['fontPackage'],
  //   );
  // }
}
