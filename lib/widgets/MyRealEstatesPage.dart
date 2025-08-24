import 'package:flutter/material.dart';
import 'package:akarat/widgets/add_new_real_estate_page.dart';
import '../constants/ApiConstants.dart';
import '../constants/app_constants.dart';
import '../services/ApiService.dart';
import '../utils/UserPreferences.dart';
import '../widgets/real_estate_card.dart';

class MyRealEstatesPage extends StatefulWidget {
  const MyRealEstatesPage({super.key});

  @override
  State<MyRealEstatesPage> createState() => _MyRealEstatesPageState();
}

class _MyRealEstatesPageState extends State<MyRealEstatesPage> {
  final apiService = ApiService();
  List<dynamic> userProperties = [];
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserProperties();
  }

  Future<void> _loadUserProperties() async {
    try {
      // Get current user ID
      userId = await UserPreferences.getUserId();

      if (userId == null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("يجب تسجيل الدخول أولاً")),
        );
        return;
      }

      // Fetch properties for the specific user
      final response = await apiService.read('${ApiConstants.realEstates}/owner/$userId');

      setState(() {
        userProperties = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching user properties: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء تحميل العقارات")),
      );
    }
  }

  Future<void> _deleteProperty(String propertyId) async {
    try {
      // Show confirmation dialog
      bool confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("حذف العقار"),
          content: const Text("هل أنت متأكد من أنك تريد حذف هذا العقار؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("حذف"),
            ),
          ],
        ),
      );

      if (confirmDelete == true) {
        // Delete the property
        await apiService.delete('${ApiConstants.realEstates}' , propertyId);

        // Refresh the list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم حذف العقار بنجاح")),
        );

        _loadUserProperties();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء حذف العقار")),
      );
      debugPrint("Error deleting property: $e");
    }
  }

  Future<void> _refreshProperties() async {
    setState(() {
      isLoading = true;
    });
    await _loadUserProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("عقاراتي"),
        backgroundColor: AppColors.pastelBlue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProperties.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_work, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "لا توجد عقارات مضافة",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _refreshProperties,
              child: const Text("تحديث"),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _refreshProperties,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: userProperties.length,
          itemBuilder: (context, index) {
            final property = userProperties[index];

            // Convert List<dynamic> to List<String>
            List<String> listOfPictures = [];
            if (property["listOfPictures"] != null) {
              listOfPictures = List<String>.from(property["listOfPictures"]);
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Stack(
                children: [
                  // Your RealEstateCard
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: RealEstateCard(
                      title: property["title"] ?? "بدون عنوان",
                      description: property["description"] ?? "بدون وصف",
                      price: property["price"]!,
                      location: property["location"] ?? '',
                      status: property["status"] ?? "غير معروف",
                      imageUrl: property["coverPhoto"],
                      listOfImages: listOfPictures,
                      onTap: () {
                        // You can add navigation to property details here
                      },
                    ),
                  ),

                  // Delete button in top right corner
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProperty(property['id'].toString()),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}