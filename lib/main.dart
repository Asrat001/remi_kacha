import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/app.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      home: const App(),
    );
  }
}
