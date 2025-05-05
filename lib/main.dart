import 'package:byewall3/screens/home_screen.dart';
import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/providers/language_provider.dart';
import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
  await themeProvider.loadBlackBackground();
  await themeProvider.loadAppThemeMode();
  await themeProvider.loadDynamicColor(); // <-- Adicione isto

  final languageProvider = LanguageProvider();
  await languageProvider.loadLanguage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeProvider),
        ChangeNotifierProvider(create: (context) => languageProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemeMode appThemeMode = AppThemeMode.dynamic;

  ThemeData fixedTheme(Brightness brightness, Color seed) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: brightness,
      ),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final themeProvider = Provider.of<ThemeProvider>(
          context,
          listen: false,
        );
        // Salve a cor dinâmica detectada, se disponível
        if (lightDynamic != null) {
          themeProvider.saveDynamicColor(lightDynamic.primary);
        }
        return Consumer2<ThemeProvider, LanguageProvider>(
          builder: (context, themeProvider, languageProvider, child) {
            late ThemeData lightTheme;
            late ThemeData darkTheme;

            // Substitua appThemeMode por themeProvider.appThemeMode
            if (themeProvider.appThemeMode == AppThemeMode.dynamic &&
                lightDynamic != null &&
                darkDynamic != null) {
              lightTheme = ThemeData(
                colorScheme: lightDynamic,
                useMaterial3: true,
              );
              darkTheme = ThemeData(
                colorScheme: darkDynamic,
                useMaterial3: true,
              );
            } else {
              final seed =
                  AppColors.seeds[themeProvider.appThemeMode] ??
                  Colors.deepPurple;
              lightTheme = fixedTheme(Brightness.light, seed);
              darkTheme = fixedTheme(Brightness.dark, seed);
            }

            // ADIÇÃO CRUCIAL: Aplicar fundo preto se necessário
            if (themeProvider.useBlackBackground) {
              darkTheme = darkTheme.copyWith(
                colorScheme: darkTheme.colorScheme.copyWith(
                  surface: Colors.black,
                  // background: Colors.black, // importante!
                ),
                scaffoldBackgroundColor: Colors.black, // aplica no Scaffold
                canvasColor:
                    Colors
                        .black, // aplica em backgrounds de diálogos, menus, etc.
                cardColor:
                    Colors.black, // opcional, se quiser cards pretos também
              );
            }

            return MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: languageProvider.locale,
              title: 'Byewall',
              themeMode: themeProvider.themeMode,
              theme: lightTheme,
              darkTheme: darkTheme, // Tema escuro modificado
              home: HomeScreen(
                selectedMode:
                    themeProvider.appThemeMode, // use o valor do provider
                onThemeSelected: (mode) {
                  themeProvider.setAppThemeMode(
                    mode,
                  ); // Atualize o provider e salve
                },
                seeds: AppColors.seeds,
              ),
            );
          },
        );
      },
    );
  }
}
