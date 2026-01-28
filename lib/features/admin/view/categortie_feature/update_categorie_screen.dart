import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/data/models/category_model.dart';
import 'package:gym/features/admin/viewModel/admin_categorie_Controler.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class updateCategorieScreen extends StatefulWidget {
  final CategoryModel categorie;
  const updateCategorieScreen({super.key, required this.categorie});

  @override
  State<updateCategorieScreen> createState() => _updateCategorieScreenState();
}

class _updateCategorieScreenState extends State<updateCategorieScreen> {
  final TextEditingController _categorieName = TextEditingController();
  final TextEditingController _categorieDesc = TextEditingController();

  XFile? pickedImage;

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
  void initState() {
    _categorieName.text = widget.categorie.categoryName;
    _categorieDesc.text = widget.categorie.descreption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final loclaise = AppLocalizations.of(context)!;
    final viewmodel = Provider.of<AdminCategorieController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColor.primary),
        ),
        title: Text(
          loclaise.updateCategorie,
          style: AppTextStyle.normalText.copyWith(
            color: AppColor.primary,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
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
                      border: Border.all(color: AppColor.primary, width: 2),
                      color: Colors.black,
                    ),
                    child: pickedImage == null
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(widget.categorie.imgUrl),
                              Container(
                                height: flex.height(0.20),
                                width: flex.width(0.60),
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Icon(
                                Icons.edit,
                                size: 40,
                                color: AppColor.primary,
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
                    loclaise.name,
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
                    loclaise.descreption,
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
                            viewmodel.updateCategorie(
                              widget.categorie.id,
                              _categorieName.text,
                              _categorieDesc.text,
                              pickedImage,
                              widget.categorie.imgUrl,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Categorie updated!"),
                              ),
                            );
                            _categorieName.clear();
                            _categorieDesc.clear();
                            setState(() => pickedImage = null);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          } finally {
                            Navigator.of(context).pop();
                          }
                        },
                  child: viewmodel.isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Text(
                          loclaise.updateCategorie,
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
