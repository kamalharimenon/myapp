import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:myapp/add_orchid_screen.dart';
import 'package:myapp/models/orchid_model.dart';
import 'package:myapp/orchid_detail_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// --- Router Configuration ---
GoRouter _createRouter(List<Orchid> orchids) {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return MyHomePage(
              orchidCollection: orchids,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'add',
              pageBuilder: (context, state) {
                final collection = state.extra as List<Orchid>? ?? [];
                return CustomTransitionPage<void>(
                  child: AddOrchidScreen(
                    existingOrchids: collection,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              },
            ),
            GoRoute(
              path: 'orchid/:name',
              builder: (BuildContext context, GoRouterState state) {
                final orchid = state.extra as Orchid;
                return OrchidDetailScreen(orchid: orchid);
              },
            ),
          ]),
    ],
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Orchid> _orchidCollection = [];
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = _createRouter(_orchidCollection);
  }

  void _addOrchid(Orchid orchid) {
    setState(() {
      _orchidCollection.add(orchid);
      _router.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Color(0xFFC75E9A); // A pink from the orchid

    final TextTheme appTextTheme = TextTheme(
      displaySmall: GoogleFonts.dancingScript(
          fontSize: 42, fontWeight: FontWeight.bold),
      headlineMedium:
          GoogleFonts.raleway(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge:
          GoogleFonts.raleway(fontSize: 22, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.raleway(fontSize: 16, height: 1.5),
      labelLarge: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w500),
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primarySeedColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: appTextTheme.labelLarge,
        elevation: 8,
        shadowColor: primarySeedColor.withOpacity(0.6),
      ),
    );

    final cardTheme = CardThemeData(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );

    // --- Light Theme ---
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      cardTheme: cardTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primarySeedColor),
        titleTextStyle:
            appTextTheme.titleLarge?.copyWith(color: primarySeedColor),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F5F7),
    );

    // --- Dark Theme (Corrected) ---
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: primarySeedColor,
      brightness: Brightness.dark,
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      textTheme: appTextTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      cardTheme: cardTheme.copyWith(
        shadowColor: primarySeedColor.withOpacity(0.3),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkColorScheme.primary),
        titleTextStyle:
            appTextTheme.titleLarge?.copyWith(color: darkColorScheme.primary),
      ),
      scaffoldBackgroundColor: const Color(0xFF1C1B1F),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          routerConfig: _router,
          title: 'Orchid Keeper',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Orchid> orchidCollection;
  const MyHomePage({super.key, required this.orchidCollection});

  void _navigateToAddOrchid(BuildContext context) {
    context.push('/add', extra: orchidCollection);
  }

  void _navigateToDetail(BuildContext context, Orchid orchid) {
    context.push('/orchid/${orchid.name}', extra: orchid);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(
          'assets/images/orchidkeeper.png',
          height: 90,
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.light
                ? [const Color(0xFFF8F5F7), const Color(0xFFF0E6EE)]
                : [const Color(0xFF1C1B1F), const Color(0xFF2C2B2F)],
          ),
        ),
        child: orchidCollection.isEmpty
            ? _buildEmptyState(context)
            : _buildCollectionList(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddOrchid(context),
        tooltip: 'Add Orchid',
        child: const Icon(Icons.add),
      ).animate().scale(delay: 500.ms, duration: 300.ms),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Your Collection Awaits',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Start your digital orchidarium by adding your very first plant.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.8)),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddOrchid(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add First Orchid'),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
      ),
    );
  }

  Widget _buildCollectionList(BuildContext context) {
    return Animate(
      effects: const [FadeEffect(duration: Duration(milliseconds: 500))],
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 100, bottom: 80),
        itemCount: orchidCollection.length,
        itemBuilder: (context, index) {
          final orchid = orchidCollection[index];
          return Card(
            child: ListTile(
              onTap: () => _navigateToDetail(context, orchid),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(Icons.local_florist_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 30),
              title: Text(orchid.name,
                  style: Theme.of(context).textTheme.headlineMedium),
              subtitle: Text(orchid.genus,
                  style: Theme.of(context).textTheme.bodyLarge),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 100 * index), duration: 500.ms).slideX(begin: -0.2, end: 0);
        },
      ),
    );
  }
}
