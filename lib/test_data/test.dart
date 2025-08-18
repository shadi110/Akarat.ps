import 'package:flutter/material.dart';

import '../widgets/real_estate_card.dart';
class PropertyListPage extends StatelessWidget {
  const PropertyListPage({super.key});

  // بيانات تجريبية
  final List<Map<String, dynamic>> properties = const [
    {
      "title": "فيلا فاخرة",
      "description": "فيلا جميلة تطل على البحر",
      "price": "١٬٢٠٠٬٠٠٠\$",
      "location": "مرسى دبي",
      "status": "للبيع",
      "image": "https://cdn.prod.website-files.com/620ec747459e13c7cf12a39e/625b10a58137b364b18df2ea_iStock-94179607.jpg",
    },
    {
      "title": "شقة مريحة",
      "description": "شقة حديثة في وسط المدينة",
      "price": "٤٥٠٬٠٠٠\$",
      "location": "نيويورك",
      "status": "للإيجار",
      "image": "https://cdn.prod.website-files.com/620ec747459e13c7cf12a39e/625b10a58137b364b18df2ea_iStock-94179607.jpg",
    },
    {
      "title": "بيت ريفي",
      "description": "بيت هادئ مع حديقة كبيرة",
      "price": "٧٥٠٬٠٠٠\$",
      "location": "توسكانا",
      "status": "للبيع",
      "image": "https://cdn.prod.website-files.com/620ec747459e13c7cf12a39e/625b10a58137b364b18df2ea_iStock-94179607.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("العقارات"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: RealEstateCard(
              title: property["title"],
              description: property["description"],
              price: property["price"],
              location: property["location"],
              status: property["status"],
              imageUrl: property["image"],
            ),
          );
        },
      ),
    );
  }
}