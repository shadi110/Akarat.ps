import 'package:akarat/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../constants/ApiConstants.dart';
import '../services/ApiService.dart';
import '../utils/AreasDetailsHelper.dart';
import '../utils/UserPreferences.dart';
import '../utils/helper.dart';

class AddNewRealEstatePage extends StatefulWidget {
  const AddNewRealEstatePage({super.key});

  @override
  _AddNewRealEstatePageState createState() => _AddNewRealEstatePageState();
}

class _AddNewRealEstatePageState extends State<AddNewRealEstatePage> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _sizeController = TextEditingController();

  // Media
  File? _coverImage;
  List<File> _extraImages = [];
  File? _videoFile;

  // Dropdowns
  String? _selectedType;
  String _selectedMetric = "متر مربع";
  String _selectedCurrency = "دولار";
  String _selectedCity = "رام الله";
  String? _selectedArea;

  final ImagePicker _picker = ImagePicker();
  final apiService = ApiService();

  // Pick cover image
  Future<void> _pickCoverImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _coverImage = File(pickedFile.path));
    }
  }

  // Pick multiple extra images
  Future<void> _pickExtraImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _extraImages = pickedFiles.take(10).map((f) => File(f.path)).toList();
      });
    }
  }

  // Pick one video
  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _videoFile = File(pickedFile.path));
    }
  }

  List<dynamic> properties = [];
  bool isLoading = true;
  Future<void> addProperty(Map<String, dynamic> data) async {
    try {
      String? userId = await UserPreferences.getUserId();
      final response = await apiService.create(ApiConstants.newRealEstates + userId!, data);
      print('response is ${response}');
      setState(() {
        properties.add(response);// Assuming API returns a list of properties
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error ADD properties: $e");
    }
  }
  Future<String?> _uploadCoverImage(File image) async {
    try {
      final response = await apiService.uploadFile(
        ApiConstants.uploadOneImage, // your endpoint for upload
        image,
        fieldName: "file", // depends on your API requirement
      );

      // Assuming response returns something like { "url": "https://..." }
      return response;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
    }
  }

  Future<List<String>> uploadExtraImages(List<File> images) async {
    List<String> uploadedUrls = [];
      try {
        uploadedUrls = await apiService.uploadFiles(
          ApiConstants.uploadBulkOfImages, // your endpoint for upload
          images,
          fieldName: "files", // depends on your API requirement
        );
        print('uploadurl is ${uploadedUrls}');
        return uploadedUrls;
      } catch (e) {
        print('Error in uploadExtraImages: $e');

        //debugPrint("Error uploading image ${images.path}: $e");
        // Optionally, continue or break depending on your logic
        return [];
      }
  }


  // Submit form
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);
    String? coverImageUrl;
    if (_coverImage != null) {
      coverImageUrl = await _uploadCoverImage(_coverImage!);
      if (coverImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("فشل رفع صورة الغلاف"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    List<String>? extraImagesList;
    if (_extraImages.isNotEmpty) {
      extraImagesList = await uploadExtraImages(_extraImages!);
      print('extraImagesList : ${extraImagesList}');
      if (extraImagesList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("فشل رفع صورة اضافيه"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (_formKey.currentState!.validate()) {
      print(_selectedArea);
      final requestBody = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'phoneNumber': _phoneNumberController.text,
        'type': Helper.propertyTypeMap[_selectedType] ?? '',
        'size': _sizeController.text,
        'sizeMetric': Helper.areaUnitMap[_selectedMetric],
        'coverPhoto': coverImageUrl,
        'listOfPictures' : extraImagesList ?? [],
        'currency' : _selectedCurrency,
        'location': {
          'city': _selectedCity,
          'country': "فلسطين", // optional if you want
          'area': _selectedArea,
        }
        // Note: Files (_coverImage, _extraImages, _videoFile) must be uploaded via multipart separately
      };

      final response = await addProperty(requestBody);
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Real Estate Ad Created Successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
      // Clear the form
      _formKey.currentState!.reset();
      setState(() {
        _coverImage = null;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _phoneNumberController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: const Text('إضافة عقار جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Cover image picker
              GestureDetector(
                onTap: _pickCoverImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  ),
                  child: _coverImage == null
                      ? const Center(child: Text("اضغط لإضافة صورة الغلاف"))
                      : Image.file(_coverImage!, fit: BoxFit.cover, width: double.infinity),
                ),
              ),
              const SizedBox(height: 16),

              // Extra images
              ElevatedButton.icon(
                onPressed: _pickExtraImages,
                icon: const Icon(Icons.photo_library),
                label: const Text("إضافة صور أخرى (حتى 10)"),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _extraImages.map((img) {
                  return Image.file(img, width: 80, height: 80, fit: BoxFit.cover);
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Video
              ElevatedButton.icon(
                onPressed: _pickVideo,
                icon: const Icon(Icons.videocam),
                label: const Text("إضافة فيديو (اختياري)"),
              ),
              if (_videoFile != null)
                Text("تم اختيار فيديو: ${_videoFile!.path.split('/').last}"),

              const SizedBox(height: 20),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'عنوان الاعلان', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'يرجى إدخال العنوان' : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'الوصف', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'يرجى إدخال الوصف' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCity,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: AreasDetailsHelper.westBankCities
                          .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                          .toList(),
                      onChanged: (val) => setState(() {
                        _selectedCity = val!;
                        _selectedArea = null; // reset area
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: (_selectedArea != null &&
                          AreasDetailsHelper.allAreas[_selectedCity]?.contains(_selectedArea) == true)
                          ? _selectedArea
                          : null, // <-- use null if value is not valid
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: AreasDetailsHelper.allAreas[_selectedCity]
                          ?.map((area) => DropdownMenuItem(value: area, child: Text(area)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedArea = val),
                      validator: (value) => value == null || value.isEmpty ? 'اختر المنطقة' : null,
                      hint: const Text("اختر المنطقة"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'السعر', border: OutlineInputBorder()),
                      validator: (value) => value!.isEmpty ? 'يرجى إدخال السعر' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCurrency,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: ["دولار", "دينار", "شيقل"]
                          .map((metric) => DropdownMenuItem(value: metric, child: Text(metric)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedCurrency = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Location
              // Phones
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'رقم الهاتف ', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              // Dropdown for type
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'نوع العقار', border: OutlineInputBorder()),
                items: ["شقة عظم", "شقة مشطبة", "فيلا", "منزل مستقل", "مخزن", "ارض"]
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (val) => setState(() =>  _selectedType = val!),
                validator: (value) => value == null ? 'اختر نوع العقار' : null,
              ),
              const SizedBox(height: 16),

              // Size + metric
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _sizeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'المساحة', border: OutlineInputBorder()),
                      validator: (value) => value!.isEmpty ? 'يرجى إدخال المساحة' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedMetric,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: ["متر مربع", "دونم"]
                          .map((metric) => DropdownMenuItem(value: metric, child: Text(metric)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedMetric = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pastelYellow,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isSubmitting
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text("نشر الإعلان", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
