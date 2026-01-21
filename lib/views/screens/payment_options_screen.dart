import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/components/custom_loader.dart';
import '/components/slide_animations.dart';
import '/controllers/payment_controller.dart';

import '../../components/validations.dart';
import '../../constants/app_brand.dart';
import '../../enums/enums.dart';
import '../../includes/payment_option_tile.dart';
import '../../models/mno.dart';
import '../../theme/app_colors.dart';

class PaymentOptionsScreen extends StatefulWidget {
  final List<int> courseIds;
  final double totalAmount;
  const PaymentOptionsScreen({
    super.key,
    required this.totalAmount,
    required this.courseIds,
  });

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  final paymentController = Get.put(PaymentController());

  @override
  void initState() {
    paymentController.phoneController.addListener(() {
      paymentController.update();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final double topPadding =
        Platform.isAndroid ? statusBarHeight + 15 : statusBarHeight;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondaryColor, AppColors.primaryColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 80.0,
                  collapsedHeight: 0.0,
                  toolbarHeight: 0.0,
                  floating: true,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  flexibleSpace:
                      Container(), // Empty container to satisfy the requirement
                ),
              ],
            ),
            Positioned.fill(
              top: topPadding + 55,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GetBuilder<PaymentController>(
                    builder: (paymentController) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose Payment Method".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap:
                                () => setState(
                                  () =>
                                      paymentController.selectedMethod =
                                          PaymentMethod.MOBILE,
                                ),
                            child: paymentOptionTile(
                              isSelected:
                                  paymentController.selectedMethod ==
                                  PaymentMethod.MOBILE,
                              title: "Mobile Payment".tr,
                              alignment: MainAxisAlignment.spaceBetween,
                              options: [
                                ServiceProvider(
                                  name: ServiceProviderName.MIXX,
                                  logo: "assets/images/mobile_payments/mixx.png",
                                  backColor: const Color.fromARGB(
                                    255,
                                    4,
                                    53,
                                    138,
                                  ),
                                  foreColor: Colors.amber,
                                ),
                                ServiceProvider(
                                  name: ServiceProviderName.MPESA,
                                  logo: "assets/images/mobile_payments/mpesa.png",
                                  backColor: const Color.fromARGB(
                                    255,
                                    235,
                                    36,
                                    22,
                                  ),
                                  foreColor: null,
                                ),
                                ServiceProvider(
                                  name: ServiceProviderName.AIRTEL_MONEY,
                                  logo: "assets/images/mobile_payments/airtelmoney.png",
                                  backColor: const Color.fromARGB(
                                    255,
                                    172,
                                    24,
                                    13,
                                  ),
                                  foreColor: null,
                                ),
                                ServiceProvider(
                                  name: ServiceProviderName.HALOPESA,
                                  logo: "assets/images/mobile_payments/halopesa.png",
                                  backColor: const Color.fromARGB(
                                    255,
                                    255,
                                    127,
                                    7,
                                  ),
                                  foreColor: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),

                          // OPTION 2: Card Payment
                          GestureDetector(
                            onTap:
                                () => setState(
                                  () =>
                                      paymentController.selectedMethod =
                                          PaymentMethod.CARD,
                                ),
                            child: paymentOptionTile(
                              isSelected:
                                  paymentController.selectedMethod ==
                                  PaymentMethod.CARD,
                              title: "Pay by Card".tr,
                              alignment: MainAxisAlignment.spaceBetween,
                              options: [
                                ServiceProvider(
                                  name: ServiceProviderName.VISA,
                                  logo: "assets/images/card_payments/visa.png",
                                  backColor: Colors.white,
                                  foreColor: null,
                                ),
                                ServiceProvider(
                                  name: ServiceProviderName.MASTERCARD,
                                  logo: "assets/images/card_payments/mastercard.png",
                                  backColor: Colors.white,
                                  foreColor: null,
                                ),
                                ServiceProvider(
                                  name: ServiceProviderName.DINERS,
                                  logo: "assets/images/card_payments/diners.png",
                                  backColor: Colors.white,
                                  foreColor: null,
                                ),
                                ServiceProvider(
                                  name: ServiceProviderName.PCI,
                                  logo: "assets/images/card_payments/pci.png",
                                  backColor: Colors.white,
                                  foreColor: null,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                          if (paymentController.selectedMethod !=
                              PaymentMethod.NONE)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${"Phone Number".tr} ${paymentController.selectedMethod == PaymentMethod.MOBILE ? "For Payment".tr : ""}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                BottomTopSlide(
                                  child: SizedBox(
                                    height: 60,

                                    child: TextFormField(
                                      enabled: !paymentController.isLoading,
                                      cursorColor: Colors.white,
                                      maxLength: 9,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      controller:
                                          paymentController.phoneController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        TZPhoneValidator(),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: TextStyle(
                                        color:
                                            paymentController.isLoading
                                                ? Colors.grey[700]
                                                : Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(5),
                                        prefixText: "🇹🇿 +255 ",
                                        prefixStyle: TextStyle(
                                          color:
                                              paymentController.isLoading
                                                  ? Colors.grey[700]
                                                  : Colors.white,
                                          fontSize: 16,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.1,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        counterStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          SizedBox(width: 20),
                          if (paymentController.selectedMethod !=
                                  PaymentMethod.NONE &&
                              paymentController.phoneController.text.length ==
                                  9)
                            Align(
                              alignment: Alignment.center,
                              child: BottomTopSlide(
                                child: ElevatedButton(
                                  onPressed:
                                      paymentController.isLoading
                                          ? null
                                          : () {
                                            paymentController.selectedMethod ==
                                                    PaymentMethod.CARD
                                                ? paymentController
                                                    .submitCardPayment(
                                                      widget.courseIds,
                                                      widget.totalAmount,
                                                      context,
                                                    )
                                                : paymentController
                                                    .submitMobilePayment(
                                                      widget.courseIds,
                                                      widget.totalAmount,
                                                      context,
                                                    );
                                          },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.tertiaryColor,
                                    surfaceTintColor: AppColors.tertiaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  child:
                                      paymentController.isLoading
                                          ? customLoader()
                                          : Text(
                                            "${"Pay".tr} ${getMoneyFormat(widget.totalAmount)}",
                                            style: const TextStyle(
                                              color: Color(0xFF071B1A),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            appBrand(context: context, hasBackButton: true),
          ],
        ),
      ),
    );
  }
}
