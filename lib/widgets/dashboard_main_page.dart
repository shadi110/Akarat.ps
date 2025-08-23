import 'package:akarat/widgets/add_new_real_estate_page.dart';
import 'package:flutter/material.dart';

import '../constants/ApiConstants.dart';
import '../constants/app_constants.dart';
import '../services/ApiService.dart';
import '../utils/UserPreferences.dart';
import '../widgets/real_estate_card.dart';
import 'MyRealEstatesPage.dart';

class DashboardMainPage extends StatefulWidget {
  const DashboardMainPage({super.key});

  @override
  State<DashboardMainPage> createState() => _DashboardMainPageState();
}

class _DashboardMainPageState extends State<DashboardMainPage> {
  final apiService = ApiService();
  List<dynamic> properties = [];
  bool isLoading = true;
  int _selectedIndex = 0;

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
        properties = response; // Assuming API returns a list
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching properties: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final property = properties[index];
            List<String> listOfPictures = [];
            if (property["listOfPictures"] != null) {
              listOfPictures = List<String>.from(property["listOfPictures"]);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: RealEstateCard(
                title: property["title"],
                description: property["description"],
                price: '',
                location: '',
                status: property["status"],
                imageUrl: property["coverPhoto"],
                listOfImages:  listOfPictures ?? []
              ),
            );
          },
        );
      case 1:
        return MyRealEstatesPage();
      case 2:
        return const Center(child: Text("ggg"));
      case 3:
        return const Center(child: Text("Favorites"));
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pastelBlue,
      ),
      backgroundColor: Colors.white,
      body: _getBody(),
      floatingActionButton: SizedBox(
        width: 55,
        height: 55,
        child: FloatingActionButton(
          onPressed: () async {
            final isLoggedIn = await checkUserLoggedIn();
            if (!isLoggedIn) {
              final phoneNumber = await showDialog<String>(
                context: context,
                builder: (context) {
                  final _phoneController = TextEditingController();
                  return AlertDialog(
                    title: const Text("أدخل رقم الهاتف للتسجيل"),
                    content: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: "رقم الهاتف"),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("إلغاء")),
                      ElevatedButton(
                          onPressed: () {
                            final phone = _phoneController.text.trim();
                            if (phone.isNotEmpty) Navigator.of(context).pop(phone);
                          },
                          child: const Text("تسجيل")),
                    ],
                  );
                },
              );

              if (phoneNumber != null) {
                final success = await createUserAndLogin(phoneNumber);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("حدث خطأ أثناء تسجيل المستخدم"),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }
              } else {
                return;
              }
            }

            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddNewRealEstatePage()));
            fetchProperties();
          },
          child: const Icon(Icons.add),
          backgroundColor: AppColors.pastelYellow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildCustomBottomBar(),
    );
  }

  // Custom bottom bar implementation with reduced height
  Widget _buildCustomBottomBar() {
    return Container(
      height: 65, // Reduced height
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home button
          _buildNavItem(Icons.home, "الرئيسية", 0),
          const SizedBox(width: 30),
          _buildNavItem(Icons.real_estate_agent_sharp, "عقاراتي", 1),
          const SizedBox(width: 90),
          _buildNavItem(Icons.favorite, "المفضلة", 2),
          const SizedBox(width: 30),
          _buildNavItem(Icons.manage_accounts_sharp, "حسابي", 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.grey,
                size: 22, // Smaller icon size
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontSize: 10, // Smaller font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}