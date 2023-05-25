import 'dart:typed_data';
import 'package:hive/hive.dart';

// part 'invoice.g.dart';

@HiveType(typeId: 0)
class Invoice extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  Uint8List pdf;

  Invoice({required this.id, required this.pdf, required this.name});
}

