import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:mtwin_send2tm/bloc/dmdk_bloc/dmdk_bloc.dart';
import 'package:mtwin_send2tm/bloc/ticket_bloc/ticket_bloc.dart';
import 'dart:ui';

import 'package:mtwin_send2tm/repositories/dmdk_repository.dart';
import 'package:mtwin_send2tm/repositories/ticket_repository.dart';
import 'package:mtwin_send2tm/screens/health_request_screen.dart';
import 'package:mtwin_send2tm/screens/main_screen.dart';
// import 'package:mtwin_send2tm/screens/ticket_details_content.dart';
import 'package:mtwin_send2tm/screens/ticket_details_screen.dart';
import 'package:mtwin_send2tm/screens/ticket_search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  // final config = await AppConfig.forEnvironment();
  final logger = Logger(printer: PrettyPrinter());

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DmdkRepository>(
          create: (context) => DmdkRepository(),
        ),

        RepositoryProvider<TicketRepository>(
          create: (context) => TicketRepository(),
        ),
      ],

      child: MultiBlocProvider(
        providers: [
          BlocProvider<DmdkBloc>(
            create: (ctx) {
              //logger.i('dmdkService has started');
              final dmdkRepository = RepositoryProvider.of<DmdkRepository>(ctx);
              return DmdkBloc(dmdkRepository: dmdkRepository)
                ..add(DmdkInitialEvent());
            },
            lazy: false,
          ),
          BlocProvider<TicketBloc>(
            create: (ctx) {
              //logger.i('ticketService has started');
              final ticketRepository = RepositoryProvider.of<TicketRepository>(
                ctx,
              );
              return TicketBloc(ticketRepository: ticketRepository)
                ..add(const TicketInitialEvent(envi: 'PROD'));
            },
            lazy: false,
          ),
        ],
        child: MyApp(
          //authRepository: authRepository,
          logger: logger,
          //isarServiceRepository: isarServiceRepository,
        ),
      ),
    ),
  );
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        //return const MainScreen();
        return const TicketSearchScreen();
      },
    ),
    GoRoute(
      path: '/health',
      builder: (BuildContext context, GoRouterState state) {
        return const HealthRequestScreen();
      },
    ),
    GoRoute(
      name: "ticketdetail",
      path: '/ticketDetail/:ticketObjectId',
      builder: (BuildContext context, GoRouterState state) {
        return TicketDetailsScreen(
          ticketObjectId: state.pathParameters['ticketObjectId']!,
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  //final AuthRepository authRepository;

  final Logger logger;
  //final IsarService isarServiceRepository;
  const MyApp({
    Key? key,

    //  required this.authRepository,
    required this.logger,
    //required this.isarServiceRepository
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // if (context.watch<AuthenticationBloc>().state is AuthenticationLoading) {
    //   context
    //       .read<AuthenticationBloc>()
    //       .add(GetEnvironmentVarEvent(envi: config.currentEnvironment));
    //   //context.read<CashboxBloc>().add(CashboxFirstLoad());
    // }
    // if (context.watch<CompanyBloc>().state
    //     is CompanyAllDmdkDictsSuccessfullyLoadedState) {
    //   context.read<DmdkBloc>().add(RequestToSetStunnelConfigParamsEvent(
    //       stunnelPort: config.stunnelPort,
    //       certificateSerial: config.certificateSerial));
    // }
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ru', 'RU'),
      theme: ThemeData(fontFamily: 'Rubik', primarySwatch: Colors.blueGrey),
    );
  }
}
