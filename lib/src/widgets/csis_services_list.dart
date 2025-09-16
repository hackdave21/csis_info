import 'package:flutter/material.dart';
import '../models/csis_service.dart';
import '../constants/csis_constants.dart';

class CsisServicesList extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final int maxServices;
  final bool shrinkWrap;

  const CsisServicesList({
    super.key,
    this.padding,
    this.maxServices = -1,
    this.shrinkWrap = false,
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
        child: shrinkWrap
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Nos Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...services.map(
                    (service) => _buildServiceItem(context, service),
                  ),
                ],
              )
            : SingleChildScrollView(
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
                    ...services.map(
                      (service) => _buildServiceItem(context, service),
                    ),
                  ],
                ),
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            service.description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            maxLines: shrinkWrap ? 2 : null,
            overflow: shrinkWrap ? TextOverflow.ellipsis : TextOverflow.visible,
          ),
        ],
      ),
    );
  }
}
