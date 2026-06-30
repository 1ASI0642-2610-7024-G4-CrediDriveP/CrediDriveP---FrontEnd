import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const CrediDrivePApp());
}

class CrediDrivePApp extends StatelessWidget {
  const CrediDrivePApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.create(di.sl<FlutterSecureStorage>());

    return MaterialApp.router(
      title: 'CrediDriveP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) {
        if (child == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return child;
      },
    );
  }
}
