import 'package:flutter/material.dart';
import 'package:proyecto_final/pages/pages.dart';
import '../lista.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key});
// Parking list page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text(pages[2].title,
          style: TextStyle(color: Colors.grey[850]),
        ),
        backgroundColor: Colors.green[50],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                width: 300,
                height: 480,
                child: ParkingListPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
