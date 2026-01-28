import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/data/models/category_model.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/features/admin/widgets/admin_product_cart.dart';
import 'package:gym/features/admin/widgets/qpp_bar.dart';
import 'package:gym/l10n/app_localizations.dart';

class CategorieDetailAdmin extends StatefulWidget {
  final CategoryModel category;
  const CategorieDetailAdmin({super.key, required this.category});
  @override
  State<CategorieDetailAdmin> createState() => _CategorieDetailAdminState();
}

class _CategorieDetailAdminState extends State<CategorieDetailAdmin> {
  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
    final flex = FlexibleSize(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBarAdmin(title: localise.CategorieInfo),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.primary),
                  ),
                  width: flex.width(0.7),
                  height: flex.height(0.25),
                  child: Image.network(widget.category.imgUrl),
                ),
                const SizedBox(height: 20),
                Container(
                  width: flex.screenWidth,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category.categoryName,
                        style: AppTextStyle.normalTitle.copyWith(
                          letterSpacing: 2,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.category.descreption,
                        style: AppTextStyle.normalTitle.copyWith(
                          letterSpacing: 2,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: collectionProducts
                      .where('categorieId', isEqualTo: widget.category.id)
                      .snapshots(),
                  builder: (context, data) {
                    if (!data.hasData) {
                      return SizedBox(
                        width: flex.screenWidth,
                        height: flex.height(0.2),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primary,
                          ),
                        ),
                      );
                    }

                    final docs = data.data!.docs;
                    final products = docs
                        .map(
                          (doc) => ProudctModel.fromMap(
                            doc.data() as Map<String, dynamic>,
                          ),
                        )
                        .toList();

                    if (products.isEmpty) {
                      return SizedBox(
                        width: flex.screenWidth,
                        height: 200,
                        child: Center(
                          child: Text(
                            'no product',
                            style: AppTextStyle.normalText.copyWith(
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      width: flex.screenWidth,
                      child: ListView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: AdminPro0ductCart(product: products[i]),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.addProductScreeenAd,
            arguments: widget.category.id,
          ),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, color: AppColor.primary),
          ),
        ),
      ),
    );
  }
}
