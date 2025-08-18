import 'package:flutter/material.dart';

import 'app_text.dart';


class RealEstateCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final String location;
  final String status; // e.g., "For Sale" or "Sold"
  final VoidCallback? onTap;

  const RealEstateCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
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
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
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
                          text: title,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: status.toLowerCase() == 'sold'
                              ? Colors.red
                              : Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AppText(
                          text: status,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),

                  // Description
                  AppText(
                    text: description,
                    fontSize: 14,
                    color: Colors.grey[700]!,
                  ),
                  SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      AppText(
                        text: location,
                        fontSize: 14,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Price
                  AppText(
                    text: price,
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
