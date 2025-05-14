import 'package:byewall3/break_services/services_model.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ServicesHelper {
  static const String _boxName = 'services';

  /// Abre o box do Hive
  static Future<Box<ServicesModel>> _openBox() async {
    return await Hive.openBox<ServicesModel>(_boxName);
  }

  /// Adiciona os serviços padrão, caso o box esteja vazio
  static Future<void> defaultServices() async {
    final box = await _openBox();
    if (box.isEmpty) {
      final defaultData = [
        ServicesModel(
          id: DateTime.now().millisecondsSinceEpoch,
          serviceName: '12ft.io',
          serviceUrl: 'https://12ft.io/',
          dateAdd: DateTime.now(),
        ),
        ServicesModel(
          id: DateTime.now().millisecondsSinceEpoch + 1,
          serviceName: 'Remove Paywall',
          serviceUrl: 'https://www.removepaywall.com/search?url=',
          dateAdd: DateTime.now(),
        ),
        ServicesModel(
          id: DateTime.now().millisecondsSinceEpoch + 2,
          serviceName: 'smry',
          serviceUrl: 'https://smry.ai/',
          dateAdd: DateTime.now(),
        ),
        ServicesModel(
          id: DateTime.now().millisecondsSinceEpoch + 3,
          serviceName: 'Internet Archive',
          serviceUrl: 'https://web.archive.org/web/',
          dateAdd: DateTime.now(),
        ),
      ];
      await box.addAll(defaultData);
    }
  }

  /// Adiciona um novo serviço
  static Future<void> addService(ServicesModel service) async {
    final box = await _openBox();
    await box.add(service);
  }

  /// Remove um serviço individual pelo ID
  static Future<void> removeService(int key) async {
    final box = await _openBox();
    await box.delete(key);
  }

  /// Apaga todos os registros
  static Future<void> clearAllServices() async {
    final box = await _openBox();
    await box.clear();
  }

  /// Obtém todos os serviços
  static Future<List<ServicesModel>> getAllServices() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// Atualiza um serviço existente
  static Future<void> updateService(ServicesModel updatedService) async {
    final box = await _openBox();
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.id == updatedService.id,
      orElse: () => null,
    );

    if (key != null) {
      await box.put(key, updatedService);
    }
  }
}
