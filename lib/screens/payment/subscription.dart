import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:meditation/screens/payment/payment_summary.dart';
import 'package:meditation/util/color.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rflutter_alert/rflutter_alert.dart';

class Subscription extends StatefulWidget {
  final bool isPaymentSuccess;
  Subscription({this.isPaymentSuccess});

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

Map selectedPlan = {
  'total_price': "90",
  'plan': "1 year",
  'discount': "~25%",
  'price': "120",
  'saving': "30",
};
bool month = false;
bool year = true;
bool month6 = false;

class _SubscriptionState extends State<Subscription> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Show payment failure alert.
    if (widget.isPaymentSuccess != null && !widget.isPaymentSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Alert(
          context: context,
          type: AlertType.error,
          title: "Failed",
          desc: "Oops!! something went wrong. Please try again",
          buttons: [
            DialogButton(
              child: Text(
                "Try again",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        foregroundDecoration: BoxDecoration(),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    primaryColor.withOpacity(.7), BlendMode.darken),
                alignment: Alignment.center,
                fit: BoxFit.cover,
                image: AssetImage('asset/img/bg/guideMeditation.jpg'))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.cancel,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListBody(
                    mainAxis: Axis.vertical,
                    children: <Widget>[
                      ListTile(
                        dense: true,
                        title: Text(
                          "Subscribe Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Lock and unlock contant for free users",
                          style: TextStyle(
                              color: Colors.white,
                              // Color(0xFF1A1A1A),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Create custom packages",
                          style: TextStyle(
                              color: Colors.white,
                              // Color(0xFF1A1A1A),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Package summary details",
                          style: TextStyle(
                              color: Colors.white,
                              // Color(0xFF1A1A1A),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Braintree payment gateway",
                          style: TextStyle(
                              color: Colors.white,
                              // Color(0xFF1A1A1A),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Credit/Debit card and Paypal support",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .99,
                    height: MediaQuery.of(context).size.height * .18,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          child: AnimatedContainer(
                            curve: Curves.linear,
                            height: !month ? 90 : 135,
                            width: !month
                                ? MediaQuery.of(context).size.width * .25
                                : MediaQuery.of(context).size.width * .29,
                            decoration: month
                                ? BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 5, color: Colors.yellow))
                                : null,
                            duration: Duration(milliseconds: 500),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .02),
                                Text("1",
                                    style: TextStyle(
                                        color: !month
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text("month",
                                    style: TextStyle(
                                        color: !month
                                            ? Colors.white
                                            : Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                Text(r"$10/M",
                                    style: TextStyle(
                                        color: !month
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                              ],
                              //      )),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              month = true;
                              month6 = false;
                              year = false;
                              selectedPlan = {
                                'price': "10",
                                'plan': "1 month",
                                'discount': "   ---",
                                'saving': "0.00",
                                'total_price': "10",
                              };
                            });
                          },
                        ),
                        InkWell(
                          child: ClipRect(
                            child: Banner(
                              location: BannerLocation.topEnd,
                              message: "SAVE 25%",
                              color: !year ? primaryColor : Colors.green,
                              child: AnimatedContainer(
                                  curve: Curves.linear,
                                  width: !year
                                      ? MediaQuery.of(context).size.width * .25
                                      : MediaQuery.of(context).size.width * .29,
                                  height: !year ? 90 : 135,
                                  decoration: year
                                      ? BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 5, color: Colors.yellow))
                                      : null,
                                  duration: Duration(milliseconds: 500),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                .02),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text("12",
                                            style: TextStyle(
                                                color: !year
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        Text("months",
                                            style: TextStyle(
                                                color: !year
                                                    ? Colors.white
                                                    : Colors.black54,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15)),
                                        Text(r"$90/Y",
                                            style: TextStyle(
                                                color: !year
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              month = false;
                              year = true;
                              month6 = false;
                              selectedPlan = {
                                'total_price': "90",
                                'plan': "1 year",
                                'discount': "~25%",
                                'price': "120",
                                'saving': "30",
                              };
                            });
                          },
                        ),
                        InkWell(
                          child: ClipRect(
                            child: Banner(
                              color: !month6 ? primaryColor : Colors.green,
                              location: BannerLocation.topEnd,
                              message: "SAVE ~17%",
                              child: AnimatedContainer(
                                  curve: Curves.linear,
                                  height: !month6 ? 90 : 135,
                                  width: !month6
                                      ? MediaQuery.of(context).size.width * .25
                                      : MediaQuery.of(context).size.width * .29,
                                  decoration: month6
                                      ? BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 5, color: Colors.yellow))
                                      : null,
                                  duration: Duration(milliseconds: 500),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .02),
                                      Text("6",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: !month6
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      Text("months",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: !month6
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontWeight: FontWeight.w600)),
                                      Text(r"$50/6M",
                                          style: TextStyle(
                                              color: !month6
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              month = false;
                              year = false;
                              month6 = true;
                              selectedPlan = {
                                'price': "60",
                                'plan': "6 months",
                                'discount': "~17%",
                                'saving': "10",
                                'total_price': "50",
                              };
                            });
                          },
                        ),
                      ],
                    ),
                    // ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(10),
                  //   child: Text(
                  //     """Try 7 days for free.
                  //           after then €39,99 / year. Billed yearly. Cancel anytime""",
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(color: Colors.white, fontSize: 12),
                  //   ),
                  // ),
                  Container(
                    height: 60,
                    width: 250,
                    child: InkWell(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                            child: Text(
                          "Continue",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                      onTap: () async {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            Future.delayed(
                              Duration(seconds: 4),
                              () {
                                Navigator.pop(context);
                              },
                            );

                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            );
                          },
                        );
                        var currentUser = await _firebaseAuth.currentUser();
                        Firestore.instance
                            .collection('fl_content')
                            .where('_fl_meta_.fl_id',
                                isEqualTo: currentUser.uid)
                            .getDocuments()
                            .then((QuerySnapshot snapshot) async {
                          var url = GlobalConfiguration().getString("cloudFunctionGenerateNonce");

                          var body = {};
                          if (snapshot.documents[0].data
                              .containsKey('customerId'))
                            body['customerId'] =
                                snapshot.documents[0].data['customerId'];

                          var response = await http.post(url, body: body);

                          var tokenizationKey = json.decode(response.body);

                          String totalPrice =
                              selectedPlan['total_price'].replaceAll(',', '.');

                          var request = BraintreeDropInRequest(
                            tokenizationKey: tokenizationKey,
                            collectDeviceData: true,
                            vaultManagerEnabled: true,
                            paypalRequest: BraintreePayPalRequest(
                              amount: totalPrice,
                              currencyCode: "USD",
                              displayName: 'Meditatio4Soul',
                            ),
                          );
                          BraintreeDropInResult result =
                              await BraintreeDropIn.start(request);
                          if (result != null) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Summary(
                                      selectedPlan: selectedPlan,
                                      paymentMethodNonce:
                                          result.paymentMethodNonce,
                                      fetchedUser: snapshot)),
                            );
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Terms & Conditions ",
                          style: TextStyle(color: Colors.white)),
                      Text("Privacy policy",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      """Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.""",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
