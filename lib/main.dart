import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'firebase_options.dart';
import 'data/services/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация локализации
  await EasyLocalization.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Инициализация Isar
  await IsarService.getInstance();

  // Настройка Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Логирование запуска приложения
  await FirebaseAnalytics.instance.logAppOpen();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
        Locale('kk'),
      ],
      path: 'assets/locales',
      fallbackLocale: const Locale('ru'),
      child: const ProviderScope(
        child: DriftScoreApp(),
      ),
    ),
  );
}

class DriftScoreApp extends StatelessWidget {
  const DriftScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drift Score',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Кнопка смены языка
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
              context.setLocale(locale);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Locale('ru'),
                child: Text('Русский'),
              ),
              const PopupMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem(
                value: Locale('kk'),
                child: Text('Қазақша'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Баннер
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 48,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'home_banner_title'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'home_banner_subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Кнопка: Просмотр протоколов
            ElevatedButton.icon(
              onPressed: () {
                _showNotImplemented(context, 'view_protocols'.tr());
              },
              icon: const Icon(Icons.list),
              label: Text('view_protocols'.tr()),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            // Кнопка: Статистика
            ElevatedButton.icon(
              onPressed: () {
                _showNotImplemented(context, 'statistics'.tr());
              },
              icon: const Icon(Icons.bar_chart),
              label: Text('statistics'.tr()),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            const Divider(),

            const SizedBox(height: 16),

            // Секция для организаторов
            Text(
              'for_organizers'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Кнопка: Ввести код организатора
            OutlinedButton.icon(
              onPressed: () {
                _showNotImplemented(context, 'enter_code'.tr());
              },
              icon: const Icon(Icons.qr_code),
              label: Text('enter_code'.tr()),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 12),

            // Кнопка: Купить код доступа
            OutlinedButton.icon(
              onPressed: () {
                _showNotImplemented(context, 'buy_code'.tr());
              },
              icon: const Icon(Icons.shopping_cart),
              label: Text('buy_code'.tr()),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const Spacer(),

            // Кнопка: Админ-доступ
            TextButton(
              onPressed: () {
                _showNotImplemented(context, 'admin_panel'.tr());
              },
              child: Text(
                'admin_panel'.tr(),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotImplemented(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - ${'in_development'.tr()}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}