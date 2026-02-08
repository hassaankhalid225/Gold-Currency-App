import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'features/currency/presentation/currency_screen.dart';
import 'features/gold/presentation/gold_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/gold/data/gold_repository_impl.dart';
import 'features/gold/domain/gold_use_case.dart';
import 'features/gold/presentation/gold_controller.dart';
import 'features/currency/data/currency_repository_impl.dart';
import 'features/currency/domain/currency_use_case.dart';
import 'features/currency/presentation/currency_controller.dart';
import 'features/silver/data/silver_repository_impl.dart';
import 'features/silver/domain/silver_use_case.dart';
import 'features/silver/presentation/silver_controller.dart';
import 'features/silver/presentation/silver_screen.dart';
import 'features/home/data/home_repository_impl.dart';
import 'features/home/domain/home_use_case.dart';
import 'features/home/presentation/home_controller.dart';
import 'shared/themes/dark_theme.dart';
import 'shared/themes/light_theme.dart';
import 'shared/themes/theme_provider.dart';
import 'shared/providers/navigation_provider.dart';
import 'features/settings/presentation/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Load .env file here when implemented
  
  runApp(
    MultiProvider(
      providers: [ 
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => HomeController(
            GetDashboardDataUseCase(HomeRepositoryImpl()),
            GetGoldPriceUseCase(GoldRepositoryImpl()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GoldController(
            GetGoldPriceUseCase(GoldRepositoryImpl()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrencyController(
            CurrencyUseCase(CurrencyRepositoryImpl()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SilverController(
            GetSilverPriceUseCase(SilverRepositoryImpl()),
          ),
        ),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MyHomePage(),
        );
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
  late PageController _pageController;

  final List<Widget> _screens = const [
    HomeScreen(),
    GoldScreen(),
    SilverScreen(),
    CurrencyScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize PageController with current index
    final initialIndex = context.read<NavigationProvider>().selectedIndex;
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        // Sync PageController with Provider state
        if (_pageController.hasClients && 
            _pageController.page?.round() != navProvider.selectedIndex) {
           // Animate to new page
           WidgetsBinding.instance.addPostFrameCallback((_) {
             _pageController.animateToPage(
               navProvider.selectedIndex,
               duration: const Duration(milliseconds: 300),
               curve: Curves.easeInOut,
             );
           });
        }

        return Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swipe if desired, or use ClampingScrollPhysics
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_outline),
                activeIcon: Icon(Icons.star),
                label: 'Gold',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_on), // Or appropriate icon
                label: 'Silver',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.currency_exchange),
                label: 'Currency',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: navProvider.selectedIndex,
            onTap: (index) {
              navProvider.setIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
          ),
        );
      },
    );
  }
}
