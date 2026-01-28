import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/features/admin/viewModel/admin_order_controller.dart';
import 'package:gym/features/admin/widgets/product_cart.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreenAdmn extends StatefulWidget {
  final String idOrder;
  const OrderDetailScreenAdmn({super.key, required this.idOrder});

  @override
  State<OrderDetailScreenAdmn> createState() => _OrderDetailScreenAdmnState();
}

class _OrderDetailScreenAdmnState extends State<OrderDetailScreenAdmn> {
  final List<String> orderStatusOptions = [
    "New",
    "pending",
    "processing",
    "delivered",
    "cancelled",
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<AdminOrderController>(
      context,
      listen: false,
    ).fetchOrder(widget.idOrder);
  }

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
    final flex = FlexibleSize(context);
    return Consumer<AdminOrderController>(
      builder: (context, c, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(localise.OrderInfo),
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColor.primary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: c.isLoading
              ? const Center(child: CircularProgressIndicator())
              : c.order == null
                  ? const Center(child: Text('No order data'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          buildOrderInfoSection(c, flex),
                          buildOrderStatusSection(c, flex),
                          buildProductList(c),
                          buildShippingSection(c, flex),
                          buildPriceSection(c, flex),

                          // الرسالة الجاهزة
                        ],
                      ),
                    ),
          bottomNavigationBar: _buttonSendImvoice(
            flex,
            () => openWhatsAppWeb(
              phoneNumber: '965${c.order!.phone}', // رقم الزبون
              message: '''
مرجبا ${c.order!.name},
فاتورتك هي :

${c.order!.products.map((p) {
                final discountedPrice = p.price * (1 - (p.discount) / 100);
                return '${p.title}: ${p.qty} x ${discountedPrice.toStringAsFixed(2)}KWD = ${(p.qty * discountedPrice).toStringAsFixed(2)}KWD';
              }).join('\n')}

كلفة التوصيل: 2 kwd
المجموع: ${(c.order!.totalePrice).toStringAsFixed(2)}\$

مدة وصول الطلبية من يوم الى ثلاثة ايام

POWERGEAR
اهلا وسهلا
''',
            ),
          ),
        );
      },
    );
  }

  // ================= SECTIONS =================

  Widget buildOrderStatusSection(AdminOrderController c, FlexibleSize flex) {
    final localise = AppLocalizations.of(context)!;
    return sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(localise.OrderStatus),
          DropdownButtonFormField<String>(
            initialValue: c.selectedStatus,
            dropdownColor: Colors.black,
            decoration: inputDecoration(),
            style: const TextStyle(color: Colors.white),
            items: orderStatusOptions.map((status) {
              return DropdownMenuItem(value: status, child: Text(status));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                c.changeStatus(widget.idOrder, value);
              }
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget buildOrderInfoSection(AdminOrderController c, FlexibleSize flex) {
    final localise = AppLocalizations.of(context)!;
    return sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(localise.OrderInfo),
          infoText('${localise.orderId}: #${c.order!.numberOrder}'),
          infoText(
            '${localise.date} : ${c.order!.dateSendOrder!.day}-${c.order!.dateSendOrder!.month}-${c.order!.dateSendOrder!.year}',
          ),
          infoText('${localise.clientName} : ${c.order!.name}'),
        ],
      ),
    );
  }

  Widget buildProductList(AdminOrderController c) {
    return Column(
      children: List.generate(c.order!.products.length, (index) {
        final product = c.order!.products[index];

        return ProductCart(
          title: product.title,
          imageUrl: product.image,
          priceUSD: product.price.toDouble(),
          qty: product.qty,
          discount: product.discount,
          onQtyChanged: (newQty) {
            c.changeQty(widget.idOrder, index, newQty);
          },
        );
      }),
    );
  }

  Widget buildShippingSection(AdminOrderController c, FlexibleSize flex) {
    final localise = AppLocalizations.of(context)!;
    return sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(localise.ShippingDetail),
          infoText('${localise.adress} : ${c.order!.adress}'),
          infoText('${localise.phone} : ${c.order!.phone}'),
        ],
      ),
    );
  }

  Widget buildPriceSection(AdminOrderController c, FlexibleSize flex) {
    final localise = AppLocalizations.of(context)!;
    return sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(localise.priceDetail),
          infoText('totale USD : ${c.order!.totalePrice.toStringAsFixed(2)}'),
          infoText(
            'totale KWD : ${(c.order!.totalePrice * 0.307).toStringAsFixed(3)}',
          ),
        ],
      ),
    );
  }

  Widget sectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }

  Widget sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.normalText.copyWith(
            color: AppColor.primary,
            fontSize: 15,
          ),
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }

  Widget infoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: AppTextStyle.normalText.copyWith(
          color: const Color.fromARGB(255, 205, 205, 205),
        ),
      ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none,
      ),
    );
  }

  //send imvoice to client
  Widget _buttonSendImvoice(FlexibleSize flex, VoidCallback onTap) {
    final localise = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsGeometry.all(10),
        child: Container(
          width: flex.screenWidth,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 40,
          alignment: Alignment.center,
          child: Text(localise.sendToWatsap, style: AppTextStyle.normalText),
        ),
      ),
    );
  }
}

Future<void> openWhatsAppWeb({
  required String phoneNumber,
  required String message,
}) async {
  final encodedMessage = Uri.encodeComponent(message);
  final url = 'https://wa.me/$phoneNumber?text=$encodedMessage';
  final uri = Uri.parse(url);

  try {
    await launchUrl(uri); // على الويب، لا تحتاج canLaunch
  } catch (e) {
    if (kDebugMode) {
      print('Could not launch WhatsApp: $e');
    }
  }
}
