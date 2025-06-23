import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final idController = TextEditingController();
  final medicineController = TextEditingController();
  final diseaseController = TextEditingController();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('name') ?? '';
    phoneController.text = prefs.getString('phone') ?? '';
    idController.text = prefs.getString('id') ?? '';
    medicineController.text = prefs.getString('medicine') ?? '';
    diseaseController.text = prefs.getString('disease') ?? '';
    final imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      setState(() => _imageFile = File(imagePath));
    }
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('id', idController.text);
    await prefs.setString('medicine', medicineController.text);
    await prefs.setString('disease', diseaseController.text);
    if (_imageFile != null) {
      await prefs.setString('imagePath', _imageFile!.path);
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff048497),
        leading: BackButton(color: Colors.white),
        title: Text("profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff048497),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : AssetImage("assets/avatar.png") as ImageProvider,
                      child: _imageFile == null
                          ? Icon(Icons.add_a_photo, color: Colors.white70)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            buildCard("Name", nameController),
            buildCard("Phone Number", phoneController,
                keyboard: TextInputType.phone),
            buildCard("National Number", idController),
            buildCard("Medicine", medicineController,
                hint: "Separate by lines"),
            buildCard("Diseases", diseaseController, hint: "Separate by lines"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveData();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Profile saved')));
              },
              child: Text("Save",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xff048497)),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: Color(0xff048497),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              TextField(
                controller: controller,
                keyboardType: keyboard,
                maxLines: title == "Medicine" || title == "Diseases" ? null : 1,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
