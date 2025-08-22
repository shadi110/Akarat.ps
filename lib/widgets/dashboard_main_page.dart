import 'package:akarat/widgets/add_new_real_estate_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/ApiConstants.dart';
import '../constants/app_constants.dart';
import '../services/ApiService.dart';
import '../utils/UserPreferences.dart';
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

  Future<bool> checkUserLoggedIn() async {
    try {
      return await UserPreferences.isLoggedIn();
    } catch (e) {
      debugPrint("Error checking user login status: $e");
      return false;
    }
  }


  Future<bool> createUserAndLogin(String phone) async {
    try {
      final response = await apiService.create(ApiConstants.registerUser, {'phoneNumber': phone});
      await UserPreferences.saveUser(response['id'].toString(), phone);
      return true;
    } catch (e) {
      debugPrint("Error creating user: $e");
      return false;
    }
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
        onPressed: () async {
          // Check if user is logged in
          final isLoggedIn = await checkUserLoggedIn(); // implement this function
          if (!isLoggedIn) {
            // Show dialog to enter phone number
            final phoneNumber = await showDialog<String>(
              context: context,
              builder: (context) {
                final _phoneController = TextEditingController();
                return AlertDialog(
                  title: const Text("أدخل رقم الهاتف للتسجيل"),
                  content: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "رقم الهاتف",
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("إلغاء"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final phone = _phoneController.text.trim();
                        if (phone.isNotEmpty) {
                          Navigator.of(context).pop(phone);
                        }
                      },
                      child: const Text("تسجيل"),
                    ),
                  ],
                );
              },
            );

            if (phoneNumber != null) {
              // Call API to create user and login
              final success = await createUserAndLogin(phoneNumber);
              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("حدث خطأ أثناء تسجيل المستخدم"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
            } else {
              return; // user cancelled dialog
            }
          }

          // Navigate to Add New Real Estate page
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewRealEstatePage()),
          );

          // Refresh properties after returning
          fetchProperties();
        },
        label: const Text("إعلان جديد"),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.addAdv,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}