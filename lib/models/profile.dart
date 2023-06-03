import 'dart:typed_data';

import 'package:hive/hive.dart';

// part 'signature.g.dart';

@HiveType(typeId: 0)
class Profile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  int tel;

  @HiveField(3)
  String adress;

  @HiveField(4)
  late Uint8List imageBytes;

  Profile({required this.name, required this.email, required this.tel, required this.adress, required this.imageBytes});

  // Profile(
  //     this.name, this.email, this.tel, this.adress, this.imageBytes,
  //     );
}
