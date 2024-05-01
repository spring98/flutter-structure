import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:structure/config/di/di_setup.dart';
import 'package:structure/config/route/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:structure/core/utils/cipher/index.dart';
import 'package:structure/feature/image/data/model/entity/image_entity.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// DI Injection Config
  configureDependencies();

  /// Hive(Local Database) Config
  await Hive.initFlutter();
  Hive.registerAdapter(ImageEntityAdapter());

  await Cipher.instance.initKeys();

  runApp(
    MaterialApp.router(
      routerConfig: kRouter,
    ),
  );
}
