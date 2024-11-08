import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileNameTag extends StatefulWidget {
  ProfileNameTag(
      {super.key, required this.icon, required this.label, required this.name});

  final icon;
  final label;
  final name;
  @override
  State<ProfileNameTag> createState() => _ProfileNameTagState();
}

class _ProfileNameTagState extends State<ProfileNameTag> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      color: Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    widget.icon,
                    size: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.label,
                          // style:
                          // GoogleFonts.roboto(
                          //   fontSize: 12,
                          //   fontWeight: FontWeight.w500,
                          //   textStyle: TextStyle(
                          //       color: Color.fromARGB(255, 140, 140, 140),
                          //       letterSpacing: .5),
                          // ),
                        )),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.name,
                        // style: GoogleFonts.roboto(
                        //   fontSize: 14,
                        //   fontWeight: FontWeight.bold,
                        //   textStyle:
                        //       TextStyle(color: Colors.black, letterSpacing: .5),
                        // ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
