import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation/models/splash-model.dart';
import 'package:meditation/screens/auth/login.dart';
import 'package:meditation/util/color.dart';
import 'auth/login.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController _pagecontroller;
  int currentPage = 0;

  List<SplashModel> welcomeData = [
    SplashModel(
        header: "Controls",
        title: "Test Study",
        description:
            "Most people have practicing regular meditation and maintained lower anxiety levels over the long term",
        img: "asset/img/Scroll-1.png"),
    SplashModel(
        header: "Self-Awareness",
        title: "Self-Defeating",
        description:
            "A study of 21 women fighting breast cancer found that when they took part in a tai chi program",
        img: "asset/img/Scroll-2.png"),
    SplashModel(
        header: "Attention Span",
        title: "Focused-Attention",
        description:
            "Meditation is like weight lifting for your attention span. It helps increase the strength and endurance of your attention.",
        img: "asset/img/Scroll-3.png"),
  ];

  @override
  void initState() {
    _pagecontroller = PageController();
    _pagecontroller.addListener(() {
      if (currentPage != _pagecontroller.page.floor() &&
          (_pagecontroller.page == 0.0 ||
              _pagecontroller.page == 1.0 ||
              _pagecontroller.page == 2.0)) {
        setState(() {
          currentPage = _pagecontroller.page.floor();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: PageView.builder(
                        controller: _pagecontroller,
                        itemCount: 3,
                        itemBuilder: (context, position) {
                          SplashModel data = welcomeData[position];
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(data.img))),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Text(
                                          data.header,
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 40,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 37),
                                    margin: const EdgeInsets.only(bottom: 40.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(data.title,
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(height: 15.0),
                                        Text(data.description,
                                            style: TextStyle(fontSize: 18))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })),
                buildBottomNavigationBar()
              ],
            ),
          ),
          Positioned(
            bottom: 90,
            left: MediaQuery.of(context).size.width / 2.4,
            child: buildPageIndicator(),
          )
        ],
      ),
    );
  }

  Container buildPageIndicator() {
    double indicatorsize = 15.0;
    return Container(
      height: 30.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 5.0),
            width: indicatorsize,
            height: indicatorsize,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(indicatorsize),
                color: currentPage == 0 ? primaryColor : Colors.white,
                border: Border.all(color: primaryColor, width: 2.0)),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5.0),
            width: indicatorsize,
            height: indicatorsize,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(indicatorsize),
                color: currentPage == 1 ? primaryColor : Colors.white,
                border: Border.all(color: primaryColor, width: 2.0)),
          ),
          Container(
            width: indicatorsize,
            height: indicatorsize,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(indicatorsize),
                color: currentPage == 2 ? primaryColor : Colors.white,
                border: Border.all(color: primaryColor, width: 2.0)),
          )
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => Login()));
      },
      child: Container(
        height: 60,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 40.0),
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints.expand(),
                color: primaryColor,
                child: Text(
                  "Get Started",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 23,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              color: darkPrimaryColor,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                color: iconColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagecontroller.dispose();
    super.dispose();
  }
}
