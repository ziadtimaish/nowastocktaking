import 'package:elite_stocktaking/pages/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elite_stocktaking/integrations/supabase_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elite_stocktaking/globals/app_state.dart';

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
        initialRoute: 'HomePage',
        routes: {'HomePage': (context) => const SignInPage()},
      ),
    );
  }
}
