import 'package:app/services/voice_assistant_service.dart';
import 'package:flutter/material.dart';
import 'package:app/components/dial_widget.dart';
import 'package:app/components/on_off_widget.dart';
import 'package:app/components/slider_widget.dart';
import 'package:app/components/video_widget.dart';

class DeviceControlPanelScreen extends StatefulWidget {
  final String roomName;
  final String deviceName;
  final List<String> controlTypes;

  const DeviceControlPanelScreen({
    Key? key,
    required this.roomName,
    required this.deviceName,
    required this.controlTypes,
  }) : super(key: key);

  @override
  _DeviceControlPanelScreenState createState() =>
      _DeviceControlPanelScreenState();
}

class _DeviceControlPanelScreenState extends State<DeviceControlPanelScreen> {
  double _sliderValue = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      appBar: AppBar(
        toolbarHeight: 80.0,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16.0),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.roomName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.deviceName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_to_home_screen),
            onPressed: () {
              SiriShortcutHelper.createShortcut(widget.deviceName);
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 120),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: widget.controlTypes.map((controlType) {
                  if (controlType == 'Slider') {
                    return CustomSlider(
                      value: _sliderValue,
                      onChanged: (newValue) {
                        setState(() {
                          _sliderValue = newValue;
                        });
                      },
                    );
                  } else if (controlType == 'Dial') {
                    return CustomDial(
                      value: _sliderValue,
                      onChanged: (newValue) {
                        setState(() {
                          _sliderValue = newValue;
                        });
                      },
                    );
                  } else if (controlType == 'Video') {
                    return const Expanded(
                      child: VideoWidget(
                          videoUrl: "rtmp://192.168.1.100:8081/live/stream"),
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: OnOffToggleButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
