import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class HelpAndSupportPage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const HelpAndSupportPage({super.key});

  @override
  State<HelpAndSupportPage> createState() {
    return _HelpAndSupportPageState();
  }
}

@NowaGenerated()
class _HelpAndSupportPageState extends State<HelpAndSupportPage> {
  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How do I add new stock items?',
      'answer':
          'Navigate to the Stock Management section and tap the "Add Stock" button. Fill in the required information including SKU, name, quantity, and location.',
    },
    {
      'question': 'How can I export my stocktaking reports?',
      'answer': 'Go to the Audit page and tap the export button. You can choose from PDF or Excel formats for your reports.',
    },
    {
      'question': 'What should I do if I forget my password?',
      'answer': 'On the login screen, tap "Forgot Password" and follow the instructions sent to your registered email address.',
    },
    {
      'question': 'How do I update stock quantities?',
      'answer':
          'Find the item in your stock list, tap on it, and update the quantity. The system will automatically track the transaction.',
    },
    {
      'question': 'Can multiple users access the same account?',
      'answer': 'Yes, you can invite team members through the Settings page. Each user will have their own login credentials.',
    },
  ];

  int _expandedIndex = -1;

  Future<void> _launchPhone(String phoneNumber) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $phoneNumber...'),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening email to $email...'),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Help & Support',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 4.0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Icon(
                          Icons.location_city,
                          color: Colors.purple.shade600,
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      const Expanded(
                        child: Text(
                          'Elite Stocktaking Support',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  _buildContactItem(
                    Icons.location_on_outlined,
                    'Address',
                    'Amman Business District\nAbdali Boulevard, Amman 11191\nJordan',
                    Colors.red,
                    onTap: () {},
                  ),
                  const SizedBox(height: 16.0),
                  _buildContactItem(
                    Icons.phone_outlined,
                    'Phone Support',
                    '+962 6 123-4567',
                    Colors.green,
                    onTap: () => _launchPhone('+962 6 123-4567'),
                  ),
                  const SizedBox(height: 16.0),
                  _buildContactItem(
                    Icons.email_outlined,
                    'Email Support',
                    'support@elitestocktaking.jo',
                    Colors.blue,
                    onTap: () => _launchEmail('support@elitestocktaking.jo'),
                  ),
                  const SizedBox(height: 16.0),
                  _buildContactItem(
                    Icons.schedule_outlined,
                    'Business Hours',
                    'Sunday - Thursday: 8:00 AM - 6:00 PM\nFriday: 8:00 AM - 2:00 PM\nSaturday: Closed',
                    Colors.orange,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade50, Colors.red.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Emergency Support',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          '24/7 Critical Issues Only',
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                        const SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () => _launchPhone('+962 79 999-8888'),
                          child: Text(
                            '+962 79 999-8888',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 4.0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(
                            Icons.help_outline,
                            color: Colors.amber.shade700,
                            size: 24.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        const Text(
                          'Frequently Asked Questions',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _faqItems.length,
                    separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, height: 1.0),
                    itemBuilder: (context, index) {
                      final item = _faqItems[index];
                      final isExpanded = _expandedIndex == index;
                      return ExpansionTile(
                        title: Text(
                          item['question']!,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(
                          isExpanded ? Icons.remove : Icons.add,
                          color: Colors.grey.shade600,
                        ),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _expandedIndex = expanded ? index : -1;
                          });
                        },
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              0.0,
                              16.0,
                              16.0,
                            ),
                            child: Text(
                              item['answer']!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Additional Resources',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildResourceItem(
                    Icons.video_library_outlined,
                    'Video Tutorials',
                    'Watch our comprehensive video guides',
                  ),
                  const SizedBox(height: 12.0),
                  _buildResourceItem(
                    Icons.article_outlined,
                    'User Manual',
                    'Download the complete user manual',
                  ),
                  const SizedBox(height: 12.0),
                  _buildResourceItem(
                    Icons.forum_outlined,
                    'Community Forum',
                    'Connect with other users and experts',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    String content,
    Color iconColor, {
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: iconColor, size: 20.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey.shade700,
                    height: 1.4,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildResourceItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 24.0),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12.0, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Icon(Icons.open_in_new, color: Colors.blue.shade600, size: 20.0),
      ],
    );
  }
}
