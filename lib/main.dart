import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/screens/main_screen.dart';
import 'package:byewall3/screens/settings_screen/settings_screen.dart';
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
  await themeProvider.loadAppThemeMode(); // <-- Adicione esta linha

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

class HomeScreen extends StatelessWidget {
  final AppThemeMode selectedMode;
  final ValueChanged<AppThemeMode> onThemeSelected;
  final Map<AppThemeMode, Color> seeds;

  const HomeScreen({
    super.key,
    required this.selectedMode,
    required this.onThemeSelected,
    required this.seeds,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Byewall'),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () async {
                    await Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder:
                            (context) => SettingsScreen(
                              selectedMode:
                                  themeProvider.appThemeMode, // use o provider
                              onThemeSelected: onThemeSelected,
                              seeds: seeds,
                            ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      body: MainScreen(),
    );
  }
}
