import 'package:flutter/material.dart';

Expanded buildCountCard(String count, Color color) {
  return Expanded(
    child: Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 5,
            ),
            const SizedBox(height: 5),
            Text('$count devices'),
          ],
        ),
      ),
    ),
  );
}
