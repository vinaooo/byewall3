import 'package:byewall3/break_services/services_model.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class DefaultServicesProvider {
  static void defaultServices(Box<ServicesModel> box) {
    if (box.isEmpty) {
      final dadosPadrao = [
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
          id: DateTime.now().millisecondsSinceEpoch + 1,
          serviceName: 'smry',
          serviceUrl: 'https://smry.ai/',
          dateAdd: DateTime.now(),
        ),
        ServicesModel(
          id: DateTime.now().millisecondsSinceEpoch + 1,
          serviceName: 'Internet Archive',
          serviceUrl: 'https://web.archive.org/web/',
          dateAdd: DateTime.now(),
        ),
      ];
      box.addAll(dadosPadrao);
    }
  }
}
