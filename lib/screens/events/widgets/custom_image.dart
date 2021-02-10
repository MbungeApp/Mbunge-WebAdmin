// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;
// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';

// class CustomImage extends StatefulWidget {
//   final String imageUrl;

//   const CustomImage({Key key, this.imageUrl}) : super(key: key);

//   @override
//   _CustomImageState createState() => _CustomImageState();
// }

// class _CustomImageState extends State<CustomImage> {
//   html.ImageElement imageElement;
//   @override
//   void initState() {
//     super.initState();
//     ui.platformViewRegistry.registerViewFactory(widget.imageUrl, (int viewId) {
//       imageElement = html.ImageElement();
//       imageElement.id = viewId.toString();
//       imageElement.src = widget.imageUrl;
//       return imageElement;
//     });
//   }

//   @override
//   void dispose() {
//     imageElement?.remove();
//     super.dispose();
//   }

//   Widget build(BuildContext context) {
//     return HtmlElementView(
//       viewType: widget.imageUrl,
//     );
//   }
// }
