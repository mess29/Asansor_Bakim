import 'package:asansor_bakim/data/models/elevator_model.dart';
import 'package:asansor_bakim/screens/edit_screens/elevator_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/add_elevator/add_elevator_screen.dart';
import 'screens/maintenance_list/maintenance_list_screen.dart';
import 'screens/add_maintenance/add_maintenance_screen.dart';
import 'package:asansor_bakim/services/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//8. aşama 4. Bildirim ve Dosya İzinleri adımında kaldım
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const ProviderScope(child: AsansorBakimTakipApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add_elevator',
      builder: (context, state) => const AddElevatorScreen(),
    ),
    GoRoute(
      path: '/maintenance_list/:elevatorId',
      builder: (context, state) {
        final elevatorId = state.pathParameters['elevatorId']!;
        return MaintenanceListScreen(elevatorId: elevatorId);
      },
    ),
    GoRoute(
      path: '/add_maintenance/:elevatorId',
      builder: (context, state) {
        final elevatorId = state.pathParameters['elevatorId']!;
        return AddMaintenanceScreen(elevatorId: elevatorId);
      },
    ),
    GoRoute(
      path: '/edit_elevator/:id',
      name: 'edit_elevator',
      pageBuilder: (context, state) {
        // Ekstra parametre olarak ElevatorModel instance göndermek için "extra" kullanılır
        final elevator = state.extra as ElevatorModel;
        return MaterialPage(
          child: ElevatorEditScreen(elevator: elevator),
        );
      },
    ),
  ],
);

class AsansorBakimTakipApp extends StatelessWidget {
  const AsansorBakimTakipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Asansör Bakım Takip',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
    );
  }
}
