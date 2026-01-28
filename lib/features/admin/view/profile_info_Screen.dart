// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/features/admin/widgets/qpp_bar.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool enabledEmailEditing = true;
  bool isSavingEmail = false;

  String currentPassword = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ---------------- LOAD DATA ----------------
Future<void> _loadUserInfo() async {
  final doc = await collectionAdmin.doc('info').get();

  if (!doc.exists || doc.data() == null) return;

  final Map<String, dynamic> data =
      doc.data() as Map<String, dynamic>;

  emailController.text = data['email'] ?? '';
  currentPassword = data['password'] ?? '';
  passwordController.text = '********';
}


  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _updateEmail() async {
    final email = emailController.text.trim();

    if (!_isValidEmail(email)) {
      _showError('Invalid email format');
      return;
    }

    try {
      setState(() => isSavingEmail = true);

      await FirebaseFirestore.instance
          .collection('admin')
          .doc('info')
          .update({'email': email});

      setState(() => enabledEmailEditing = true);
      _showSuccess('Email updated successfully');
    } catch (e) {
      _showError('Failed to update email');
    } finally {
      setState(() => isSavingEmail = false);
    }
  }


  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    bool loading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Change Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  TextField(
                    controller: newCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  TextField(
                    controller: confirmCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm New Password',
                      prefixIcon: Icon(Icons.check),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: loading
                      ? null
                      : () async {
                          final current = currentCtrl.text.trim();
                          final newPass = newCtrl.text.trim();
                          final confirm = confirmCtrl.text.trim();

                          if (current != currentPassword) {
                            _showError('Current password is incorrect');
                            return;
                          }

                          if (newPass.length < 6) {
                            _showError(
                                'Password must be at least 6 characters');
                            return;
                          }

                          if (newPass != confirm) {
                            _showError('Passwords do not match');
                            return;
                          }

                          try {
                            setDialogState(() => loading = true);

                            await collectionAdmin
                                .doc('info')
                                .update({'password': newPass});

                            currentPassword = newPass;
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            _showSuccess('Password updated successfully');
                          } catch (e) {
                            _showError('Failed to update password');
                          } finally {
                            setDialogState(() => loading = false);
                          }
                        },
                  child: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBarAdmin(title: 'Profile'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: isMobile ? flex.height(0.03) : 70),

              // EMAIL
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 200),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        readOnly: enabledEmailEditing,
                        style: AppTextStyle.normalText,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: AppColor.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.primary)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.primary)),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: AppColor.primary,
                      onPressed: () {
                        setState(() => enabledEmailEditing = false);
                      },
                    ),
                  ],
                ),
              ),

              if (!enabledEmailEditing)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton.icon(
                    onPressed: isSavingEmail ? null : _updateEmail,
                    icon: isSavingEmail
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: const Text('Save Email'),
                  ),
                ),

              SizedBox(height: flex.height(0.03)),

              // PASSWORD
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 200),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: AppColor.primary),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.primary)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.primary)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.primary)),
                          focusColor: AppColor.primary,
                        ),
                        style: TextStyle(color: AppColor.primary),
                      ),
                    ),
                    IconButton(
                        onPressed: _showChangePasswordDialog,
                        icon: Icon(
                          Icons.edit,
                          color: AppColor.primary,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- SNACKBARS ----------------
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(msg)),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text(msg)),
    );
  }
}
