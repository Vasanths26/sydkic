import 'package:flutter/material.dart';
import 'package:sydkic/utils/constant.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({super.key});

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: blackColor,
      body:  Padding(
        padding: const EdgeInsets.symmetric( horizontal: 12,vertical: 5),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: appointmentConColor,

              ),
            )
          ],
        ),
      ),
    );
  }
}
