import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/services/crypto_service.dart';
import 'core/services/portfolio_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/portfolio/presentation/providers/portfolio_provider.dart';
import 'features/market/presentation/providers/market_provider.dart';
import 'features/trading/presentation/providers/trading_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize services
  await NotificationService.initialize();
  await CryptoService.initialize();
  await PortfolioService.initialize();
  
  runApp(
    const ProviderScope(
      child: CryptoTrackerApp(),
    ),
  );
}

class CryptoTrackerApp extends ConsumerWidget {
  const CryptoTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
