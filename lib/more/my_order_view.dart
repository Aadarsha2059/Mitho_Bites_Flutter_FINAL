import 'package:flutter/material.dart';
import 'package:fooddelivery_b/common/color_extension.dart';
import 'package:fooddelivery_b/common_widget/round_button.dart';

class CheckoutMessageView extends StatefulWidget {
  const CheckoutMessageView({super.key});

  @override
  State<CheckoutMessageView> createState() => _CheckoutMessageViewState();
}

class _CheckoutMessageViewState extends State<CheckoutMessageView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      width: media.width,
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), 
          topRight: Radius.circular(20)
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: TColor.primaryText,
                  size: 25,
                ),
              )
            ],
          ),
          Image.asset(
            "assets/img/thank_you.png",
            width: media.width * 0.55,
          ),
          const SizedBox(height: 25),
          Text(
            "Thank You!",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "for your order",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Your Order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your Order",
            textAlign: TextAlign.center,
            style: TextStyle(color: TColor.primaryText, fontSize: 14),
          ),
          const SizedBox(height: 35),
          RoundButton(title: "Track My Order", onPressed: () {}),
          TextButton(
            onPressed: () {},
            child: Text(
              "Back To Home",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class MyOrderView extends StatefulWidget {
  const MyOrderView({super.key});

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  List itemArr = [
    {"name": "Beef Burger", "qty": "1", "price": 16.0},
    {"name": "Classic Burger", "qty": "1", "price": 14.0},
    {"name": "Cheese Chicken Burger", "qty": "1", "price": 17.0},
    {"name": "Chicken Legs Basket", "qty": "1", "price": 15.0},
    {"name": "French Fires Large", "qty": "1", "price": 6.0}
  ];

  void _showCheckoutMessage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CheckoutMessageView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 46),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        "assets/img/btn_back.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "My Order",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        "assets/img/shop_logo.png",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "King Burgers",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Image.asset(
                                "assets/img/rate.png",
                                width: 10,
                                height: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "4.9",
                                style: TextStyle(
                                  color: TColor.primary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "(124 Ratings)",
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "Burger",
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                  fontSize: 12,
                                ),
                              ),
                              Text(" . ",
                                  style: TextStyle(
                                      color: TColor.primary, fontSize: 12)),
                              Text(
                                "Western Food",
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Image.asset(
                                "assets/img/location-pin.png",
                                width: 13,
                                height: 13,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "No 03, 4th Lane, Newyork",
                                  style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(color: TColor.textfield),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: itemArr.length,
                  separatorBuilder: (_, __) => Divider(
                    indent: 25,
                    endIndent: 25,
                    color: TColor.secondaryText.withOpacity(0.5),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    var cObj = itemArr[index] as Map? ?? {};
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "${cObj["name"]} x${cObj["qty"]}",
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "\$${cObj["price"]}",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Instructions",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add, color: TColor.primary),
                          label: Text(
                            "Add Notes",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: TColor.secondaryText.withOpacity(0.5),
                      height: 1,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sub Total",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                        Text("\$68",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Delivery Cost",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                        Text("\$2",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      color: TColor.secondaryText.withOpacity(0.5),
                      height: 1,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 15,
                                fontWeight: FontWeight.w800)),
                        Text("\$70",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    RoundButton(
                      title: "Checkout",
                      onPressed: _showCheckoutMessage,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
