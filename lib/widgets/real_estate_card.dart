import 'package:akarat/constants/ApiConstants.dart';
import 'package:akarat/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'RealEstateDetailsPage.dart';
import 'app_text.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';


class RealEstateCard extends StatelessWidget {
  final String? imageUrl;
  final List<String>? listOfImages;
  final String? title;
  final String? description;
  final String? currency;
  final double? price;
  final dynamic location; // Changed from String? to dynamic
  final String? status;
  final String? advId;
  final String? type;
  final String? availability;
  final String?  statusType;
  final VoidCallback? onTap;

  const RealEstateCard({
    Key? key,
    this.imageUrl,
    this.listOfImages,
    this.title,
    this.description,
    this.price,
    this.location, // Changed type
    this.status,
    this.advId,
    this.onTap, this.currency, this.availability, this.statusType, this.type,
  }) : super(key: key);

  // Helper method to extract location text
  String _getLocationText() {
    if (location == null) return "Unknown location";

    if (location is String) {
      return location as String;
    }

    if (location is Map<String, dynamic>) {
      final locationMap = location as Map<String, dynamic>;
      final city = locationMap['city'] ?? '';
      final area = locationMap['area'] ?? '';
      final country = locationMap['country'] ?? '';

      if (city.isNotEmpty && area.isNotEmpty) {
        return '$city - $area';
      } else if (city.isNotEmpty) {
        return city;
      } else if (area.isNotEmpty) {
        return area;
      } else if (country.isNotEmpty) {
        return country;
      }
    }

    return "Unknown location";
  }

  @override
  Widget build(BuildContext context) {
    final safeImage = (imageUrl != null && imageUrl!.isNotEmpty)
        ? imageUrl!
        : "https://via.placeholder.com/300x200";

    final safeTitle = title?.isNotEmpty == true ? title! : "No Title";
    final safeDescription = description?.isNotEmpty == true ? description! : "No description available";
    final safeLocation = _getLocationText(); // Use the helper method
    final safeStatus = status?.isNotEmpty == true ? status! : "";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RealEstateDetailsPage(
              coverImage: imageUrl ?? '',
              title: title ?? '',
              description: description ?? '',
              price: price ?? 0,
              location: safeLocation, // Pass the formatted location
              availability: status ?? '',
              type: type ?? '',
              images: listOfImages ?? [],
              currency: currency ?? '',
              statusType: statusType ?? '',
            ),
          ),
        );
      },
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: safeImage,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(strokeWidth: 3,color: Colors.blue),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: safeStatus.toLowerCase() == 'sold' ? Colors.red : Colors.green,
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
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Flexible(
                        child: AppText(
                          text: safeLocation,
                          fontSize: 14,
                          color: Colors.grey[600]!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      AppText(
                        text: price != null
                            ? NumberFormat('#,###.##').format(price)
                            : '0',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 8),
                      AppText(
                        text: currency ?? '',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      const Spacer(),

                      if (advId != null)
                        GestureDetector(
                          onTap: () async {
                            try {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("تأكيد الحذف"),
                                  content: const Text("هل أنت متأكد من حذف الإعلان؟"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("إلغاء"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text("حذف"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                final response = await http.delete(
                                    Uri.parse("${ApiConstants.realEstates}/$advId")
                                );

                                if (response.statusCode == 200 || response.statusCode == 204) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("تم حذف الإعلان بنجاح"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  // You might want to add a callback here to refresh the parent widget
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("فشل في حذف الإعلان"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("خطأ أثناء حذف الإعلان: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const AppText(
                            text: 'حذف',
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                    ],
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