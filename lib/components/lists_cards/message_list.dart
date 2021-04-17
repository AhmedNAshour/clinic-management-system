import 'package:clinic/models/message.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<List<MessageModel>>(context) ?? [];
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;

    if (messages.isNotEmpty) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return ListView.builder(
      controller: _controller,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return Align(
          alignment: messages[index].sender == user.uid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: messages[index].type == 0
              ? Container(
                  margin: EdgeInsets.all(screenWidth * 0.02),
                  width: screenWidth * 0.5,
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                    border: messages[index].sender != user.uid
                        ? Border.all(
                            color: kPrimaryLightColor,
                          )
                        : null,
                    color: messages[index].sender == user.uid
                        ? kPrimaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          messages[index].body,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: messages[index].sender == user.uid
                                ? Colors.white
                                : kPrimaryTextColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${DateFormat("MMM").format(messages[index].time)} ${DateFormat("d").format(messages[index].time)} - ${DateFormat("jm").format(messages[index].time)}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.025,
                            color: kPrimaryLightColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(screenWidth * 0.02),
                  width: size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HeroPhotoViewRouteWrapper(
                                imageProvider:
                                    NetworkImage(messages[index].body),
                              ),
                            ),
                          );
                        },
                        child: ExtendedImage.network(
                          messages[index].body,
                          width: size.width * 0.4,
                          height: size.width * 0.4,
                          fit: BoxFit.fill,
                          cache: true,
                          shape: BoxShape.rectangle,
                          border: Border.all(
                              color: messages[index].sender != user.uid
                                  ? kPrimaryColor
                                  : Colors.white,
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          //cancelToken: cancellationToken,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${DateFormat("MMM").format(messages[index].time)} ${DateFormat("d").format(messages[index].time)} - ${DateFormat("jm").format(messages[index].time)}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.025,
                            color: kPrimaryLightColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class HeroPhotoViewRouteWrapper extends StatefulWidget {
  const HeroPhotoViewRouteWrapper({
    this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  _HeroPhotoViewRouteWrapperState createState() =>
      _HeroPhotoViewRouteWrapperState();
}

class _HeroPhotoViewRouteWrapperState extends State<HeroPhotoViewRouteWrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: widget.imageProvider,
        backgroundDecoration: widget.backgroundDecoration,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}
