import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class SplashScreen extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200,
                    blurRadius: 20.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: const Icon(
                Icons.inventory_2,
                color: Colors.white,
                size: 60.0,
              ),
            ),
            const SizedBox(height: 32.0),
            Text(
              'Nowa Stocktaking',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Checking authentication...',
              style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
