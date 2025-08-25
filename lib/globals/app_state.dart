import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:provider/provider.dart';
import 'package:elite_stocktaking/globals/themes.dart';

@NowaGenerated()
class AppState extends ChangeNotifier {
  AppState();

  factory AppState.of(BuildContext context, {bool listen = true}) {
    return Provider.of<AppState>(context, listen: listen);
  }

  ThemeData _theme = lightTheme;

  ThemeData get theme => _theme;

  void changeTheme(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }
}
