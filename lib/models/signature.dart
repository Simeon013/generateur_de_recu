import 'dart:typed_data';

import 'package:hive/hive.dart';

// part 'signature.g.dart';

@HiveType(typeId: 1)
class Signature extends HiveObject {
  @HiveField(0)
  late Uint8List imageBytes;

  Signature(this.imageBytes);
}