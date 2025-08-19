import 'package:akarat/widgets/add_new_real_estate_page.dart';
import 'package:flutter/material.dart';

import '../constants/ApiConstants.dart';
import '../constants/app_constants.dart';
import '../services/ApiService.dart';
import '../widgets/real_estate_card.dart';
class DashboardMainPage extends StatefulWidget {
  const DashboardMainPage({super.key});

  @override
  State<DashboardMainPage> createState() => _DashboardMainPageState();
}

class _DashboardMainPageState extends State<DashboardMainPage> {
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
              price: '',
              location: '',
              status: property["status"],
              imageUrl: property["coverPhoto"],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewRealEstatePage()),
            );
            fetchProperties();
          },
          label: const Text("إعلان جديد"),
          icon: const Icon(Icons.add),
          backgroundColor: AppColors.addAdv
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}