import 'package:flutter/material.dart';
import 'package:my_app/util/util.dart';
import 'package:my_app/widgets/image_widget.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class PostListItem {
  final String id;
  final String iconUrl;
  final String name;
  final String text;
  final String images;
  final int datetime;

  PostListItem(
      {required this.id,
      required this.iconUrl,
      required this.name,
      required this.text,
      required this.images,
      required this.datetime});
}

class PostListView extends StatefulWidget {
  final List<PostListItem> lists;
  final Function(String)? onItemTap;
  const PostListView({super.key, required this.lists, this.onItemTap});
  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.lists.length,
      itemBuilder: (context, index) {
        if (widget.lists[index].id.isEmpty) {
          return const SizedBox.shrink();
        }
        String datetimeStr =
            unixtimeToDatetimeString(widget.lists[index].datetime);
        return Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: ListTile(
                  onTap: () {
                    widget.onItemTap!(widget.lists[index].id);
                  },
                  leading: AdaptiveImage(
                    imageUrl: widget.lists[index].iconUrl,
                    height: 64,
                    width: 64,
                  ),
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 20,
                            width: double.infinity,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.lists[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12.0)))),
                        SizedBox(
                            width: double.infinity,
                            child: Linkify(
                                onOpen: (link) async {
                                  if (!await launchUrl(Uri.parse(link.url),
                                      mode: LaunchMode.externalApplication)) {
                                    throw Exception(
                                        'Could not launch ${link.url}');
                                  }
                                },
                                text: widget.lists[index].text,
                                style: const TextStyle(fontSize: 16.0),
                                linkStyle: const TextStyle(
                                    fontSize: 16.0, color: Colors.red),
                                textAlign: TextAlign.left)),
                        const SizedBox(height: 4),
                        SizedBox(
                            height: 15,
                            width: double.infinity,
                            child: Text(datetimeStr,
                                style: const TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.right)),
                      ]),
                )));
      },
    );
  }
}
