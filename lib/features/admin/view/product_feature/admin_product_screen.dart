import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/features/admin/viewModel/admin_product_controller.dart';
import 'package:gym/features/admin/widgets/admin_product_cart.dart';
import 'package:gym/features/admin/widgets/qpp_bar.dart';
import 'package:gym/features/custommer/componants/custom_search.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  @override
  void initState() {
    Provider.of<AdminProductController>(context, listen: false).getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
    final productController = Provider.of<AdminProductController>(context);
    final flex = FlexibleSize(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBarAdmin(title: localise.product),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomSearch(
                onChanged: (value) {
                  productController.searchProducts(value);
                },
              ),
              productController.isLoading
                  ? Container(
                      width: flex.screenWidth,
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primary,
                        ),
                      ),
                    )
                  : productController.products.isEmpty
                      ? Container(
                          width: flex.screenWidth,
                          height: 300,
                          child: Center(child: Text('not product found')),
                        )
                      : SizedBox(
                          width: flex.screenWidth,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: productController.products.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return Padding(
                                padding:
                                    EdgeInsetsGeometry.symmetric(vertical: 10),
                                child: AdminPro0ductCart(
                                  product: productController.products[i],
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
