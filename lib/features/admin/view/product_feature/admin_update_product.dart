import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:gym/features/admin/viewModel/admin_product_controller.dart';

class adminUpdateProductScreen extends StatefulWidget {
  final ProudctModel product;
  const adminUpdateProductScreen({super.key, required this.product});

  @override
  State<adminUpdateProductScreen> createState() =>
      _adminUpdateProductScreenState();
}

class _adminUpdateProductScreenState extends State<adminUpdateProductScreen> {
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
  void initState() {
    _title.text = widget.product.title;
    _description.text = widget.product.descreption;
    _price.text = '${widget.product.price}';
    qty.text = '${widget.product.quantiti}';
    discount.text = '${widget.product.discount}';
    isFeatured = widget.product.isFeatured;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final localise = AppLocalizations.of(context)!;
    final productVM = Provider.of<AdminProductController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColor.primary),
        ),
        title: Text(
          localise.updateProduct,
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
              // IMAGE PICKER
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
                              Image.network(widget.product.image),
                              Container(
                                height: flex.height(0.20),
                                width: flex.width(0.60),
                                color: Colors.black.withOpacity(0.2),
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
              // CATEGORIES DROPDOWN
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Product added successfully!"),
                              ),
                            );
                            double price = double.parse(
                              _price.text.trim().replaceAll(',', '.'),
                            );
                            int quantity = int.parse(qty.text.trim());
                            await productVM.updateProduct(
                              widget.product.id,
                              _title.text,
                              _description.text,
                              price,
                              quantity,
                              isFeatured,
                              widget.product,
                              double.parse(discount.text),
                              pickedImage,
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          } finally {
                            Navigator.of(context).pop();
                          }
                        },
                  child: Text(
                    localise.updateProduct,
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
