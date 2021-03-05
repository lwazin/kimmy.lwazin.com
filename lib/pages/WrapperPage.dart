import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merch/services/provider.dart';
import 'package:merch/widgets/misc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;

class WrapperPage extends StatefulWidget {
  @override
  _WrapperPageState createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  final int now = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<Settings>(context, listen: true);
    fs.FirebaseFirestore firestore = fs.FirebaseFirestore.instance;

    return Scaffold(
        body: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CategorySelect(
                  //     "https://images.pexels.com/photos/2962069/pexels-photo-2962069.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                  //     "Start-Ups",
                  //     0),
                  CategorySelect(
                      "https://images.pexels.com/photos/1049622/pexels-photo-1049622.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                      "Events",
                      0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: (settings.navigation == "merch" ||
                                settings.navigation == "home")
                            ? (settings.navigation == "merch")
                                ? 816
                                : 816 - 238
                            : 0,
                        child: CategorySelect(
                            "https://images.pexels.com/photos/1639729/pexels-photo-1639729.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
                            "Merch",
                            238),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: (settings.navigation == "podcasts" ||
                                settings.navigation == "home")
                            ? (settings.navigation == "podcasts")
                                ? 816
                                : 816 - 578
                            : 0,
                        child: CategorySelect(
                            "https://images.pexels.com/photos/3602934/pexels-photo-3602934.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
                            "Podcasts",
                            578),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ContentArea(),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                "Copyright © ${now} || LwaziN. All rights reserved.",
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
            ),
            Container(
              width: 800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          "assets/images/facebook.png",
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          const url = 'https://www.linkedin.com/in/lwazin/';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Image.asset(
                          "assets/images/linkedin.png",
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          "assets/images/twitter.png",
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        (settings.showBox)
            ? Container(
                color: Colors.black87,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      width: 600,
                      height: 300,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Center(
                            child: (settings.navigation == "events")
                                ? Text("Events")
                                : (settings.navigation == "merch")
                                    ? Text("Merch")
                                    : (settings.navigation == "start-ups")
                                        ? Text("Start-Ups")
                                        : PodcastAddWidget(),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          settings.changeShowBox();
                                        },
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: MouseRegion(
                              //         cursor: SystemMouseCursors.click,
                              //         child: GestureDetector(
                              //           onTap: () {},
                              //           child: Icon(
                              //             Icons.send,
                              //             color: Colors.black,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : IgnorePointer(ignoring: true, child: Container()),
      ],
    ));
  }
}

// class FAQ extends StatefulWidget {
//   @override
//   _FAQState createState() => _FAQState();
// }

// class _FAQState extends State<FAQ> {
//   final _formKey = GlobalKey<FormState>();
//   bool comment = false;
//   bool email = false;
//   bool name = false;
//   String commentText = "";
//   String nameText = "";
//   String emailText = "";
//   @override
//   Widget build(BuildContext context) {
//     fs.FirebaseFirestore firestore = fs.FirebaseFirestore.instance;
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.only(
//           bottom: 10.0,
//           top: 10.0,
//         ),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(5),
//                 child: Container(
//                   width: 600,
//                   height: 150,
//                   color: Colors.black12,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextFormField(
//                       onChanged: (value) {
//                         setState(() {
//                           commentText = value;
//                         });
//                         if (value.isEmpty) {
//                           setState(() {
//                             comment = false;
//                           });
//                           return null;
//                         }
//                         setState(() {
//                           comment = true;
//                         });
//                         return null;
//                       },
//                       autocorrect: true,
//                       maxLength: 380,
//                       maxLines: 5,
//                       decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'What\'s on your mind?'),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(5),
//                       child: Container(
//                         width: 225,
//                         height: 40,
//                         color: Colors.black12,
//                         child: TextFormField(
//                           onChanged: (value) {
//                             setState(() {
//                               nameText = value;
//                             });
//                             if (value.isEmpty) {
//                               setState(() {
//                                 name = false;
//                               });
//                               return null;
//                             }
//                             setState(() {
//                               name = true;
//                             });
//                             return null;
//                           },
//                           autocorrect: true,
//                           decoration: InputDecoration(
//                               border: InputBorder.none,
//                               filled: true,
//                               hintText: 'Name..'),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 10,
//                     ),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(5),
//                       child: Container(
//                         width: 265,
//                         height: 40,
//                         color: Colors.black12,
//                         child: TextFormField(
//                           onChanged: (value) {
//                             setState(() {
//                               emailText = value;
//                             });
//                             if (value.isEmpty ||
//                                 !value.contains("@") ||
//                                 !value.contains(".")) {
//                               setState(() {
//                                 email = false;
//                               });
//                               return null;
//                             }
//                             setState(() {
//                               email = true;
//                             });
//                             return null;
//                           },
//                           autocorrect: true,
//                           decoration: InputDecoration(
//                               border: InputBorder.none,
//                               filled: true,
//                               hintText: 'E-Mail Address..'),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 10,
//                     ),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(5),
//                       child: Opacity(
//                         opacity: (comment && email && name) ? 1 : 0.6,
//                         child: MouseRegion(
//                           cursor: (comment && email && name)
//                               ? SystemMouseCursors.click
//                               : SystemMouseCursors.basic,
//                           child: GestureDetector(
//                             onTap: () {
//                               DateTime now = new DateTime.now();
//                               if (commentText.isNotEmpty &&
//                                   emailText.isNotEmpty &&
//                                   nameText.isNotEmpty) {
//                                 firestore
//                                     .collection("userInputData")
//                                     .doc()
//                                     .set({
//                                   "inputType": "Comment",
//                                   "comment": commentText,
//                                   "email": emailText,
//                                   "name": nameText,
//                                   "processed": false,
//                                   "time": now
//                                 });
//                                 print("object");
//                               }
//                             },
//                             child: AnimatedContainer(
//                               duration: Duration(
//                                 milliseconds: 200,
//                               ),
//                               width: 90,
//                               height: 40,
//                               color: (comment && email && name)
//                                   ? Colors.lime
//                                   : Colors.pink[50],
//                               child: Center(
//                                 child: Text(
//                                   """SEND""",
//                                   textAlign: TextAlign.center,
//                                   style: GoogleFonts.raleway(
//                                     textStyle: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.grey[600],
//                                       letterSpacing: 0,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
