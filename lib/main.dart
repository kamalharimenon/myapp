import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orchid Keeper',
      theme: ThemeData(
        primarySwatch: Colors.green, // Using green as a primary color for a plant app
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // This will eventually hold the list of orchids
  final List<String> _orchidCollection = []; 

  void _navigateToAddOrchid() {
    // TODO: Implement navigation to Add Orchid screen
    // For now, just show a message or navigate to a placeholder screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigate to Add Orchid Screen (Coming Soon)!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orchid Keeper'),
        centerTitle: true,
      ),
      body: _orchidCollection.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Your orchid collection is empty.',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _navigateToAddOrchid,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Your First Orchid'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _orchidCollection.length,
              itemBuilder: (context, index) {
                // TODO: Display orchid details here
                return ListTile(
                  title: Text(_orchidCollection[index]),
                  // Add more details or leading/trailing widgets here
                );
              },
            ),
      floatingActionButton: _orchidCollection.isNotEmpty
          ? FloatingActionButton(
              onPressed: _navigateToAddOrchid,
              tooltip: 'Add Orchid',
              child: const Icon(Icons.add),
            )
          : null, // Hide FAB if collection is empty (the button in the center is shown instead)
    );
  }
}
