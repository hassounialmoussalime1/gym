import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/features/admin/viewModel/admin_product_controller.dart';
import 'package:provider/provider.dart';

class AdminPro0ductCart extends StatelessWidget {
  final ProudctModel product;
  const AdminPro0ductCart({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final productMv = Provider.of<AdminProductController>(context);

    // السعر بعد الخصم
    double finalPrice = (product.discount > 0)
        ? product.price * (1 - product.discount / 100)
        : product.price;

    return Container(
      width: flex.width(0.9),
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // صورة المنتج + Badge للخصم
          Stack(
            children: [
              Container(
                height: flex.height(0.1),
                width: flex.height(0.1),
                color: Colors.white,
                child: Image.network(product.image),
              ),
              if (product.discount > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '-${product.discount.toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(width: flex.width(0.010)),

          // معلومات المنتج
          Container(
            width: flex.width(0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product.title, style: AppTextStyle.normalTextBold),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // السعر بعد الخصم
                    Text(
                      '${finalPrice.toStringAsFixed(2)} KWD',
                      style: AppTextStyle.normalTextBold,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.updateProductScreeenAd,
                            arguments: product,
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            color: AppColor.primary,
                          ),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            chowDialog(context, productMv, product.id);
                          },
                          child: Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<dynamic> chowDialog(
  BuildContext context,
  AdminProductController productVM,
  String prodId,
) {
  final parentContext = context; // 👈 context الأصلي

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog

              await productVM.deleteProduct(prodId);

              // 👈 استخدم context الأساسي وليس تبع dialog
              ScaffoldMessenger.of(parentContext).showSnackBar(
                const SnackBar(content: Text("Product deleted successfully")),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
