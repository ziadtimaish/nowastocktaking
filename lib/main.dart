import 'package:shared_preferences/shared_preferences.dart';
import 'package:elite_stocktaking/integrations/supabase_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elite_stocktaking/globals/app_state.dart';
import 'package:elite_stocktaking/components/auth_wrapper.dart';
import 'package:elite_stocktaking/pages/sign_in_page.dart';
import 'package:elite_stocktaking/pages/home_page.dart';

@NowaGenerated()
late final SharedPreferences sharedPrefs;

@NowaGenerated()
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await SupabaseService().initialize();
  runApp(const MyApp());
}

@NowaGenerated({'visibleInNowa': false})
class MyApp extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppState.of(context).theme,
        initialRoute: 'AuthWrapper',
        routes: {
          'AuthWrapper': (context) => const AuthWrapper(),
          '/sign-in': (context) => const SignInPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}