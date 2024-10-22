import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constant.dart';
import '../utils/string.dart';
import '../widget/bottom_navigation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String name = "Kannan";
  String email = "kannan.kumar82@gmail.com";
  String phoneNumber = "+919171791100";
  bool isEditingPassword = false; // To control visibility of password fields
  bool showNewPasswordError = false; // To track error state for new password
  bool showConfirmPasswordError =false; // To track error state for confirm password
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>UserProvider()..loadUser(),
      child: Scaffold(
        backgroundColor: const Color(0xff121212),
        appBar: AppBar(
          backgroundColor: const Color(0xff121212),
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: whiteColor,
            ),
          ),
          title: Text(
            'Profile',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: whiteColor,
                fontFamily: MyStrings.outfit),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Consumer<UserProvider>(
            builder: (context,user,_) {
              return Padding(
                padding: const EdgeInsets.only(left:16.0,right:16.0,top:25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Display Name (static)
                    CircleAvatar(
                      radius: 48,
                      backgroundColor:Colors.grey,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0]:'',
                        style: TextStyle(color: whiteColor, fontSize: 50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      style: TextStyle(color:whiteColor,fontFamily: MyStrings.outfit),
                      decoration: InputDecoration(
                        hintText: user.name.isNotEmpty ? user.name : 'Name not available',
                        hintStyle: const TextStyle(color: Colors.grey,fontFamily: MyStrings.outfit),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color:Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // White border when enabled
                          borderRadius: BorderRadius.circular(15),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // White border when disabled
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.person_outlined,
                            color: whiteColor, size: 25),
                      ),
                      enabled: false, // Disable editing
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      style: TextStyle(color:whiteColor,fontFamily: MyStrings.outfit),
                      decoration: InputDecoration(
                        hintText: user.email.isNotEmpty ? user.email : 'Email not available',
                        hintStyle: const TextStyle(color: Colors.grey,fontFamily: MyStrings.outfit),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color:Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // White border when enabled
                          borderRadius: BorderRadius.circular(15),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // White border when disabled
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon:
                            Icon(Icons.email_outlined, color: whiteColor, size: 25),
                      ),
                      enabled: false, // Disable editing
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      style: TextStyle(color:whiteColor,fontFamily: MyStrings.outfit),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone_android_outlined,
                            color: whiteColor, size: 25),
                        hintText: user.number.isNotEmpty ? user.number : 'phone number not available',
                        hintStyle: const TextStyle(color: Colors.grey,fontFamily: MyStrings.outfit),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color:Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // White border when enabled
                          borderRadius: BorderRadius.circular(15),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // White border when disabled
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      enabled: false, // Disable editing
                    ),
                    const SizedBox(height: 16),

                    // Update Password Button
                    if (!isEditingPassword) // Show this only if not editing password
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditingPassword = true; // Show password fields on click
                          });
                        },
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                              fontFamily: MyStrings.outfit),
                        ),
                      ),

                    // New Password and Confirm Password fields, Save and Cancel buttons
                    if (isEditingPassword) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        style: TextStyle(color:whiteColor,fontFamily: MyStrings.outfit),
                        decoration: InputDecoration(
                          hintText: 'Enter new password',
                          hintStyle: const TextStyle(
                              color: Colors.grey, fontFamily: MyStrings.outfit),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color:
                                    showNewPasswordError ? Colors.red : Colors.grey,
                              ),),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // White border when enabled
                            borderRadius: BorderRadius.circular(15),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // White border when disabled
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: Icon(Icons.lock_outline,
                              color: whiteColor, size: 25), // Icon for new password
                          errorText: showNewPasswordError
                              ? 'Please enter a new password'
                              : null, // Error message
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              showNewPasswordError = false;
                            }
                            else{
                              showNewPasswordError = true;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        style: TextStyle(color:whiteColor,fontFamily: MyStrings.outfit),
                        decoration: InputDecoration(
                          hintText: 'Confirm new password',
                          hintStyle: const TextStyle(
                              color: Colors.grey, fontFamily: MyStrings.outfit),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color:
                                  showConfirmPasswordError ? Colors.red : Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // White border when enabled
                            borderRadius: BorderRadius.circular(15),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // White border when disabled
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: Icon(Icons.lock_outline,
                              color: whiteColor,
                              size: 25), // Icon for confirm password
                          errorText: showConfirmPasswordError
                              ? 'Please confirm your password'
                              : null, // Error message

                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              showConfirmPasswordError = false;
                            }
                            else{
                              showConfirmPasswordError = true;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showNewPasswordError =
                                    newPasswordController.text.isEmpty;
                                showConfirmPasswordError =
                                    confirmPasswordController.text.isEmpty;

                                // Check if both fields are not empty and passwords match
                                if (newPasswordController.text.isNotEmpty &&
                                    confirmPasswordController.text.isNotEmpty &&
                                    newPasswordController.text ==
                                        confirmPasswordController.text) {
                                  print("Password updated successfully!");
                                  // Hide password fields after success
                                  isEditingPassword = false;
                                } else if (newPasswordController.text.isEmpty ||
                                    confirmPasswordController.text.isEmpty) {
                                  // If either field is empty, print error message
                                  print('Please enter and confirm the password.');
                                } else {
                                  // If passwords do not match
                                  print("Passwords do not match.");
                                }
                              });
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: blackColor,
                                  fontFamily: MyStrings.outfit),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                // Reset state to hide password fields
                                isEditingPassword = false;
                                newPasswordController.clear();
                                confirmPasswordController.clear();
                              });
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: whiteColor,
                                  fontFamily: MyStrings.outfit),
                            ),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
