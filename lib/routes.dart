import 'package:app/authentication_screen.dart';
import 'package:app/screens/add_devices_screen.dart';
import 'package:app/screens/add_room_screen.dart';
import 'package:app/screens/device_control_panel_screen.dart';
import 'package:app/screens/room_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/home_screen.dart';

class AppRoutes {
  static const String main = '/';
  static const String home = '/home';
  static const String addRoom = '/add-room';
  static const String token = '/token';
  static const String room = '/room';
  static const String addDevice = '/add-device';
  static const String deviceControl = '/device-control';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addRoom:
        return MaterialPageRoute(builder: (_) => AddRoomScreen());
      case token:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case room:
        final String roomName = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => RoomScreen(roomName: roomName));
      case addDevice:
        final String roomName = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => AddDeviceScreen(
                  roomName: roomName,
                  onDeviceAdded: () {
                    Navigator.popAndPushNamed(_, AppRoutes.room,
                        arguments: roomName);
                  },
                ));
      case deviceControl:
        final args = settings.arguments as Map<String, dynamic>;
        if (args['roomName'] != null &&
            args['deviceName'] != null &&
            args['controlTypes'] != null) {
          return MaterialPageRoute(
            builder: (_) => DeviceControlPanelScreen(
              roomName: args['roomName'],
              deviceName: args['deviceName'],
              controlTypes: args['controlTypes'],
            ),
          );
        }
        return _errorRoute();

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}'))));
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('ERROR: Incorrect arguments passed to route'),
          ),
        );
      },
    );
  }
}
