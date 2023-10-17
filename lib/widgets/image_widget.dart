import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class AdaptiveImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const AdaptiveImage(
      {Key? key, required this.imageUrl, this.width, this.height})
      : super(key: key);

  @override
  _AdaptiveImageState createState() => _AdaptiveImageState();
}

class _AdaptiveImageState extends State<AdaptiveImage> {
  late Future<http.Response> _fetchImage;

  @override
  void initState() {
    super.initState();
    _fetchImage = http.get(Uri.parse(widget.imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: _fetchImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          }
          final contentType = snapshot.data!.headers['content-type'];
          if (contentType == 'image/svg+xml') {
            // If the image is an SVG
            return SvgPicture.memory(
              snapshot.data!.bodyBytes,
              width: widget.width,
              height: widget.height,
            );
          } else {
            // If the image is not an SVG (could be PNG, JPG, etc.)
            return Image.memory(
              snapshot.data!.bodyBytes,
              width: widget.width,
              height: widget.height,
            );
          }
        } else {
          // While loading the image
          return const SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator());
        }
      },
    );
  }
}
