import 'dart:math';
import 'package:global_configuration/global_configuration.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:meditation/util/color.dart';
import 'package:vector_math/vector_math.dart' as Vector;

class Invite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = new Size(MediaQuery.of(context).size.width, 200.0);
    return Scaffold(
        appBar: AppBar(
          title: Text('Say to Friend'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Container(
                width: size.width,
                height: 200,
                // child: Image.network(
                //   'https://www.tokia.io/wp-content/uploads/2018/10/tokia-refferal-illiustration-2.png',
                //   fit: BoxFit.cover,
                // )
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Invite Your Friends',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: darkPrimaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Invite your friend to this meditation app.',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                color: primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  final RenderBox box = context.findRenderObject();
                  Share.share(
                      "Hello, I've recently installed this meditation app. It's really good. Check it out ${GlobalConfiguration().getString("dynamicLinkInvite")}",
                      subject: "Meditatio4Soul",
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
                child: Text('Invite Friends'.toUpperCase()),
              ),
              Expanded(child: Container()),
              ShareInvite(
                size: size,
                xOffset: 50,
                color: primaryColor,
                yOffset: 10,
              )
            ],
          ),
        ));
  }
}

class ShareInvite extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;
  ShareInvite({this.size, this.xOffset, this.yOffset, this.color});

  @override
  _ShareInviteState createState() => _ShareInviteState();
}

class _ShareInviteState extends State<ShareInvite>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
          i <= widget.size.width.toInt() + 2;
          i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) %
                        360 *
                        Vector.degrees2Radians) *
                    20 +
                50 +
                widget.yOffset));
      }
    });
    animationController.repeat();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: new AnimatedBuilder(
        animation: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => new ClipPath(
          child: widget.color == null
              ? Image.asset(
                  'images/demo5bg.jpg',
                  width: widget.size.width,
                  height: widget.size.height,
                  fit: BoxFit.cover,
                )
              : new Container(
                  width: widget.size.width,
                  height: widget.size.height,
                  color: widget.color,
                ),
          clipper: new WaveClipper(animationController.value, animList1),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
