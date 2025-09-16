import 'package:flutter/material.dart';
import '../constants/csis_constants.dart';

class CsisLogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const CsisLogoWidget({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      CsisConstants.logoAssetPath,
      package: 'csis_info',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width ?? 100,
          height: height ?? 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.business, size: 40, color: Colors.grey),
        );
      },
    );
  }
}
