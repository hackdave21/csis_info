import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/csis_constants.dart';
import '../models/csis_contact.dart';
import '../models/csis_service.dart';
import 'package:heroicons/heroicons.dart';

class CsisInfo extends StatefulWidget {
  /// Afficher le logo CSIS
  final bool showLogo;
  
  /// Afficher la description de l'entreprise
  final bool showDescription;
  
  /// Afficher les informations de contact
  final bool showContacts;
  
  /// Afficher la liste des services
  final bool showServices;
  
  /// Activer les actions de contact (appel, email, maps)
  final bool enableContactActions;
  
  /// Taille du logo
  final double logoSize;
  
  /// Espacement entre les sections
  final double sectionSpacing;
  
  /// Padding général du widget
  final EdgeInsetsGeometry? padding;
  
  /// Style de présentation (card, flat, minimal)
  final CsisInfoStyle style;
  
  /// Nombre maximum de services à afficher (-1 pour tous)
  final int maxServices;
  
  /// Afficher les fonctionnalités des services
  final bool showServiceFeatures;

  const CsisInfo({
    super.key,
    this.showLogo = true,
    this.showDescription = true,
    this.showContacts = true,
    this.showServices = true,
    this.enableContactActions = true,
    this.logoSize = 100,
    this.sectionSpacing = 24,
    this.padding,
    this.style = CsisInfoStyle.card,
    this.maxServices = -1,
    this.showServiceFeatures = true,
  });

  @override
  State<CsisInfo> createState() => _CsisInfoState();
}

class _CsisInfoState extends State<CsisInfo> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildContent(),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    final children = <Widget>[];
    
    // Section logo et informations principales
    if (widget.showLogo || widget.showDescription) {
      children.add(_buildHeaderSection());
      children.add(SizedBox(height: widget.sectionSpacing));
    }
    
    // Section contacts
    if (widget.showContacts) {
      children.add(_buildContactSection());
      children.add(SizedBox(height: widget.sectionSpacing));
    }
    
    // Section services
    if (widget.showServices) {
      children.add(_buildServicesSection());
    }
    
    // Retirer le dernier espacement
    if (children.isNotEmpty && children.last is SizedBox) {
      children.removeLast();
    }

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );

    // Appliquer le padding
    if (widget.padding != null) {
      content = Padding(
        padding: widget.padding!,
        child: content,
      );
    } else if (widget.style != CsisInfoStyle.flat) {
      content = Padding(
        padding: const EdgeInsets.all(16),
        child: content,
      );
    }

    // Appliquer le style
    switch (widget.style) {
      case CsisInfoStyle.card:
        return Card(
          margin: EdgeInsets.zero,
          child: content,
        );
      case CsisInfoStyle.elevated:
        return Card(
          margin: EdgeInsets.zero,
          elevation: 8,
          child: content,
        );
      case CsisInfoStyle.flat:
        return content;
      case CsisInfoStyle.minimal:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color.lerp(Colors.grey, Colors.transparent, 0.8)!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: content,
        );
    }
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        if (widget.showLogo) ...[
          _buildLogo(),
          const SizedBox(height: 16),
        ],
        Text(
          CsisConstants.companyFullName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (widget.showDescription) ...[
          const SizedBox(height: 12),
          Text(
            CsisConstants.companyInfo.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: widget.logoSize,
      height: widget.logoSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          CsisConstants.logoAssetPath,
          package: 'csis_info',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: Color.lerp(Theme.of(context).primaryColor, Colors.transparent, 0.9)!,
                borderRadius: BorderRadius.circular(12),
              ),
              child: HeroIcon(
                HeroIcons.briefcase,
                size: widget.logoSize * 0.4,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Contactez-nous', Icons.contact_page),
        const SizedBox(height: 16),
        ...CsisConstants.contacts.map((contact) => 
          _buildContactItem(contact)),
      ],
    );
  }

  Widget _buildContactItem(CsisContact contact) {
    // L'adresse n'est pas cliquable
    bool isClickable = widget.enableContactActions && contact.type != 'address';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: isClickable ? () => _handleContactTap(contact) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color.lerp(Colors.grey, Colors.transparent, 0.8)!,
            ),
          ),
          child: Row(
            children: [
              _buildContactIcon(contact),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.displayName,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contact.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isClickable)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactIcon(CsisContact contact) {
    IconData iconData;
    Color iconColor;
    
    switch (contact.type) {
      case 'phone':
        iconData = Icons.phone;
        iconColor = Colors.green;
        break;
      case 'email':
        iconData = Icons.email;
        iconColor = Colors.blue;
        break;
      case 'address':
        iconData = Icons.location_on;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.info;
        iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.lerp(iconColor, Colors.transparent, 0.9)!,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildServicesSection() {
    final services = widget.maxServices > 0 
        ? CsisConstants.services.take(widget.maxServices).toList()
        : CsisConstants.services;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Nos Services', Icons.business_center),
        const SizedBox(height: 16),
        ...services.map((service) => _buildServiceItem(service)),
      ],
    );
  }

  Widget _buildServiceItem(CsisService service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color.lerp(Colors.grey, Colors.transparent, 0.8)!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.lerp(Theme.of(context).primaryColor, Colors.transparent, 0.9)!,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.star,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    service.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              service.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            // Gestion sécurisée de la propriété features
            if (widget.showServiceFeatures && _getServiceFeatures(service).isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _getServiceFeatures(service).map((feature) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color.lerp(Theme.of(context).primaryColor, Colors.transparent, 0.9)!,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color.lerp(Theme.of(context).primaryColor, Colors.transparent, 0.7)!,
                    ),
                  ),
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Méthode helper pour obtenir les features de manière sécurisée
  List<String> _getServiceFeatures(CsisService service) {
    try {
      // Tentative d'accès à la propriété features via reflection ou cast
      final dynamic dynamicService = service;
      if (dynamicService.features != null) {
        return List<String>.from(dynamicService.features);
      }
    } catch (e) {
      // Si la propriété n'existe pas ou génère une erreur, retourner une liste vide
      debugPrint('Warning: features property not found on CsisService');
    }
    return [];
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _handleContactTap(CsisContact contact) async {
    Uri? uri;
    
    switch (contact.type) {
      case 'phone':
        uri = Uri.parse('tel:${contact.value}');
        break;
      case 'email':
        uri = Uri.parse('mailto:${contact.value}');
        break;
      case 'address':
        // L'adresse n'ouvre plus de carte, juste afficher un message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Adresse: ${contact.value}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
    }

    if (uri != null) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Impossible d\'ouvrir ${contact.displayName}'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'ouverture de ${contact.displayName}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

/// Styles d'affichage disponibles pour CsisInfo
enum CsisInfoStyle {
  /// Style avec carte 
  card,
  
  /// Style avec carte élevée
  elevated,
  
  /// Style plat sans bordure
  flat,
  
  /// Style minimal avec bordure fine
  minimal,
}