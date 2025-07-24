import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:myapp/add_orchid_screen.dart';
import 'package:myapp/models/orchid_model.dart';
import 'package:myapp/orchid_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:myapp/services/firestore_service.dart'; // Import FirestoreService
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
                // Pass existing orchids fetched from the stream
                return CustomTransitionPage<void>(
                  child: const AddOrchidScreen(), // Pass the data here
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              },
            ),
            GoRoute(
              path: 'orchid/:id', // Use ID instead of name for navigation
              builder: (BuildContext context, GoRouterState state) {
                
                // You'll need to fetch the orchid by ID here or pass it
                // For now, I'll keep the extra parameter assumption, but this needs refinement
                final orchid = state.extra as Orchid; // This will need to change
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
  final FirestoreService _firestoreService = FirestoreService(); // Instantiate FirestoreService

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
        shadowColor: primarySeedColor.withAlpha(153),
      ),
    );

    final cardTheme = CardThemeData(
      elevation: 8,
      shadowColor: Colors.black.withAlpha(77),
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
        shadowColor: primarySeedColor.withAlpha(77),
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

    // Use a StreamBuilder to listen for changes from Firestore
    return StreamBuilder<List<Orchid>>(
      stream: _firestoreService.getOrchids(),
      builder: (context, snapshot) {
        List<Orchid> orchids = snapshot.data ?? [];
        GoRouter router = _createRouter(orchids);
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp.router(
              routerConfig: router,
              title: 'Orchid Keeper',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeProvider.themeMode,
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Orchid> orchidCollection;
  const MyHomePage({super.key, required this.orchidCollection});

  void _navigateToAddOrchid(BuildContext context) {
    context.push('/add'); // No longer passing existing orchids
  }

  void _navigateToDetail(BuildContext context, Orchid orchid) {
    // Pass the orchid object directly for now. 
    // Fetching by ID in the detail screen would be more robust.
    context.push('/orchid/${orchid.id}', extra: orchid);
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
                      .withAlpha(204)),
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
