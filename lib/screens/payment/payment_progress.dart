import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:meditation/screens/home.dart';
import 'package:meditation/screens/payment/subscription.dart';
import 'package:meditation/util/color.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Progress extends StatefulWidget {
  final BraintreePaymentMethodNonce paymentMethodNonce;
  final String totalPrice;
  final QuerySnapshot fetchedUser;

  Progress(this.paymentMethodNonce, this.totalPrice, this.fetchedUser);
  @override
  _ProgressState createState() {
    return new _ProgressState();
  }
}

class _ProgressState extends State<Progress> {
  String plan = '1 Month';
  @override
  initState() {
    super.initState();
    _processPayment();

    // The delay fixes it
    // Future.delayed(Duration(milliseconds: 4000)).then((_) {

    // });
  }

  _processPayment() async {
    var url = GlobalConfiguration().getString("cloudFunctionPay");

    var body = {
      'paymentNonce': widget.paymentMethodNonce.nonce,
      'amount': widget.totalPrice,
      'id': widget.fetchedUser.documents[0].data['_fl_meta_']['fl_id'],
      'name': widget.fetchedUser.documents[0].data['name']
    };

    if (widget.fetchedUser.documents[0].data.containsKey('customerId'))
      body['customerId'] = widget.fetchedUser.documents[0].data['customerId'];

    var response;
    try {
      response = await http.post(url, body: body);
      response = json.decode(response.body);

      if (response['data']['success']) {
        _updateUser(response);
      } else {
        throw new Error();
      }
    } catch (err) {
      print(err);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => Subscription(isPaymentSuccess: false)),
      );
    }

    return response;
  }

  _updateUser(response) async {
    var expiryDate;
    if (widget.totalPrice == '10')
      expiryDate = DateTime.parse(response['data']['transaction']['createdAt'])
          .toLocal()
          .add(new Duration(days: 31));
    else if (widget.totalPrice == '50') {
      plan = '6 Months';
      expiryDate = DateTime.parse(response['data']['transaction']['createdAt'])
          .toLocal()
          .add(new Duration(days: 183));
    } else if (widget.totalPrice == '90') {
      plan = '1 Year';
      expiryDate = DateTime.parse(response['data']['transaction']['createdAt'])
          .toLocal()
          .add(new Duration(days: 365));
    }

    Map<String, dynamic> updateObject = {
      "transaction": FieldValue.arrayUnion([
        {
          'expiryDate': expiryDate.toString(),
          "transactionId": response['data']['transaction']['id'],
          "amount": response['data']['transaction']['amount'],
          "subscribedAt":
              DateTime.parse(response['data']['transaction']['createdAt'])
                  .toLocal()
                  .toString()
        }
      ])
    };

    if (!widget.fetchedUser.documents[0].data.containsKey('customerId'))
      updateObject['customerId'] =
          response['data']['transaction']['customer']['id'];

    await Firestore.instance
        .collection("fl_content")
        .document(widget.fetchedUser.documents[0].data['_fl_meta_']['fl_id'])
        .updateData(updateObject);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('expiryDate', expiryDate.toString());
    prefs.setBool('isTrial', false);

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) {
        return Home(
          isPaymentSuccess: true,
          plan: plan,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
              backgroundColor: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Processing... Please wait\n[ Please do not press back button or refresh ]",
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
