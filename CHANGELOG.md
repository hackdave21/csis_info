# Changelog

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-15

### Ajouté
- Widget `CsisLogoWidget` pour l'affichage du logo CSIS
- Widget `CsisInfoCard` pour les informations générales de l'entreprise
- Widget `CsisContactWidget` avec actions automatiques (téléphone, email, maps)
- Widget `CsisServicesList` pour afficher les services de l'entreprise
- Modèles de données : `CsisCompanyInfo`, `CsisContact`, `CsisService`
- Constantes centralisées dans `CsisConstants`
- Support des actions de contact (appel, email, localisation)
- Gestion d'erreurs pour les assets manquants
- Documentation complète avec exemples
- Tests unitaires et d'intégration
- Application d'exemple fonctionnelle

### Fonctionnalités
- Interface utilisateur moderne et responsive
- Thématisation automatique selon le thème de l'application
- Configuration flexible pour chaque widget
- Optimisé pour les performances
- Compatible avec Flutter 3.0+
