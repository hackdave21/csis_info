import 'package:flutter/material.dart';
import '../constants/csis_constants.dart';
import 'csis_logo_widget.dart';

class CsisInfoCard extends StatelessWidget {
  final bool showLogo;
  final bool showDescription;
  final EdgeInsetsGeometry? padding;
  final double? logoSize;

  const CsisInfoCard({
    super.key,
    this.showLogo = true,
    this.showDescription = true,
    this.padding,
    this.logoSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showLogo) ...[
              CsisLogoWidget(width: logoSize, height: logoSize),
              const SizedBox(height: 16),
            ],
            Text(
              CsisConstants.companyFullName,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (showDescription) ...[
              const SizedBox(height: 8),
              Text(
                CsisConstants.companyInfo.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
