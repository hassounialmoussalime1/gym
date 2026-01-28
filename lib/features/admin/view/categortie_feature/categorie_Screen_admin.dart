// ignore: file_names
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/features/admin/viewModel/admin_categorie_Controler.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CategorieScreenAdmin extends StatefulWidget {
  const CategorieScreenAdmin({super.key});

  @override
  State<CategorieScreenAdmin> createState() => _CategorieScreenAdminState();
}

class _CategorieScreenAdminState extends State<CategorieScreenAdmin> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminCategorieController>(
        context,
        listen: false,
      ).getCategire();
    });
  }

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final localise = AppLocalizations.of(context)!;
    final categorieController = Provider.of<AdminCategorieController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColor.primary),
        ),
        titleSpacing: 0,
        title: Text(
          localise.categories,
          style: AppTextStyle.normalText.copyWith(
            color: AppColor.primary,
            fontSize: 16,
          ),
        ),
      ),
      body: categorieController.isLoading
          ? SizedBox(
              width: flex.screenWidth,
              height: 200,
              child: const Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categorieController.categories.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.categorieDetailScreenAd,
                          arguments: categorieController.categories[i],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: AppColor.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: flex.screenWidth,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                categorieController.categories[i].categoryName,
                                style: AppTextStyle.normalText.copyWith(
                                  color: AppColor.primary,
                                  fontSize: 16,
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).pushNamed(
                                  AppRoutes.updateCAtegorieScreen,
                                  arguments: categorieController.categories[i],
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 25,
                                  color: AppColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.addCategorieScreen),
        child: Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            color: AppColor.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 25),
        ),
      ),
    );
  }
}
