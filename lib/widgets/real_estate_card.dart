import 'package:flutter/material.dart';
import 'app_text.dart';

class RealEstateCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? description;
  final String? price;
  final String? location;
  final String? status; // e.g., "For Sale" or "Sold"
  final VoidCallback? onTap;

  const RealEstateCard({
    Key? key,
    this.imageUrl,
    this.title,
    this.description,
    this.price,
    this.location,
    this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Safe values (fallbacks if null or empty)
    final safeImage = (imageUrl != null && imageUrl!.trim().isNotEmpty)
        ? imageUrl!
        : "https://via.placeholder.com/300x200";

    final safeTitle = (title != null && title!.trim().isNotEmpty)
        ? title!
        : "No Title";

    final safeDescription = (description != null && description!.trim().isNotEmpty)
        ? description!
        : "No description available";

    final safePrice = (price != null && price!.trim().isNotEmpty)
        ? price!
        : "Not specified";

    final safeLocation = (location != null && location!.trim().isNotEmpty)
        ? location!
        : "Unknown location";

    final safeStatus = (status != null && status!.trim().isNotEmpty)
        ? status!
        : "";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Safe Image with fallback & error handling
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                safeImage,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // ✅ Card details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AppText(
                          text: safeTitle,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (safeStatus.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: safeStatus.toLowerCase() == 'sold'
                                ? Colors.red
                                : Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AppText(
                            text: safeStatus,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Description
                  AppText(
                    text: safeDescription,
                    fontSize: 14,
                    color: Colors.grey[700]!,
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      AppText(
                        text: safeLocation,
                        fontSize: 14,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price
                  AppText(
                    text: safePrice,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
