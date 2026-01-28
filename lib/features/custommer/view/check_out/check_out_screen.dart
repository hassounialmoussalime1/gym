import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/features/custommer/viewmodel/cart_controller.dart';
import 'package:gym/features/custommer/viewmodel/order_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CashOutPage extends StatefulWidget {
  const CashOutPage({super.key});

  @override
  State<CashOutPage> createState() => _CashOutPageState();
}

class _CashOutPageState extends State<CashOutPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final cartController = Provider.of<CartController>(context);
    final orderController = Provider.of<OrderController>(context);
    final localise = AppLocalizations.of(context)!;
    final cartItems = cartController.cartItems;

    double subTotal = cartItems.fold(
      0.0,
      (sum, item) {
        double discount = item.discount;
        double finalPrice =
            discount > 0 ? item.price * (1 - discount / 100) : item.price;
        return sum + finalPrice * item.qty;
      },
    );

    double shipping = 2;
    double total = subTotal + shipping;

    return Scaffold(
      appBar: AppBar(
        title: Text(localise.checkOut),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: flex.deviceType == DeviceType.mobile ? 20 : 80,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= ORDER SUMMARY =================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localise.orderSummary,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...cartItems.map(
                      (item) {
                        double discount = item.discount;
                        double finalPrice = discount > 0
                            ? item.price * (1 - discount / 100)
                            : item.price;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item.title} x${item.qty}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Row(
                                children: [
                                  if (discount > 0)
                                    Text(
                                      "KWD ${(item.price * item.qty).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "KWD ${(finalPrice * item.qty).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(height: 30),
                    _buildSummaryLine(localise.subTotal, subTotal),
                    _buildSummaryLine(localise.shipping, shipping),
                    _buildSummaryLine(localise.totale, total, bold: true),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // ================= INPUT FIELDS =================
              _buildTextField(localise.name, nameController),
              const SizedBox(height: 20),
              _buildTextField(
                localise.phone,
                phoneController,
                keyboard: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                localise.location,
                addressController,
                maxLines: 3,
              ),
              Container(
                width: flex.screenWidth,
                alignment: Alignment.centerRight,
                child: Text(
                  'مدة وصول الطلبية من يوم الى ثلاثة ايام',
                  style: TextStyle(color: AppColor.primary, fontSize: 15),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: (cartItems.isEmpty || isLoading)
                ? null
                : () async {
                    // التحقق من الحقول المطلوبة
                    if (nameController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        addressController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all the fields."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    setState(() => isLoading = true);

                    // إضافة الطلب
                    orderController.addOrder(
                      total,
                      nameController.text,
                      phoneController.text,
                      addressController.text,
                      cartController.cartItems,
                    );

                    // تفريغ الكارت
                    cartController.clearCart();

                    setState(() => isLoading = false);

                    // الانتقال لصفحة شكرا لك
                    if (mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ThankYouPage()),
                      );
                    }
                  },
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    localise.confirmPayement,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryLine(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "KWD ${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: bold ? AppColor.primary : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          // ignore: deprecated_member_use
          hintStyle: TextStyle(color: AppColor.primary.withOpacity(0.5)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.primary),
          ),
        ),
      ),
    );
  }
}

// ------------------ THANK YOU PAGE ------------------
class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 20),
            Icon(Icons.check_circle, color: AppColor.primary, size: 80),
            const SizedBox(height: 20),
            Text(
              localise.thanks,
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                localise.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'serif',
                ),
              ),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.home, (context) => true);
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 50,
                child: Center(
                  child: Text(localise.gobakce,
                      style: AppTextStyle.normalTextBold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
