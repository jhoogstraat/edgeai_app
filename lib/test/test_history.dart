import 'package:flutter/material.dart';

class TestSetsScreen extends StatelessWidget {
  const TestSetsScreen({Key? key}) : super(key: key);

  static const sets = ["1", "2", "3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sets'),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_forever), onPressed: () => {})
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final featureSet = sets[index];

            return ListTile(
              title: Text('Set-ID ${featureSet}'),
              subtitle: Text(featureSet),
              minVerticalPadding: 25,
              leading: const SizedBox(
                width: 56,
                height: 56,
                child: ColoredBox(color: Colors.green),
              ),
              trailing: const SizedBox(
                height: double.infinity,
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: sets.length),
    );
  }
}
