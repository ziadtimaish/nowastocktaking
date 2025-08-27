import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:elite_stocktaking/integrations/supabase_service.dart';
import 'package:elite_stocktaking/pages/splash_screen.dart';
import 'package:elite_stocktaking/pages/home_page.dart';
import 'package:elite_stocktaking/pages/sign_in_page.dart';

@NowaGenerated()
class AuthWrapper extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() {
    return _AuthWrapperState();
  }
}

@NowaGenerated()
class _AuthWrapperState extends State<AuthWrapper> {
  bool _isCheckingAuth = true;

  bool _isAuthenticated = false;

  late final DateTime _splashStartAt;

  @override
  void initState() {
    super.initState();
    _splashStartAt = DateTime.now();
    _checkAuthentication();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        final isAuthenticated = data.session != null;
        if (_isAuthenticated != isAuthenticated) {
          setState(() {
            _isAuthenticated = isAuthenticated;
          });
        }
      }
    });
  }

  Future<void> _checkAuthentication() async {
    try {
      final isAuth = await SupabaseService().checkAuthState();
      final elapsed = DateTime.now().difference(_splashStartAt);
      const minSplashDuration = Duration(milliseconds: 700);
      final remaining = minSplashDuration - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }
      if (mounted) {
        setState(() {
          _isAuthenticated = isAuth;
          _isCheckingAuth = false;
        });
      }
    } catch (e) {
      final elapsed = DateTime.now().difference(_splashStartAt);
      const minSplashDuration = Duration(milliseconds: 700);
      final remaining = minSplashDuration - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isCheckingAuth = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAuth) {
      return const SplashScreen();
    }
    return _isAuthenticated ? const HomePage() : const SignInPage();
  }
}
