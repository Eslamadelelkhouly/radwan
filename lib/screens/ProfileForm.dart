import 'dart:io';
import 'package:diagnosify_app/core/manager/cubit/get_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String? networkImageUrl;

  @override
  void initState() {
    super.initState();
    context.read<GetProfileCubit>().getProfile();
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
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocConsumer<GetProfileCubit, GetProfileState>(
        listener: (context, state) {
          if (state is GetProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("Failed to load profile: ${state.error['message']}"),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          if (state is GetProfileSuccess) {
            final data = state.response;
            nameController.text = data['name'] ?? '';
            phoneController.text = data['phone'] ?? '';
            idController.text = data['national_id'] ?? '';
            medicineController.text = data['medications'] ?? '';
            diseaseController.text = data['diseases'] ?? '';
            networkImageUrl = data['image'];
          }
        },
        builder: (context, state) {
          return state is GetProfileLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0xff048497),
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(30)),
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
                                    : networkImageUrl != null
                                        ? NetworkImage(networkImageUrl!)
                                        : AssetImage("assets/avatar.png")
                                            as ImageProvider,
                                child: _imageFile == null &&
                                        networkImageUrl == null
                                    ? Icon(Icons.add_a_photo,
                                        color: Colors.white70)
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
                      buildCard("Diseases", diseaseController,
                          hint: "Separate by lines"),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Send updated data to backend here
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Profile saved (not yet sent to backend)')));
                        },
                        child: Text("Save",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff048497)),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                );
        },
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
