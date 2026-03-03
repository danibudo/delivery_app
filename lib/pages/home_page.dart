import 'package:flutter/material.dart';
import 'create_delivery.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateDelivery()),
            ),
            child: const Text('Create Delivery'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Request Invoice'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Get Business Summary'),
          ),
        ],
      ),
    );
  }
}