import 'package:akarat/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../widgets/app_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RealEstateDetailsPage extends StatelessWidget {
  final String coverImage;
  final List<String> images;
  final String title;
  final String description;
  final double price;
  final String location;
  final String availability; // e.g., "For Sale", "Sold"
  final Map<String, String>? otherDetails; // optional key-value details

  const RealEstateDetailsPage({
    super.key,
    required this.coverImage,
    required this.images,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.availability,
    this.otherDetails,
  });

  void _openImage(BuildContext context, String initialImage, List<String> allImages) {
    int initialIndex = allImages.indexOf(initialImage);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: allImages.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Center(
                  child: Image.network(
                    allImages[index],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("تفاصيل العقار"),
        backgroundColor: AppColors.pastelBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image (clickable too)
            GestureDetector(
              onTap: () => _openImage(context, coverImage, [coverImage, ...images]),
              child: Image.network(
                coverImage,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Horizontal images list
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _openImage(context, images[index], [coverImage, ...images]), // pass the full list here
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: images[index],
                          width: 120,
                          height: 100,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                          placeholder: (context, url) => Container(
                            width: 120,
                            height: 100,
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 120,
                            height: 100,
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Title & Availability
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: AppText(
                      text: title,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: availability.toLowerCase() == 'sold' ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      text: availability,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppText(
                text: "السعر: $price",
                fontSize: 18,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.grey),
                  const SizedBox(width: 4),
                  AppText(
                    text: location,
                    fontSize: 16,
                    color: Colors.grey[700]!,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppText(
                text: description,
                fontSize: 16,
                color: Colors.grey[800]!,
              ),
            ),

            const SizedBox(height: 16),

            // Other details (if any)
            if (otherDetails != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: otherDetails!.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          AppText(
                            text: "${entry.key}: ",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          AppText(
                            text: entry.value,
                            fontSize: 16,
                            color: Colors.grey[700]!,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              const Icon(Icons.image_not_supported, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
