import 'package:flutter/material.dart';
import '../upload/upload_resource_screen.dart';

/// The main admin dashboard screen.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadResourceScreen(),
              ),
            );
          },
          child: const Text('Upload Resource'),
        ),
      ),
    );
  }
}
