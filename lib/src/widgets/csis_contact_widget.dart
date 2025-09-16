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
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...CsisConstants.contacts.map(
              (contact) => _buildContactItem(context, contact),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, CsisContact contact) {
    final bool isActionable = enableActions && contact.type != 'address';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: isActionable ? () => _handleContactTap(contact) : null,
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
              if (isActionable)
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
    Color iconColor = Theme.of(context).primaryColor;

    switch (contact.type) {
      case 'phone':
        iconData = Icons.phone;
        break;
      case 'email':
        iconData = Icons.email;
        break;
      case 'address':
        iconData = Icons.location_on;
        iconColor = Colors.grey[600] ?? Colors.grey;
        break;
      default:
        iconData = Icons.info;
    }

    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: contact.type == 'address'
            ? Colors.grey[100]
            : Color.lerp(primaryColor, Colors.transparent, 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor, size: 20),
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
        return;
    }

    if (uri != null) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      } catch (e) {
        debugPrint('Impossible d\'ouvrir le lien: $e');
      }
    }
  }
}
