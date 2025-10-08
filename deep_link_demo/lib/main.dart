import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String _status = 'Waiting for link...';
  Uri? _pendingUri; // simpan link kalau navigator belum siap

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle cold start
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      // simpan dulu, nanti dijalankan setelah build
      _pendingUri = initialUri;
    }

    // Listen for links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) => _handleIncomingLink(uri),
      onError: (err) {
        setState(() => _status = 'Failed to receive link: $err');
      },
    );
  }

  void _handleIncomingLink(Uri uri) {
    setState(() => _status = 'Received link: $uri');

    // Jalankan setelah frame siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_navigatorKey.currentState == null) {
        // kalau navigator belum siap, simpan dulu
        _pendingUri = uri;
        return;
      }

      if (uri.host == 'details') {
        final id = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : 'unknown';
        _navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => DetailScreen(id: id)),
        );
      } else if (uri.host == 'profile') {
        final username =
            uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : 'guest';
        _navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => ProfileScreen(username: username)),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Jika ada pending link dari cold start, jalankan setelah UI siap
    if (_pendingUri != null) {
      final uri = _pendingUri!;
      _pendingUri = null;
      Future.delayed(Duration(milliseconds: 100), () => _handleIncomingLink(uri));
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Link Demo (app_links)',
      navigatorKey: _navigatorKey,
      home: HomeScreen(status: _status),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String status;
  const HomeScreen({required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Text(
          status,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(child: Text('You opened item ID: $id')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String username;
  const ProfileScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(child: Text('Hello, $username!')),
    );
  }
}
