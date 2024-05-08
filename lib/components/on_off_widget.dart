import 'package:app/services/database_service.dart';
import 'package:app/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class OnOffToggleButton extends StatefulWidget {
  const OnOffToggleButton({Key? key}) : super(key: key);

  @override
  _OnOffToggleButtonState createState() => _OnOffToggleButtonState();
}

class _OnOffToggleButtonState extends State<OnOffToggleButton> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 60.0;
    const double iconSize = 30.0;

    return InkWell(
      onTap: () async {
        // get token and send request
        var token = await PreferencesService().getString('token');
        print('token: $token');

        var deviceId = await PreferencesService().getString('device_id');
        print('deviceId: $deviceId');

        var body = {
          'command': 'open',
          'target': deviceId,
        };

        await DatabaseServices()
            .postData('pi/send-command/$deviceId', token!, body);

        setState(() {
          _isOn = !_isOn;
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.all((buttonSize - iconSize) / 2),
          color: _isOn ? Colors.red : Colors.black,
          child: Icon(
            Icons.power_settings_new,
            size: iconSize,
            color: _isOn ? Colors.white : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
