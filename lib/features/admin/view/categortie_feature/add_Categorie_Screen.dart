import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/features/admin/viewModel/admin_categorie_Controler.dart';
import 'package:gym/features/admin/widgets/circleIndicator.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCategorieScreen extends StatefulWidget {
  const AddCategorieScreen({super.key});

  @override
  State<AddCategorieScreen> createState() => _AddCategorieScreenState();
}

class _AddCategorieScreenState extends State<AddCategorieScreen> {
  final TextEditingController _categorieName = TextEditingController();
  final TextEditingController _categorieDesc = TextEditingController();

  XFile? pickedImage; // استخدم XFile لكل المنصات

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        pickedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
    final flex = FlexibleSize(context);
    final viewmodel = Provider.of<AdminCategorieController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColor.primary),
        ),
        title: Text(
          localise.NewCategorie,
          style: AppTextStyle.normalText.copyWith(
            color: AppColor.primary,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: viewmodel.isLoading
              ? Circleindicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------- IMAGE PICKER ----------
                    Center(
                      child: InkWell(
                        onTap: pickImage,
                        child: Container(
                          height: flex.height(0.20),
                          width: flex.width(0.60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: AppColor.primary, width: 2),
                            color: Colors.black,
                          ),
                          child: pickedImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: AppColor.primary,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      localise.pickImage,
                                      style: AppTextStyle.normalText.copyWith(
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: kIsWeb
                                      ? Image.network(
                                          pickedImage!.path,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(pickedImage!.path),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: flex.height(0.030)),

                    // ------- NAME ----------
                    TextField(
                      controller: _categorieName,
                      style: AppTextStyle.normalText,
                      decoration: InputDecoration(
                        label: Text(
                          localise.name,
                          style: AppTextStyle.normalText.copyWith(
                            color: AppColor.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColor.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColor.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: flex.height(0.030)),

                    // ------- DESCRIPTION ----------
                    TextField(
                      controller: _categorieDesc,
                      maxLines: 4,
                      style: AppTextStyle.normalText,
                      decoration: InputDecoration(
                        label: Text(
                          localise.descreption,
                          style: AppTextStyle.normalText.copyWith(
                            color: AppColor.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColor.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColor.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: flex.height(0.040)),

                    // ------- SUBMIT BUTTON ----------
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: viewmodel.isLoading
                            ? null
                            : () async {
                                try {
                                  await viewmodel.addCategorie(
                                    name: _categorieName.text,
                                    description: _categorieDesc.text,
                                    imageFile: pickedImage,
                                  );
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Categorie added!")),
                                  );
                                  _categorieName.clear();
                                  _categorieDesc.clear();
                                  setState(() => pickedImage = null);
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              },
                        child: Text(
                          localise.NewCategorie,
                          style: AppTextStyle.normalText.copyWith(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
