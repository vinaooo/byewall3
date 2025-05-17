import 'package:hive_ce/hive.dart';

part 'services_model.g.dart';

@HiveType(typeId: 0)
class ServicesModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String serviceName;

  @HiveField(2)
  String serviceUrl;

  @HiveField(3)
  DateTime dateAdd;

  @HiveField(4)
  bool isEnable;

  ServicesModel({
    required this.id,
    required this.serviceName,
    required this.serviceUrl,
    required this.dateAdd,
    this.isEnable = true,
  });
}
