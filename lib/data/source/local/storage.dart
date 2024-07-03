import 'dart:io';

import 'package:fpdart/fpdart.dart';

Effect<Directory, Null, Null> write(String contents) =>
    Effect<Directory, Null, Null>.gen(($) {
      final appDocumentsDir = $.sync<Directory>(Effect.env()),
          path = appDocumentsDir.path,
          file = File('$path/${DateTime.now().millisecondsSinceEpoch}.csv');
      file.writeAsString(contents);
    });
