import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Locataire extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int somme;

  Locataire({required this.name, required this.somme});
}