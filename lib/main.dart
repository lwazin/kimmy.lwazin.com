import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merch/pages/WrapperPage.dart';
import 'package:merch/services/provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Settings(),
        ),
      ],
      child: MaterialApp(
        title: "Kimmy's List",
        debugShowCheckedModeBanner: false,
        home: WrapperPage(),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////
