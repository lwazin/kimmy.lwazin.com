import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merch/services/provider.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

// // // // // // // // // // // // CategorySelect // // // // // // // // // // // //
// // // // // // // // // // // // CategorySelect // // // // // // // // // // // //
// // // // // // // // // // // // CategorySelect // // // // // // // // // // // //

// ignore: must_be_immutable
class CategorySelect extends StatefulWidget {
  String link;
  String title;
  double width_bias;
  CategorySelect(this.link, this.title, this.width_bias);
  @override
  _CategorySelectState createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelect> {
  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<Settings>(context, listen: true);

    return Stack(
      children: [
        IgnorePointer(
          ignoring: (settings.navigation != widget.title.toLowerCase())
              ? false
              : true,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: (settings.navigation == widget.title.toLowerCase() ||
                    settings.navigation == "home")
                ? 216
                : 0,
            width: (settings.navigation == widget.title.toLowerCase() ||
                    settings.navigation == "home")
                ? (settings.navigation == widget.title.toLowerCase())
                    ? 816
                    : 816 - widget.width_bias
                : 700,
            child: GestureDetector(
              onTap: () {
                if (settings.navigation != widget.title.toLowerCase()) {
                  settings.newNav(widget.title.toLowerCase());
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MouseRegion(
                  cursor: (settings.navigation == widget.title.toLowerCase())
                      ? SystemMouseCursors.basic
                      : SystemMouseCursors.click,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: (settings.navigation ==
                                  widget.title.toLowerCase())
                              ? 800
                              : 800 - widget.width_bias,
                          height: 200,
                          child: Image.network(
                            widget.link,
                            fit: BoxFit.cover,
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: (settings.navigation ==
                                  widget.title.toLowerCase())
                              ? 800
                              : 800 - widget.width_bias,
                          height: 200,
                          color: Colors.black26,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Container(
                                color: Colors.black54,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    widget.title,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: (settings.navigation == widget.title.toLowerCase())
              ? false
              : true,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: (settings.navigation == widget.title.toLowerCase() ||
                    settings.navigation == "home")
                ? 216
                : 0,
            width: (settings.navigation == widget.title.toLowerCase() ||
                    settings.navigation == "home")
                ? (settings.navigation == widget.title.toLowerCase())
                    ? 816
                    : 816 - widget.width_bias
                : 700,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: (settings.navigation == widget.title.toLowerCase())
                    ? 1.0
                    : 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            if (settings.navigation ==
                                widget.title.toLowerCase()) {
                              settings.newNav("home");
                            }
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            settings.changeShowBox();
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// // // // // // // // // // // // ContentArea // // // // // // // // // // // //
// // // // // // // // // // // // ContentArea // // // // // // // // // // // //
// // // // // // // // // // // // ContentArea // // // // // // // // // // // //

class ContentArea extends StatefulWidget {
  @override
  _ContentAreaState createState() => _ContentAreaState();
}

class _ContentAreaState extends State<ContentArea> {
  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<Settings>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: (settings.navigation != "home") ? 530 : 0,
          child: (settings.navigation == "podcasts")
              ? PodcastPage()
              : (settings.navigation == "events")
                  ? EventPage()
                  : (settings.navigation == "merch")
                      ? MerchPage()
                      : Container(),
        ),
      ),
    );
  }
}

// // // // // // // // // // // // MediaPlayerWidget // // // // // // // // // // // //
// // // // // // // // // // // // MediaPlayerWidget // // // // // // // // // // // //
// // // // // // // // // // // // MediaPlayerWidget // // // // // // // // // // // //

class MediaPlayerWidget extends StatefulWidget {
  @override
  _MediaPlayerWidgetState createState() => _MediaPlayerWidgetState();
}

class _MediaPlayerWidgetState extends State<MediaPlayerWidget> {
  bool playing = false;
  bool started = false;
  String url =
      "https://firebasestorage.googleapis.com/v0/b/flagsweb-26044.appspot.com/o/glitchMob.mp3?alt=media&token=10ef265f-7e05-4165-86b5-d122378ee216";
  AudioPlayer audioPlayer = AudioPlayer();
  Duration totalDuration;
  Duration position;

  initPlayer() {
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      setState(() {
        totalDuration = updatedDuration;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((updatedPosition) {
      setState(() {
        position = updatedPosition;
      });
    });
  }

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  play() async {
    int result = await audioPlayer.play(url);

    if (result == 1) {
      print("Playing");
    }
  }

  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      print("Paused");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        color: Colors.black45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                audioPlayer.dispose();
                audioPlayer.setUrl(
                    "https://firebasestorage.googleapis.com/v0/b/flagsweb-26044.appspot.com/o/Baauer.mp3?alt=media&token=43a3b3c8-4608-42ad-9fbe-6e1469aa5f2f");
                setState(() {
                  started = false;
                });
                // setState(() {
                //   url =
                //       "https://firebasestorage.googleapis.com/v0/b/flagsweb-26044.appspot.com/o/Baauer.mp3?alt=media&token=43a3b3c8-4608-42ad-9fbe-6e1469aa5f2f";
                // });
                initState();

                // audioPlayer.resume();
              },
              child: Icon(
                Icons.fast_rewind,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (!playing) {
                  if (started) {
                    audioPlayer.resume();
                  } else {
                    play();
                    setState(() {
                      started = true;
                    });
                  }
                  setState(() {
                    playing = !playing;
                  });
                } else {
                  pause();
                  setState(() {
                    playing = !playing;
                  });
                }
              },
              child: Icon(
                (playing) ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.fast_forward,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Now Playing: ${totalDuration.toString()}",
              textAlign: TextAlign.justify,
              style: GoogleFonts.muli(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 1),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }
}

// // // // // // // // // // // // MerchPage // // // // // // // // // // // //
// // // // // // // // // // // // MerchPage // // // // // // // // // // // //
// // // // // // // // // // // // MerchPage // // // // // // // // // // // //

class MerchPage extends StatefulWidget {
  @override
  _MerchPageState createState() => _MerchPageState();
}

class _MerchPageState extends State<MerchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (384 / 400),
        children: [
          MerchCardWidget(),
        ],
      ),
    );
  }
}

// // // // // // // // // // // // MerchCardWidget // // // // // // // // // // // //

class MerchCardWidget extends StatefulWidget {
  @override
  _MerchCardWidgetState createState() => _MerchCardWidgetState();
}

class _MerchCardWidgetState extends State<MerchCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.black26,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: 384,
                  height: 400,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vestibulum et purus ornare euismod. Suspendisse tristique ligula et ante porttitor ultrices. Mauris ornare nibh ipsum. Sed non fermentum dolor, eu condimentum neque. Proin condimentum erat quis ipsum porta dictum. Nam mattis pretium sapien, tristique accumsan sapien pellentesque ut. Suspendisse potenti.""",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.muli(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                letterSpacing: 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.all_inclusive_sharp,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.thumb_up,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.thumb_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: 384,
                      height: 401,
                      color: Colors.white70,
                    ),
                    Column(
                      children: [
                        Image.network(
                          "https://images.pexels.com/photos/4345970/pexels-photo-4345970.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
                          fit: BoxFit.cover,
                          width: 384,
                          height: 400,
                        ),
                        Container(
                          width: 384,
                          height: 400,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.black,
                          width: 80,
                          height: 30,
                          child: Center(
                            child: Text(
                              "R400",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  letterSpacing: 0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: Colors.black,
                          width: 150,
                          height: 30,
                          child: Center(
                            child: Text(
                              "Floral Hoodie",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  letterSpacing: 0),
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
      ),
    );
  }
}

// // // // // // // // // // // // EventPage // // // // // // // // // // // //
// // // // // // // // // // // // EventPage // // // // // // // // // // // //
// // // // // // // // // // // // EventPage // // // // // // // // // // // //

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (384 / 200),
        children: [
          EventCardWidget(),
        ],
      ),
    );
  }
}

// // // // // // // // // // // // EventCardWidget // // // // // // // // // // // //

class EventCardWidget extends StatefulWidget {
  @override
  _EventCardWidgetState createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.black26,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: 384,
                  height: 200,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vestibulum et purus ornare euismod. Suspendisse tristique ligula et ante porttitor ultrices. Mauris ornare nibh ipsum. Sed non fermentum dolor, eu condimentum neque. Proin condimentum erat quis ipsum porta dictum. Nam mattis pretium sapien, tristique accumsan sapien pellentesque ut. Suspendisse potenti.""",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.muli(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                letterSpacing: 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.all_inclusive_sharp,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.thumb_up,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.thumb_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: IgnorePointer(
                  ignoring: true,
                  child: Stack(
                    children: [
                      Container(
                        width: 384,
                        height: 201,
                        color: Colors.white70,
                      ),
                      Column(
                        children: [
                          Image.network(
                            "https://images.pexels.com/photos/59884/pexels-photo-59884.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
                            fit: BoxFit.cover,
                            width: 384,
                            height: 200,
                          ),
                          Container(
                            width: 384,
                            height: 200,
                            color: Colors.transparent,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            color: Colors.black,
                            width: 80,
                            height: 30,
                            child: Center(
                              child: Text(
                                "10 Oct",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    letterSpacing: 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            color: Colors.black,
                            width: 150,
                            height: 30,
                            child: Center(
                              child: Text(
                                "Local Oscars | R40",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    letterSpacing: 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // // // // // // // // // // // PodcastPage // // // // // // // // // // // //
// // // // // // // // // // // // PodcastPage // // // // // // // // // // // //
// // // // // // // // // // // // PodcastPage // // // // // // // // // // // //

class PodcastPage extends StatefulWidget {
  @override
  _PodcastPageState createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  @override
  Widget build(BuildContext context) {
    Stream collectionStream =
        fs.FirebaseFirestore.instance.collection('audio').snapshots();
    fs.CollectionReference audio =
        fs.FirebaseFirestore.instance.collection('audio');
    return Container(
      width: 800,
      child: StreamBuilder<fs.QuerySnapshot>(
        stream: audio.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<fs.QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (384 / 200),
            ),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return PodcastCardWidget(snapshot.data.docs[index]);
            },
          );
        },
      ),
    );
  }
}

// // // // // // // // // // // // PodcastCardWidget // // // // // // // // // // // //

class PodcastCardWidget extends StatefulWidget {
  fs.QueryDocumentSnapshot snapp;
  PodcastCardWidget(this.snapp);
  @override
  _PodcastCardWidgetState createState() => _PodcastCardWidgetState();
}

class _PodcastCardWidgetState extends State<PodcastCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.black26,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: 384,
                  height: 200,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            widget.snapp["description"],
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.muli(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                letterSpacing: 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.all_inclusive_sharp,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.thumb_up,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.thumb_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: 384,
                      height: 201,
                      color: Colors.white70,
                    ),
                    Column(
                      children: [
                        Image.network(
                          widget.snapp["cover"],
                          fit: BoxFit.cover,
                          width: 384,
                          height: 200,
                        ),
                        Container(
                          width: 384,
                          height: 200,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                    Container(
                      color: Colors.black54,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "[${widget.snapp['type']}] ${widget.snapp['name']}",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  letterSpacing: 0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Icon(
                                //   Icons.fast_rewind,
                                //   color: Colors.white,
                                // ),
                                // Icon(
                                //   Icons.play_arrow,
                                //   color: Colors.white,
                                // ),
                                // Icon(
                                //   Icons.fast_forward,
                                //   color: Colors.white,
                                // ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () async {
                                      dynamic url = widget.snapp["audio"];
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Icon(
                                      Icons.cloud_download,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // // // // // // // // // // // PodcastAddWidget // // // // // // // // // // // //

class PodcastAddWidget extends StatefulWidget {
  @override
  _PodcastAddWidgetState createState() => _PodcastAddWidgetState();
}

class _PodcastAddWidgetState extends State<PodcastAddWidget> {
  fs.CollectionReference audio =
      fs.FirebaseFirestore.instance.collection('audio');
  String type = "Track";
  final _formKey = GlobalKey<FormState>();
  // bool comment = false;
//   bool email = false;
//   bool name = false;
  String descriptionText = "";
  String nameText = "";
//   String emailText = "";

  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<Settings>(context, listen: true);
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Add Your Podcast..",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              width: 500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (type == "Track") {
                            setState(() {
                              type = "Podcast";
                            });
                          } else {
                            setState(() {
                              type = "Track";
                            });
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              (type == "Track")
                                  ? Icons.music_note
                                  : Icons.multitrack_audio_rounded,
                              color: Colors.black,
                              size: 20,
                            ),
                            Text(
                              "Audio Type",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              color: Colors.black,
                              size: 20,
                            ),
                            Text(
                              "Upload Audio",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Icon(
                              Icons.image_sharp,
                              color: Colors.black,
                              size: 20,
                            ),
                            Text(
                              "Upload Cover",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                width: 500,
                height: 50,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      nameText = value;
                    });
                  },
                  autocorrect: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        (type == "Podcast") ? 'Podcast Name..' : 'Track Name..',
                    filled: true,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                width: 500,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      descriptionText = value;
                    });
                  },
                  autocorrect: true,
                  maxLength: 370,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                    filled: true,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        audio.add(
                          {
                            "name": nameText,
                            "description": descriptionText,
                            "type": type,
                            "cover":
                                "https://images.pexels.com/photos/4503734/pexels-photo-4503734.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                            "likes": 0,
                            "dislikes": 0,
                            "uploaded": DateTime.now(),
                            "audio":
                                "https://lexs.blasux.ru/music/big/The%20Glitch%20Mob%20Discography/Albums/2010%20-%20Drink%20The%20Sea/08%20Drive%20It%20Like%20You%20Stole%20It.mp3"
                          },
                        );
                        settings.changeShowBox();
                        setState(() {
                          descriptionText = "";
                          nameText = "";
                          type = "Track";
                        });
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
