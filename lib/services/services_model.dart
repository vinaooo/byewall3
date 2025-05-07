import 'package:hive/hive.dart';

part 'services_model.g.dart';

@HiveType(typeId: 0)
class ServicesModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String serviceName;

  @HiveField(2)
  DateTime dateAdd;

  ServicesModel({
    required this.id,
    required this.serviceName,
    required this.dateAdd,
  });
}
