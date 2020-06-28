import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meditation/screens/payment/subscription.dart';
import 'package:meditation/util/color.dart';
import 'dart:math' as math;

var username;
bool edit = false;
String joindate;
String mail;
var photourl;
var transaction = [];

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

final TextEditingController phnctlr = new TextEditingController();
final TextEditingController emailctlr = new TextEditingController();
ScrollController scrollController = ScrollController();
ScrollController horizontalController = ScrollController();
int childCount = 10;

int verticalPreviousIndex;
int horizontalPreviousIndex;
double verticalChildExtent = 300.0;
double horizontalChildExtent = 100.0;

class _EditProfileState extends State<EditProfile> {
  var uploadedFileURL;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  File _image;

  @override
  void initState() {
    // todo: implement initState
    super.initState();
    currentuser();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    phnctlr.dispose();
    emailctlr.dispose();
    super.dispose();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // CropAspectRatioPreset.ratio3x2,
            // CropAspectRatioPreset.original,
            // CropAspectRatioPreset.ratio4x3,
            // CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop',
              toolbarColor: primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      setState(() {
        _image = croppedFile;
      });
    }
  }

  Future uploadFile(BuildContext context) async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var user = await _firebaseAuth.currentUser();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('users/${user.uid}/myimage.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    if (uploadTask.isInProgress == true) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(' Uploading....'),
      ));
    }

    if (await uploadTask.onComplete != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(' Uploaded successfully'),
      ));
      storageReference.getDownloadURL().then((fileURL) async {
        uploadedFileURL = fileURL;
        try {
          await Firestore.instance
              .collection("fl_content")
              .document(user.uid)
              .setData({
            "email": emailctlr.text,
            "phone": phnctlr.text,
            "photoUrl": uploadedFileURL,
          }, merge: true);
        } catch (err) {
          print("Error: $err");
        }
        currentuser();
        _image = null;
      });
    }
  }

  updatedata() async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var user = await _firebaseAuth.currentUser();
    try {
      await Firestore.instance
          .collection("fl_content")
          .document(user.uid)
          .setData({
        "email": emailctlr.text,
        "phone": phnctlr.text,
      }, merge: true);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Profile updated."),
        duration: Duration(seconds: 5),
      ));
      currentuser();
    } catch (err) {
      print("Error: $err");
    }
  }

  currentuser() async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var user = await _firebaseAuth.currentUser();
    Firestore.instance
        .collection("fl_content")
        .document("${user.uid}")
        .snapshots()
        .listen((onData) async {
      if (this.mounted)
        setState(() {
          username = onData["name"] == null ? "" : onData["name"].toString();
          mail = onData["email"] == null ? "" : onData["email"].toString();
          emailctlr.text = mail;
          photourl = onData["photoUrl"].toString().length <= 0
              ? null
              //"https://source.unsplash.com/random/300×300/?profile"
              : onData["photoUrl"];
          phnctlr.text =
              onData["phone"] == null ? "" : onData["phone"].toString();
          joindate = onData["joiningDate"] == null
              ? ""
              : DateFormat.yMMMEd()
                  .format(DateTime.parse(onData["joiningDate"]))
                  .toString();
          transaction =
              onData["transaction"] == null ? [] : onData["transaction"];
        });
    });

    return user;
  }

  Container buildProfile(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      //width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(20)),
                        image: DecorationImage(
                            image: _image != null
                                ? FileImage(_image)
                                : photourl != null
                                    ? NetworkImage(photourl)
                                    : AssetImage("asset/img/dummy.jpeg"),
                            fit: BoxFit.cover))),
                // edit
                //     ? Container(
                //         alignment: Alignment.bottomRight,
                //         height: MediaQuery.of(context).size.height * .4,
                //         child: Container(
                //           height: 45,
                //           width: 45,
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             shape: BoxShape.circle,
                //           ),
                //           child: IconButton(
                //             icon: Icon(
                //               Icons.add_a_photo,
                //               color: primaryColor,
                //             ),
                //             onPressed: () {
                //               showDialog(
                //                   barrierDismissible: true,
                //                   context: context,
                //                   builder: (BuildContext context) {
                //                     return SimpleDialog(
                //                       title: Text("Select one"),
                //                       children: <Widget>[
                //                         SimpleDialogOption(
                //                           child: Text(
                //                             "Gallery",
                //                             style: TextStyle(
                //                               fontSize: 18,
                //                             ),
                //                           ),
                //                           onPressed: () {
                //                             getImage();
                //                             Navigator.pop(context);
                //                           },
                //                         ),
                //                         SimpleDialogOption(
                //                           child: Text(
                //                             "Cancel",
                //                             style: TextStyle(
                //                               fontSize: 18,
                //                             ),
                //                           ),
                //                           onPressed: () {
                //                             Navigator.pop(context);
                //                           },
                //                         )
                //                       ],
                //                     );
                //                   });
                //             },
                //           ),
                //         ))
                //     : SizedBox(),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2 - 20,
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(left: 10, bottom: 30),
            child: Text(
              "$username",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: FloatingActionButton(
            elevation: 10,
            child: BackButton(
              color: Colors.black,
            ),
            backgroundColor: Colors.white38,
            onPressed: () {
              dispose();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Center(
        child: Container(
          child: joindate == null && username == null
              ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                )
              : SafeArea(
                  top: false,
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      // Add the app bar to the CustomScrollView.
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        title: Text("Edit Profile"),
                        backgroundColor: Theme.of(context).primaryColor,
                        // Provide a standard title.
                        // Allows the user to reveal the app bar if they begin scrolling
                        // back up the list of items.

                        pinned: true,

                        // Display a placeholder widget to visualize the shrinking size.
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          // title: Text("I WANT FOOD",
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 16.0,
                          //     )),
                          background: Column(
                            children: <Widget>[
                              Flexible(child: buildProfile(context))
                            ],
                          ),
                        ),
                        // Make the initial height of the SliverAppBar larger than normal.
                        expandedHeight:
                            MediaQuery.of(context).size.height * .36,
                      ),

                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          minHeight: 60.0,

                          //WARNING: Changing this will affect the vertical index calculation.
                          maxHeight: 60.0,
                          child: Container(
                            color: Colors.transparent,
                            child: edit
                                ? Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 32),
                                    alignment: Alignment.centerRight,
                                    height:
                                        MediaQuery.of(context).size.height * .4,
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add_a_photo,
                                          color: primaryColor,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SimpleDialog(
                                                  title: Text("Select one"),
                                                  children: <Widget>[
                                                    SimpleDialogOption(
                                                      child: Text(
                                                        "Gallery",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        getImage();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    SimpleDialogOption(
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                    ))
                                : SizedBox(),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            // buildProfile(context),
                            const SizedBox(height: 20),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Form(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                        title: Text("User information"),
                                        trailing: !edit
                                            ? FlatButton.icon(
                                                splashColor: Colors.blue,
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: primaryColor,
                                                ),
                                                label: Text("edit"),
                                                onPressed: () {
                                                  setState(() {
                                                    edit = true;
                                                  });
                                                },
                                              )
                                            : SizedBox()),
                                    Divider(),
                                    edit
                                        ? ListTile(
                                            title: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              readOnly: mail.length != 0
                                                  // !edit || emailctlr.text.length != 0
                                                  ? true
                                                  : false,
                                              decoration: InputDecoration(
                                                  hintText: "abc@gmail.com",
                                                  helperText:
                                                      "Immutable if set once.",
                                                  labelText: "Email",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20)),
                                              controller: emailctlr,
                                              onSaved: (value) {
                                                emailctlr.text = value;
                                              },
                                            ),
                                            leading: Icon(Icons.email),
                                          )
                                        : ListTile(
                                            leading: Icon(Icons.email),
                                            title: Text("Email"),
                                            subtitle: Text("${emailctlr.text}"),
                                          ),
                                    edit
                                        ? ListTile(
                                            title: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              readOnly: !edit ? true : false,
                                              decoration: InputDecoration(
                                                  labelText: "Phone",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20)),
                                              controller: phnctlr,
                                              onSaved: (value) {
                                                phnctlr.text = value;
                                              },
                                            ),
                                            leading: Icon(Icons.phone),
                                          )
                                        : ListTile(
                                            title: Text("Phone"),
                                            leading: Icon(Icons.phone),
                                            subtitle: Text("${phnctlr.text}"),
                                          ),
                                    ListTile(
                                      title: Text("Joined Date"),
                                      subtitle: Text("$joindate"),
                                      leading: Icon(Icons.calendar_view_day),
                                    ),
                                    edit
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Builder(builder:
                                                  (BuildContext context) {
                                                return FlatButton.icon(
                                                  splashColor: Colors.blue,
                                                  icon: Icon(
                                                    Icons.done,
                                                    color: Colors.green,
                                                  ),
                                                  label: Text("Submit"),
                                                  onPressed: () async {
                                                    _image == null
                                                        ? updatedata()
                                                        : await uploadFile(
                                                            context);

                                                    setState(() {
                                                      edit = false;
                                                    });
                                                  },
                                                );
                                              }),
                                              FlatButton.icon(
                                                splashColor: Colors.blue,
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                ),
                                                label: Text("Cancel"),
                                                onPressed: () {
                                                  //for on cancel editing to show data as it is
                                                  setState(() {
                                                    currentuser();
                                                    _image = null;

                                                    edit = false;
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Subscriptions"),
                                  ),
                                  Divider(),
                                  transaction.length > 0
                                      ? ListView(
                                          shrinkWrap: true,
                                          children: transaction
                                              .map((item) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Wrap(
                                                      runSpacing: 10,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              "TransactionId",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Text(item[
                                                                'transactionId']),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              "Amount",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Text(
                                                                '\$${item['amount']}'),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              "Subscribed on",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Text(DateFormat
                                                                    .yMMMEd()
                                                                .format(DateTime
                                                                        .parse(item[
                                                                            'subscribedAt'])
                                                                    .toLocal())
                                                                .toString()),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              "Expiry",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Text(DateFormat
                                                                    .yMMMEd()
                                                                .format(DateTime
                                                                        .parse(item[
                                                                            'expiryDate'])
                                                                    .toLocal())
                                                                .toString()),
                                                          ],
                                                        ),
                                                        Divider()
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      : Column(
                                          children: <Widget>[
                                            Text(
                                                "You don't have any subscriptions yet."),
                                            Text(
                                                "Subscribe now to get access to unlimited content."),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            FlatButton(
                                              color: primaryColor,
                                              textColor: Colors.white,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          Subscription()),
                                                );
                                              },
                                              child: Text('SUBSCRIBE NOW'),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 300,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  // child: ListView(
                  //   shrinkWrap: true,
                  //   children: <Widget>[
                  //     buildProfile(context),
                  //     const SizedBox(height: 20),
                  //     Container(
                  //       margin: const EdgeInsets.symmetric(horizontal: 30),
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(5.0),
                  //       ),
                  //       child: Form(
                  //         child: Column(
                  //           children: <Widget>[
                  //             ListTile(
                  //                 title: Text("User information"),
                  //                 trailing: !edit
                  //                     ? FlatButton.icon(
                  //                         splashColor: Colors.blue,
                  //                         icon: Icon(
                  //                           Icons.edit,
                  //                           color: primaryColor,
                  //                         ),
                  //                         label: Text("edit"),
                  //                         onPressed: () {
                  //                           setState(() {
                  //                             edit = true;
                  //                           });
                  //                         },
                  //                       )
                  //                     : SizedBox()),
                  //             Divider(),
                  //             edit
                  //                 ? ListTile(
                  //                     title: TextFormField(
                  //                       style: TextStyle(
                  //                           color: Colors.black54),
                  //                       readOnly: mail.length != 0
                  //                           // !edit || emailctlr.text.length != 0
                  //                           ? true
                  //                           : false,
                  //                       decoration: InputDecoration(
                  //                           hintText: "abc@gmail.com",
                  //                           helperText:
                  //                               "Immutable if set once.",
                  //                           labelText: "Email",
                  //                           labelStyle: TextStyle(
                  //                               color: Colors.black,
                  //                               fontSize: 20)),
                  //                       controller: emailctlr,
                  //                       onSaved: (value) {
                  //                         emailctlr.text = value;
                  //                       },
                  //                     ),
                  //                     leading: Icon(Icons.email),
                  //                   )
                  //                 : ListTile(
                  //                     leading: Icon(Icons.email),
                  //                     title: Text("Email"),
                  //                     subtitle: Text("${emailctlr.text}"),
                  //                   ),
                  //             edit
                  //                 ? ListTile(
                  //                     title: TextFormField(
                  //                       keyboardType: TextInputType.number,
                  //                       style: TextStyle(
                  //                           color: Colors.black54),
                  //                       readOnly: !edit ? true : false,
                  //                       decoration: InputDecoration(
                  //                           labelText: "Phone",
                  //                           labelStyle: TextStyle(
                  //                               color: Colors.black,
                  //                               fontSize: 20)),
                  //                       controller: phnctlr,
                  //                       onSaved: (value) {
                  //                         phnctlr.text = value;
                  //                       },
                  //                     ),
                  //                     leading: Icon(Icons.phone),
                  //                   )
                  //                 : ListTile(
                  //                     title: Text("Phone"),
                  //                     leading: Icon(Icons.phone),
                  //                     subtitle: Text("${phnctlr.text}"),
                  //                   ),
                  //             ListTile(
                  //               title: Text("Joined Date"),
                  //               subtitle: Text("$joindate"),
                  //               leading: Icon(Icons.calendar_view_day),
                  //             ),
                  //             edit
                  //                 ? Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceAround,
                  //                     children: <Widget>[
                  //                       Builder(builder:
                  //                           (BuildContext context) {
                  //                         return FlatButton.icon(
                  //                           splashColor: Colors.blue,
                  //                           icon: Icon(
                  //                             Icons.done,
                  //                             color: Colors.green,
                  //                           ),
                  //                           label: Text("Submit"),
                  //                           onPressed: () async {
                  //                             _image == null
                  //                                 ? updatedata()
                  //                                 : await uploadFile(
                  //                                     context);

                  //                             setState(() {
                  //                               edit = false;
                  //                             });
                  //                           },
                  //                         );
                  //                       }),
                  //                       FlatButton.icon(
                  //                         splashColor: Colors.blue,
                  //                         icon: Icon(
                  //                           Icons.cancel,
                  //                           color: Colors.red,
                  //                         ),
                  //                         label: Text("Cancel"),
                  //                         onPressed: () {
                  //                           //for on cancel editing to show data as it is
                  //                           setState(() {
                  //                             currentuser();
                  //                             _image = null;

                  //                             edit = false;
                  //                           });
                  //                         },
                  //                       ),
                  //                     ],
                  //                   )
                  //                 : Container(),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Divider(),
                  //     Container(
                  //       margin: const EdgeInsets.symmetric(horizontal: 30),
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(5.0),
                  //       ),
                  //       child: Column(
                  //         children: <Widget>[
                  //           ListTile(
                  //             title: Text("Subscriptions"),
                  //           ),
                  //           Divider(),
                  //           transaction.length > 0
                  //               ? ListView(
                  //                   shrinkWrap: true,
                  //                   children: transaction
                  //                       .map((item) => Padding(
                  //                             padding: const EdgeInsets.all(
                  //                                 10.0),
                  //                             child: Wrap(
                  //                               runSpacing: 10,
                  //                               children: <Widget>[
                  //                                 Row(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .spaceBetween,
                  //                                   children: <Widget>[
                  //                                     Text(
                  //                                       "TransactionId",
                  //                                       style: TextStyle(
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w500),
                  //                                     ),
                  //                                     Text(item[
                  //                                         'transactionId']),
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .spaceBetween,
                  //                                   children: <Widget>[
                  //                                     Text(
                  //                                       "Amount",
                  //                                       style: TextStyle(
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w500),
                  //                                     ),
                  //                                     Text(
                  //                                         '\$${item['amount']}'),
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .spaceBetween,
                  //                                   children: <Widget>[
                  //                                     Text(
                  //                                       "Subscribed on",
                  //                                       style: TextStyle(
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w500),
                  //                                     ),
                  //                                     Text(DateFormat
                  //                                             .yMMMEd()
                  //                                         .format(DateTime
                  //                                                 .parse(item[
                  //                                                     'subscribedAt'])
                  //                                             .toLocal())
                  //                                         .toString()),
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .spaceBetween,
                  //                                   children: <Widget>[
                  //                                     Text(
                  //                                       "Expiry",
                  //                                       style: TextStyle(
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w500),
                  //                                     ),
                  //                                     Text(DateFormat
                  //                                             .yMMMEd()
                  //                                         .format(DateTime
                  //                                                 .parse(item[
                  //                                                     'expiryDate'])
                  //                                             .toLocal())
                  //                                         .toString()),
                  //                                   ],
                  //                                 ),
                  //                                 Divider()
                  //                               ],
                  //                             ),
                  //                           ))
                  //                       .toList(),
                  //                 )
                  //               : Column(
                  //                   children: <Widget>[
                  //                     Text(
                  //                         "You don't have any subscriptions yet."),
                  //                     Text(
                  //                         "Subscribe now to get access to unlimited content."),
                  //                     SizedBox(
                  //                       height: 10,
                  //                     ),
                  //                     FlatButton(
                  //                       color: primaryColor,
                  //                       textColor: Colors.white,
                  //                       onPressed: () {
                  //                         Navigator.push(
                  //                           context,
                  //                           CupertinoPageRoute(
                  //                               builder: (context) =>
                  //                                   Subscription()),
                  //                         );
                  //                       },
                  //                       child: Text('SUBSCRIBE NOW'),
                  //                     ),
                  //                   ],
                  //                 )
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),
                  ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
