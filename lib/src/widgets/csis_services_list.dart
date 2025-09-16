import 'package:flutter/material.dart';
import '../models/csis_service.dart';
import '../constants/csis_constants.dart';

class CsisServicesList extends StatelessWidget {
  final bool showFeatures;
  final EdgeInsetsGeometry? padding;
  final int maxServices;

  const CsisServicesList({
    super.key,
    this.showFeatures = true,
    this.padding,
    this.maxServices = -1,
  });

  @override
  Widget build(BuildContext context) {
    final services = maxServices > 0 
        ? CsisConstants.services.take(maxServices).toList()
        : CsisConstants.services;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nos Services',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...services.map((service) => 
              _buildServiceItem(context, service)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, CsisService service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            service.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          if (showFeatures && service.features.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: service.features.map((feature) => Chip(
                label: Text(
                  feature,
                  style: const TextStyle(fontSize: 12),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}