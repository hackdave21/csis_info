import 'package:csis_info/src/models/csis_contact.dart';
import 'package:csis_info/src/models/csis_service.dart';

class CsisCompanyInfo {
  final String name;
  final String description;
  final String address;
  final String logoAssetPath;
  final List<CsisContact> contacts;
  final List<CsisService> services;
  final Map<String, String> socialMedia;

  const CsisCompanyInfo({
    required this.name,
    required this.description,
    required this.address,
    required this.logoAssetPath,
    required this.contacts,
    required this.services,
    this.socialMedia = const {},
  });
}
