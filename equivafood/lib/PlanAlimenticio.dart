import 'package:flutter/material.dart';

class PlanAlimenticioScreen extends StatelessWidget {
  const PlanAlimenticioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Plan Alimenticio'),
        backgroundColor: const Color(0xFF33D1C1),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_turned_in_outlined,
              size: 80,
              color: Color(0xFF33D1C1),
            ),
            SizedBox(height: 20),
            Text(
              'Aquí aparecerá tu plan alimenticio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
