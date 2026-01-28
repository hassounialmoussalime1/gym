// ignore: file_names
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/features/admin/widgets/circleIndicator.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:gym/features/admin/viewModel/admin_product_controller.dart';

// ignore: camel_case_types
class adminAddProductScreen extends StatefulWidget {
  final String categorieId;
  const adminAddProductScreen({super.key, required this.categorieId});

  @override
  State<adminAddProductScreen> createState() => _adminAddProductScreenState();
}

// ignore: camel_case_types
class _adminAddProductScreenState extends State<adminAddProductScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController qty = TextEditingController();
  final TextEditingController discount = TextEditingController();

  XFile? pickedImage;
  bool isFeatured = false;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() => pickedImage = image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
    final flex = FlexibleSize(context);

    final productVM = Provider.of<AdminProductController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColor.primary),
        ),
        title: Text(
          localise.addProduct,
          style: AppTextStyle.normalText.copyWith(
            color: AppColor.primary,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: productVM.isLoading
              ? Circleindicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE PICKER
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

                    // TITLE
                    TextField(
                      controller: _title,
                      style: AppTextStyle.normalText,
                      decoration: InputDecoration(
                        label: Text(
                          localise.title,
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

                    SizedBox(height: flex.height(0.020)),

                    // PRICE
                    TextField(
                      controller: _price,
                      keyboardType: TextInputType.text,
                      style: AppTextStyle.normalText,
                      decoration: InputDecoration(
                        label: Text(
                          localise.price,
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

                    SizedBox(height: flex.height(0.020)),
                    TextField(
                      controller: qty,
                      keyboardType: TextInputType.number,
                      style: AppTextStyle.normalText,
                      decoration: InputDecoration(
                        label: Text(
                          localise.qantitie,
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
                    SizedBox(height: flex.height(0.020)),
                    TextField(
                      controller: discount,
                      keyboardType: TextInputType.number,
                      style: AppTextStyle.normalText,
                      decoration: InputDecoration(
                        label: Text(
                          localise.discount,
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
                    // CATEGORIES DROPDOWN
                    SizedBox(height: flex.height(0.020)),

                    // DESCRIPTION
                    TextField(
                      controller: _description,
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

                    SizedBox(height: flex.height(0.020)),

                    // FEATURED
                    Row(
                      children: [
                        Checkbox(
                          value: isFeatured,
                          onChanged: (val) =>
                              setState(() => isFeatured = val ?? false),
                          activeColor: AppColor.primary,
                        ),
                        Text(
                          localise.featureProduct,
                          style: AppTextStyle.normalText.copyWith(
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: flex.height(0.040)),

                    // SUBMIT BUTTON
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
                        onPressed: productVM.isLoading
                            ? null
                            : () async {
                                try {
                                  await productVM.addProduct(
                                      name: _title.text,
                                      price: double.tryParse(_price.text) ?? 0,
                                      categorieId: widget.categorieId,
                                      description: _description.text,
                                      imageFile: pickedImage,
                                      isFeature: isFeatured,
                                      qty: int.parse(qty.text),
                                      discount: double.parse(discount.text));

                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Product added successfully!"),
                                    ),
                                  );

                                  _title.clear();
                                  _price.clear();
                                  _description.clear();
                                  qty.clear();
                                  setState(() {
                                    pickedImage = null;
                                    isFeatured = false;
                                  });
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                } finally {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                }
                              },
                        child: Text(
                          localise.addProduct,
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
