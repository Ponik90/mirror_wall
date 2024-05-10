import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirror_wall/screen/home/provider/home_provider.dart';
import 'package:mirror_wall/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: HomeProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: screen,
      ),
    ),
  );
}
