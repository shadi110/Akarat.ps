import 'package:flutter/material.dart';

import '../constants/ApiConstants.dart';
import '../constants/app_constants.dart';
import '../services/ApiService.dart';
import '../widgets/real_estate_card.dart';
class PropertyListPage extends StatefulWidget {
  PropertyListPage({super.key});

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  final apiService = ApiService();
  List<dynamic> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }
  Future<void> fetchProperties() async {
    try {
      final response = await apiService.read(ApiConstants.realEstates);
      setState(() {
        properties = response; // Assuming API returns a list of properties
        print('properities : ${properties}');
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching properties: $e");
    }
  }

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
              price: 0.0,
              location: '',
              status: property["status"],
              imageUrl: property["coverPhoto"],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add new ad page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Add New Ad tapped!")),
          );
        },
        label: const Text("إعلان جديد"),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.addAdv
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}