import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation/util/color.dart';
import 'payment_progress.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class Summary extends StatefulWidget {
  final Map selectedPlan;
  final BraintreePaymentMethodNonce paymentMethodNonce;
  final QuerySnapshot fetchedUser;
  Summary({this.selectedPlan, this.paymentMethodNonce, this.fetchedUser});

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Payment details"),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Payment Summary:",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 23)),
                  ),
                ]),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      DataTable(
                        columnSpacing: MediaQuery.of(context).size.width * .45,
                        columns: [
                          DataColumn(
                              label: Text(
                            "Plan",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                          DataColumn(
                              label: Text("${widget.selectedPlan['plan']}",
                                  style: TextStyle(
                                    fontSize: 15,
                                     color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ))),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text("Price",
                                style: TextStyle(
                                  fontSize: 15,
                                ))),
                            DataCell(Text("\$${widget.selectedPlan['price']}",
                                style: TextStyle(
                                  fontSize: 15,
                                //  color: primaryColor,
                                ))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("Discount",
                                style: TextStyle(
                                  fontSize: 15,
                                ))),
                            DataCell(Text("${widget.selectedPlan['discount']}",
                                style: TextStyle(
                                  fontSize: 15,
                                ))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("Your total\nsavings",
                                style: TextStyle(
                                  fontSize: 15,
                                ))),
                            DataCell(Text("\$${widget.selectedPlan['saving']}",
                                style: TextStyle(
                                  fontSize: 15,
                                ))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("TOTAL",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text(
                                "\$${widget.selectedPlan['total_price']}",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold))),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Divider(
                    color: Colors.black,
                    indent: 0.5,
                  ),
                ),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Payment Method:",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 23)),
                  ),
                ]),
                widget.paymentMethodNonce.typeLabel == "PayPal"
                    ? Card(
                        color: primaryColor,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: ListTile(
                            leading: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                            ),
                            trailing: Text(
                                "${widget.paymentMethodNonce.typeLabel}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20)),
                            // trailing: Text(
                            //     "", //${widget.paymentMethodNonce.description}
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.w400,
                            //         fontSize: 15)),
                          ),
                        ),
                      )
                    : Card(
                        color: primaryColor,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: ListTile(
                            leading: Icon(
                              Icons.credit_card,
                              color: Colors.white,
                            ),
                            title: Text(
                                "${widget.paymentMethodNonce.typeLabel}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20)),
                            trailing: Text(
                                "${widget.paymentMethodNonce.description}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15)),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Divider(
                    color: Colors.black,
                    indent: 0.5,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 60,
                  width: 250,
                  child: InkWell(
                    child: Card(
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                          child: Text(
                        "Pay Now",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      )),
                    ),
                    onTap: () {
                      String totalPrice = widget.selectedPlan['total_price']
                          .replaceAll(',', '.');
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Progress(
                                  widget.paymentMethodNonce,
                                  totalPrice,
                                  widget.fetchedUser)));
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<bool> willPop() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you want to cancel the payment?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
