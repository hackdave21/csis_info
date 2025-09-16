import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/csis_contact.dart';
import '../constants/csis_constants.dart';

class CsisContactWidget extends StatelessWidget {
  final bool showIcons;
  final bool enableActions;
  final EdgeInsetsGeometry? padding;

  const CsisContactWidget({
    super.key,
    this.showIcons = true,
    this.enableActions = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contactez-nous',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...CsisConstants.contacts
                .map((contact) => _buildContactItem(context, contact)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, CsisContact contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: enableActions ? () => _handleContactTap(contact) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              if (showIcons) ...[
                _buildContactIcon(context, contact),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.displayName,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Text(
                      contact.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              if (enableActions)
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

 
  Widget _buildContactIcon(BuildContext context, CsisContact contact) {
    IconData iconData;
    switch (contact.type) {
      case 'phone':
        iconData = Icons.phone;
        break;
      case 'email':
        iconData = Icons.email;
        break;
      case 'address':
        iconData = Icons.location_on;
        break;
      default:
        iconData = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: Theme.of(context).primaryColor,
        size: 20,
      ),
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
        uri = Uri.parse('https://maps.google.com/?q=${contact.value}');
        break;
    }

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}