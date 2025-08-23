import 'package:akarat/constants/ApiConstants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as apiService;
import 'RealEstateDetailsPage.dart';
import 'app_text.dart';

class RealEstateCard extends StatelessWidget {
  final String? imageUrl;
  final List<String>? listOfImages;
  final String? title;
  final String? description;
  final String? price;
  final String? location;
  final String? status;
  final String? advId; // Add this
  final VoidCallback? onTap;

  const RealEstateCard({
    Key? key,
    this.imageUrl,
    this.listOfImages,
    this.title,
    this.description,
    this.price,
    this.location,
    this.status,
    this.advId, // Add this
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final safeImage = (imageUrl != null && imageUrl!.isNotEmpty)
        ? imageUrl!
        : "https://via.placeholder.com/300x200";

    final safeTitle = title?.isNotEmpty == true ? title! : "No Title";
    final safeDescription = description?.isNotEmpty == true ? description! : "No description available";
    final safePrice = price?.isNotEmpty == true ? price! : "Not specified";
    final safeLocation = location?.isNotEmpty == true ? location! : "Unknown location";
    final safeStatus = status?.isNotEmpty == true ? status! : "";

    return GestureDetector(
      onTap: () {Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RealEstateDetailsPage(
            coverImage: imageUrl ?? '',
            title: title ?? '',
            description: description ?? '',
            price: price ?? '',
            location: location ?? '',
            availability: status ?? '', images: listOfImages ?? [],
          ),
        ),
      );},
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
              child: Image.network(
                safeImage,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
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
                  AppText(
                    text: safeDescription,
                    fontSize: 14,
                    color: Colors.grey[700]!,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      AppText(
                        text: safeLocation,
                        fontSize: 14,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      AppText(
                        text: safePrice,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      Spacer(),
                      if (advId != null) // Only show delete if advId is provided
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
                                final response = await apiService.delete(
                                    Uri.parse("${ApiConstants.realEstates}/$advId")
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("تم حذف الإعلان بنجاح"),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Optionally refresh your list by calling a callback
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
                          child: AppText(
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

