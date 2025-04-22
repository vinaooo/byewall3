import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/screens/main_screen.dart';
import 'package:byewall3/screens/settings_screen.dart';
import 'package:byewall3/ui/theme_provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); //

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
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
              supportedLocales: const [
                Locale('en'),
                Locale('es'),
                Locale('pt'),
              ],
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
              home: MyHomePage(),
            );
          },
        );
        // final ColorScheme lightColorScheme =
        //     lightDynamic ??
        //     ColorScheme.fromSeed(seedColor: Colors.green.shade800);
        // final ColorScheme darkColorScheme =
        //     darkDynamic ??
        //     ColorScheme.fromSeed(
        //       seedColor: Colors.green.shade800,
        //       brightness: Brightness.dark,
        //     );

        // return MaterialApp(
        //   localizationsDelegates: const [
        //     AppLocalizations.delegate,
        //     GlobalMaterialLocalizations.delegate,
        //     GlobalWidgetsLocalizations.delegate,
        //     GlobalCupertinoLocalizations.delegate,
        //   ],
        //   supportedLocales: const [Locale('en'), Locale('es'), Locale('pt')],
        //   title: 'Byewall',
        //   theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        //   darkTheme: ThemeData(
        //     useMaterial3: true,
        //     colorScheme: darkColorScheme,
        //   ),
        //   themeMode: ThemeMode.system,
        //   home: const MyHomePage(),
        // );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.translate('byewall') ?? "Byewall",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: MainScreen(),
    );
  }
}
