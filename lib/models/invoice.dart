import 'dart:typed_data';
import 'package:hive/hive.dart';

// part 'invoice.g.dart';

@HiveType(typeId: 0)
class Invoice extends HiveObject {
  @HiveField(0)
  Uint8List pdf;

  @HiveField(1)
  String name;

  Invoice({required this.pdf, required this.name});
}

