import '../models/csis_company_info.dart';
import '../models/csis_contact.dart';
import '../models/csis_service.dart';

class CsisConstants {
  // informations de base
  static const String companyName = 'CSIS';
  static const String companySlogan = 'Your Security is our commitment';
  static const String companyFullName =
      'CSIS - Cyber and System Information Solutions';
  static const String logoAssetPath = 'assets/images/csis_logo.png';

  // contacts
  static const List<CsisContact> contacts = [
    CsisContact(
      type: 'phone',
      value: '+1(240) 425-6583',
      displayName: 'Téléphone',
      icon: 'assets/icons/phone.png',
    ),
    CsisContact(
      type: 'email',
      value: 'contact@csistg.com',
      displayName: 'Email',
      icon: 'assets/icons/email.png',
    ),
    CsisContact(
      type: 'address',
      value: 'Washington, DC',
      displayName: 'Adresse',
      icon: 'assets/icons/location.png',
    ),
  ];

  // services
  static const List<CsisService> services = [
    CsisService(
      name: "Informatique d'entreprise",
      description:
          "CSIS se concentre sur les utilisateurs et propose un centre-ville zéro pour une plus grande productivité. Le CSIS apporte des stratégies, des approches et des outils innovants pour atteindre les objectifs de l'entreprise. Il englobe une large gamme de matériels, de logiciels, de réseaux et de services spécialement conçus pour répondre aux besoins d'une organisation de grande taille",
    ),
    CsisService(
      name: "Opérations d'infrastructure",
      description:
          "CSIS assure la gestion des infrastructures, les opérations quotidiennes et les activités de maintenance. Nos approches impliquent la supervision des systèmes, des réseaux, du matériel, des logiciels et du stockage des données qui sont essentiels aux opérations quotidiennes d'une organisation. Les principaux objectifs ici incluent la maintenance et le support, l'optimisation des performances, la planification des capacités, l'automatisation et l'innovation",
    ),
    CsisService(
      name: 'Cloud computing',
      description:
          "Nous préparons les applications pour le cloud et les migrons vers le cloud. CSIS fournit des services informatiques, notamment des serveurs, du stockage, des bases de données, des réseaux, des logiciels, des analyses, etc. Ce service permet aux particuliers et aux entreprises d'accéder et d'utiliser des ressources et des applications sans avoir besoin d'une infrastructure ou de matériel sur site",
    ),
    CsisService(
      name: 'Transformation Digitale',
      description:
          "Cela commence par notre architecture Zero Trust et la transformation du déploiement des applications par la modernisation et l'optimisation.La transformation numérique fait référence à l'intégration de la technologie numérique dans tous les aspects d'une entreprise, entraînant des changements fondamentaux dans la façon dont les organisations fonctionnent et offrent de la valeur aux clients. Pour le SCRS, il ne s'agit pas seulement d'adopter de nouvelles technologies, mais cela implique également un changement culturel, une restructuration des opérations et un changement dans la façon dont les entreprises pensent et fonctionnent",
    ),
    CsisService(
      name: 'Développement de logiciels',
      description:
          "Le CSIS conçoit et fournit des logiciels via des pipelines d'intégration et de déploiement continus. Son processus complet englobe la création, la conception, la programmation, les tests, la documentation et la maintenance d'applications. Une équipe spécialisée définit d'abord la portée et les exigences du projet, puis élabore un plan détaillé. Ensuite, les développeurs transforment ces spécifications en code lors de la phase de mise en œuvre, avant de procéder à des tests rigoureux et à un déploiement en production pour les utilisateurs finaux",
    ),
    CsisService(
      name: 'La cyber-sécurité',
      description:
          "L'engagement du SCRS est de vous protéger, vous et votre organisation, contre les cyberattaques. Nous effectuons la conformité informatique, des audits et effectuons des tests d'intrusion pour garantir votre sécurité",
    ),
  ];

  // réseaux sociaux
  static const Map<String, String> socialMedia = {
    'website': 'http://www.csis.tg/',
    'linkedin':
        'https://www.linkedin.com/company/cyber-system-information-solutiions/posts/?feedView=all',
  };

  // informations complètes de csis
  static const CsisCompanyInfo companyInfo = CsisCompanyInfo(
    name: companyName,
    description:
        "Le CSIS est l'un des principaux fournisseurs de technologies avancées de cybersécurité pour faire la différence dans les questions de sécurité nationale et mondiale. Nous fournissons une expertise en sécurité à diverses institutions publiques et privées. L'objectif principal du CSIS est de protéger les données d'information des systèmes grâce à des solutions innovantes sans ingénieurs de sécurité hautement qualifiés, experts en conformité, testeurs d'intrusion, infrastructures, ingénieurs réseau et ingénieurs logiciels",
    address: 'Washington, DC',
    logoAssetPath: logoAssetPath,
    contacts: contacts,
    services: services,
    socialMedia: socialMedia,
  );
}
