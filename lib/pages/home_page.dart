import 'package:flutter/material.dart';
import 'package:elite_stocktaking/pages/add_stock_page.dart';
import 'package:elite_stocktaking/pages/audit_page.dart';
import 'package:elite_stocktaking/pages/settings_page.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class HomePage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

@NowaGenerated()
class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AddStockPage(),
    const AuditPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10.0,
              offset: const Offset(0.0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue.shade600,
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.0,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: _currentIndex == 0
                      ? Colors.blue.shade50
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  _currentIndex == 0 ? Icons.add_box : Icons.add_box_outlined,
                  size: 24.0,
                ),
              ),
              label: 'Add Stock',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: _currentIndex == 1
                      ? Colors.blue.shade50
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  _currentIndex == 1
                      ? Icons.assessment
                      : Icons.assessment_outlined,
                  size: 24.0,
                ),
              ),
              label: 'Audit',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: _currentIndex == 2
                      ? Colors.blue.shade50
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  _currentIndex == 2 ? Icons.settings : Icons.settings_outlined,
                  size: 24.0,
                ),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
