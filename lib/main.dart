import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/screens/main_screen.dart';
import 'package:byewall3/screens/settings_screen.dart';
import 'package:byewall3/ui/language_provider.dart';
import 'package:byewall3/ui/theme_provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Consumer2<ThemeProvider, LanguageProvider>(
          builder: (context, themeProvider, languageProvider, child) {
            final lightColorScheme =
                lightDynamic ??
                ColorScheme.fromSeed(seedColor: Colors.green.shade800);
            final darkColorScheme = darkDynamic ?? ColorScheme.dark();
            return MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: languageProvider.locale, // Idioma atual
              title: 'Byewall',
              themeMode: themeProvider.themeMode, // Aplica o tema atual
              theme: ThemeData(
                colorScheme: lightColorScheme,
                useMaterial3: true, // Ativa o Material 3
              ),
              darkTheme: ThemeData(
                colorScheme: darkColorScheme,
                useMaterial3: true, // Ativa o Material 3
              ),
              home: Scaffold(
                appBar: AppBar(
                  title: Text('Byewall'),
                  actions: [
                    Builder(
                      builder:
                          (context) => IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                    ),
                  ],
                ),
                body: MainScreen(),
              ),
            );
          },
        );
      },
    );
  }
}
