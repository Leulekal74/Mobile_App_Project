import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_session.dart';

class TibebArchiveApp extends StatefulWidget{
 const TibebArchiveApp({super.key});

 @override
  State<TibebArchiveApp> createState() => _TibebArchiveAppState();
}

class _TibebArchiveAppState extends State<TibebArchiveApp>{
    late final AuthSession _session;
    late final AppRouter _appRouter;
 @override
 void initState() {
    super.initState();
     _session = AuthSession();
    _appRouter = AppRouter(_session);
 }
 @override
 Widget build(BuildContext context) {
    return AuthSessionScope(
      session: _session,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'TibebArchive',
        theme: AppTheme.light(),
        routerConfig: _appRouter.router,
      ),
    );
  }
}
