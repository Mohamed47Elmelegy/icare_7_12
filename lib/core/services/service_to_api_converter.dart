import 'package:icare/features/categories/data/models/services.dart';

class ServiceToApiConverter {
  static List<Map<String, dynamic>> convertServicesToPayload(
    List<ServicesModel> services,
  ) {
    return services
        .map((service) => {
              'id': service.id,
              'value': service.value,
            })
        .toList();
  }

  static Map<String, dynamic> convertServiceToPayload(ServicesModel service) {
    return {
      'id': service.id,
      'value': service.value,
    };
  }
}
