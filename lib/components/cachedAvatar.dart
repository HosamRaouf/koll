import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart'; // Added for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles.dart';

class CachedAvatar extends StatelessWidget {
  final String imageUrl; // Made final
  final BoxFit? fit;
  final double borderRadius; // Made final

  const CachedAvatar({
    super.key,
    required this.imageUrl,
    this.borderRadius = 28,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(borderRadius.r), // Added .r for scaling
      child: imageUrl.isEmpty
          ? Container(
              color: backGroundColor,
              child: FittedBox(
                alignment: Alignment.center,
                child: Icon(
                  Icons.person_4,
                  color: primaryColor,
                ),
              ),
            )
          : kIsWeb
              ? Image.network(
                  imageUrl,
                  alignment: Alignment.center,
                  fit: fit ?? BoxFit.cover, // Fixed fit logic
                  errorBuilder: (context, error, stackTrace) =>
                      errorAvatarImage,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return myPlaceHolder;
                  },
                )
              : CachedNetworkImage(
                  imageUrl: imageUrl,
                  alignment: Alignment.center,
                  fit: fit ?? BoxFit.cover, // Fixed fit logic
                  placeholder: (context, url) => myPlaceHolder,
                  errorWidget: (context, url, error) => errorAvatarImage,
                ),
    );
  }
}
