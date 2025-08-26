import 'package:flutter/material.dart';
import 'package:elite_stocktaking/models/user_model.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:elite_stocktaking/integrations/supabase_service.dart';
import 'package:elite_stocktaking/pages/sign_in_page.dart';

@NowaGenerated()
class SettingsPage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() {
    return _SettingsPageState();
  }
}

@NowaGenerated()
class _SettingsPageState extends State<SettingsPage> {
  UserModel? _currentUser;

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final currentAuthUser = Supabase.instance.client.auth.currentUser;
      if (currentAuthUser != null) {
        final users = await SupabaseService().getAllUsers();
        final user = users.where((u) => u.email == currentAuthUser.email).firstOrNull;
        if (mounted) {
          setState(() {
            _currentUser = user ??
                UserModel(
                  email: currentAuthUser.email,
                  name: currentAuthUser.userMetadata?['name'] ?? 'User',
                );
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'No user logged in';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load profile. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await SupabaseService().signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to sign out. Please try again.'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.0,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: _loadUserProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
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
                          children: [
                            Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade400,
                                    Colors.blue.shade600,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  (_currentUser?.name?.isNotEmpty == true ? _currentUser!.name![0].toUpperCase() : 'U'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              _currentUser?.name ?? 'User',
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              _currentUser?.email ?? 'No email',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (_currentUser?.role != null) ...[
                              const SizedBox(height: 8.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.blue.shade200),
                                ),
                                child: Text(
                                  _currentUser!.role!,
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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
                          children: [
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                              title: const Text(
                                'Edit Profile',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: const Text(
                                'Update your personal information',
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.grey.shade400,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Edit Profile feature coming soon!',
                                    ),
                                  ),
                                );
                              },
                            ),
                            Divider(color: Colors.grey.shade200),
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.security,
                                  color: Colors.green.shade600,
                                ),
                              ),
                              title: const Text(
                                'Security',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: const Text(
                                'Change password and security settings',
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.grey.shade400,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Security settings coming soon!'),
                                  ),
                                );
                              },
                            ),
                            Divider(color: Colors.grey.shade200),
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.help_outline,
                                  color: Colors.purple.shade600,
                                ),
                              ),
                              title: const Text(
                                'Help & Support',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: const Text('Get help and contact support'),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.grey.shade400,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Help & Support coming soon!'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      SizedBox(
                        height: 56.0,
                        child: ElevatedButton(
                          onPressed: _showSignOutDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 2.0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, size: 20.0),
                              SizedBox(width: 8.0),
                              Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Center(
                        child: Text(
                          'Elite Stocktaking v1.0.0',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
