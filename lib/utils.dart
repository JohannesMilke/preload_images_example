import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class Utils {
  static Future cacheImage(BuildContext context, String urlImage) =>
      precacheImage(
        AdvancedNetworkImage(
          urlImage,
          useDiskCache: true,
          cacheRule: CacheRule(maxAge: const Duration(days: 7)),
        ),
        context,
      );
}
