# CSIS Info Package

Un package Flutter contenant toutes les informations officielles de l'entreprise CSIS (logo, services, coordonnées de contact) pour une intégration facile dans vos applications Flutter.

## 📱 Aperçu

Ce package fournit des widgets prêts à l'emploi pour afficher les informations de l'entreprise CSIS, incluant :
- Logo de l'entreprise
- Informations de contact (téléphone, email, adresse)
- Liste des services offerts
- Interface utilisateur cohérente et moderne

## 🚀 Installation

Ajoutez cette ligne à votre fichier `pubspec.yaml` :

```yaml
dependencies:
  csis_info: ^1.0.0
```

Puis exécutez :

```bash
flutter pub get
```

## 📖 Utilisation

### Import du package

```dart
import 'package:csis_info/csis_info.dart';
```

### Widgets disponibles

#### 1. Logo CSIS

```dart
CsisLogoWidget(
  width: 120,
  height: 120,
  fit: BoxFit.contain,
)
```

#### 2. Carte d'informations de l'entreprise

```dart
CsisInfoCard(
  showLogo: true,
  showDescription: true,
  logoSize: 80,
)
```

#### 3. Widget de contact

```dart
CsisContactWidget(
  showIcons: true,
  enableActions: true, 
)
```

#### 4. Liste des services

```dart
CsisServicesList(
  showFeatures: true,
  maxServices: 4, // Limite le nombre de services affichés
)
```

### 5. 🎮 Jeux Rétro

Le package inclut également une collection de jeux rétro classiques :

### Utilisation des jeux

```dart
import 'package:csis_info/csis_info.dart';
import 'package:csis_info/retro_games.dart';

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RetroGamesPage(); 
  }
}

### Utilisation simple (Recommandée)

```dart
import 'package:flutter/material.dart';
import 'package:csis_info/csis_info.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('À propos de CSIS')),
      body: SingleChildScrollView(
        child: CsisInfo(), 
      ),
    );
  }
}
```
### 5. 🎮 Jeux Rétro

Le package inclut également une collection de jeux integrer avec des plugins

### Utilisation des jeux

```dart
import 'package:csis_info/csis_info.dart';
import 'package:csis_info/retro_games.dart';

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RetroGamesPage(); 
  }
}

### Utilisation simple (Recommandée)

```dart
import 'package:flutter/material.dart';
import 'package:csis_info/csis_info.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('À propos de CSIS')),
      body: SingleChildScrollView(
        child: CsisInfo(), 
      ),
    );
  }
}
```

### Utilisation avec personnalisation

```dart
CsisInfo(
  showLogo: true,
  showDescription: true,
  showContacts: true,
  showServices: true,
  enableContactActions: true,
  logoSize: 100,
  style: CsisInfoStyle.elevated,
  maxServices: 3,
  showServiceFeatures: false,
)
```

### Styles disponibles

```dart
// Style avec carte (par défaut)
CsisInfo(style: CsisInfoStyle.card)

// Style avec carte élevée
CsisInfo(style: CsisInfoStyle.elevated)

// Style plat sans bordure
CsisInfo(style: CsisInfoStyle.flat)

// Style minimal avec bordure fine
CsisInfo(style: CsisInfoStyle.minimal)
```

## 🎨 Personnalisation

### Accéder aux données directement

```dart
// Informations de l'entreprise
final companyInfo = CsisConstants.companyInfo;

// Liste des contacts
final contacts = CsisConstants.contacts;

// Liste des services
final services = CsisConstants.services;

// Nom de l'entreprise
final companyName = CsisConstants.companyName;
```

### Créer vos propres widgets

```dart
class CustomCsisWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(CsisConstants.companyFullName),
        CsisLogoWidget(width: 60),
        Text('Contacts: ${CsisConstants.contacts.length}'),
      ],
    );
  }
}
```

## 📱 Fonctionnalités

- ✅ **Widgets prêts à l'emploi** - Interface cohérente et moderne
- ✅ **Actions automatiques** - Ouvre automatiquement téléphone, email, maps
- ✅ **Responsive design** - S'adapte à toutes les tailles d'écran
- ✅ **Personnalisable** - Options de configuration pour chaque widget
- ✅ **Gestion d'erreurs** - Affichage de fallback si les assets ne sont pas trouvés
- ✅ **Tests inclus** - Package entièrement testé
- ✅ **Documentation complète** - Exemples et guides d'utilisation

## 🏢 Informations CSIS

### Services proposés :
- Développement Web
- Développement Mobile  
- Consulting IT
- Maintenance & Support

### Contact :
- **Téléphone** : +1(240) 425-6583
- **Email** : contact@csis.tg
- **Adresse** : Lomé, Togo

### Lancer les tests

```bash
flutter test
```

### Lancer l'exemple

```bash
cd example
flutter run
```

## 📄 Licence

Ce package est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le projet
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📞 Support

Pour toute question ou problème :
- Créez une [issue](https://github.com/hackdave21/csis_info/issues)
- Contactez l'équipe CSIS directement

---

**Développé avec ❤️ par l'équipe CSIS**