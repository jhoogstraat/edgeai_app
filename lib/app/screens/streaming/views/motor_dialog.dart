import '../../../../library/providers/app_providers.dart';
import '../../../../library/providers/service_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MotorDialog extends StatelessWidget {
  const MotorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Motorkonfiguration'),
      contentPadding: const EdgeInsets.all(24),
      scrollable: true,
      content: Consumer(
        builder: (context, ref, child) {
          final api = ref.read(apiProvider);
          final status = ref.watch(motorStatusProvider);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text("Aktiv: ${status.state.running}"),
              Text(
                  "Step: ${status.state.pause.toStringAsFixed(4)}s | Richtung: ${status.state.direction}"),
              ElevatedButton(
                child: Text(status.state.running ? "Stop" : "Start"),
                onPressed: () async {
                  if (status.state.running) {
                    status.state = await api.stopMotor();
                  } else {
                    await api.startMotor();
                    status.state = await api.motorStatus();
                  }
                },
              ),
              ElevatedButton(
                child: const Text("Schneller"),
                onPressed: () async =>
                    status.state = await api.accelerateMotor(),
              ),
              ElevatedButton(
                child: const Text("Langsamer"),
                onPressed: () async =>
                    status.state = await api.decelerateMotor(),
              ),
              ElevatedButton(
                child: const Text("Richtungswechsel"),
                onPressed: () async => status.state = await api.reverseMotor(),
              ),
            ],
          );
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Schließen'),
        ),
      ],
    );
  }
}
