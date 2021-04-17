import 'dart:io';

import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/lists_cards/message_list.dart';
import '../../models/message.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  static final id = 'ChatRoom';
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  bool cameraLoading;
  bool photoLibraryLoading;
  Map otherUsersData = {};
  String message = '';
  final _formKey = GlobalKey<FormState>();
  String chatId;
  TextEditingController textEditingController = new TextEditingController();
  File imageFile;

  Future getImage(ImageSource source) async {
    var tempImage = await ImagePicker().getImage(source: source);
    if (tempImage != null)
      setState(() {
        imageFile = File(tempImage.path);
      });
  }

  @override
  void initState() {
    super.initState();
    chatId = null;
    cameraLoading = false;
    photoLibraryLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    otherUsersData = ModalRoute.of(context).settings.arguments;
    final UserModel otherUser = otherUsersData['otherUser'];
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    print('Other user: ' + otherUser.uid);
    return SafeArea(
      child: StreamBuilder<Object>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserModel currentUser = snapshot.data;
              return FutureBuilder<String>(
                  future:
                      DatabaseService().getChat(currentUser.uid, otherUser.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      chatId = snapshot.data;
                      return Scaffold(
                        body: Column(
                          children: [
                            Container(
                              height: size.height * 0.1,
                              width: double.infinity,
                              color: kPrimaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  BackButton(
                                    color: Colors.white,
                                  ),
                                  CircleAvatar(
                                    radius: screenWidth * 0.05,
                                    backgroundImage: otherUser.picURL != ''
                                        ? NetworkImage(otherUser.picURL)
                                        : AssetImage(
                                            'assets/images/userPlaceholder.png'),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Text(
                                    otherUser.role == 'doctor'
                                        ? 'Dr. ${otherUser.fName}'
                                        : '${otherUser.fName}',
                                    style: TextStyle(
                                      fontSize: size.width * 0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            Expanded(
                              flex: 8,
                              child: chatId != null
                                  ? Container(
                                      child: StreamProvider<
                                          List<MessageModel>>.value(
                                        value: DatabaseService()
                                            .getMessages(chatId),
                                        child: MessageList(),
                                      ),
                                    )
                                  : Container(),
                            ),
                            Container(
                              child: Form(
                                key: _formKey,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        child: TextFormField(
                                          controller: textEditingController,
                                          validator: (val) => val.isEmpty
                                              ? 'Cant send an empty message..'
                                              : null,
                                          onChanged: (val) {
                                            setState(() => message = val);
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Say something..',
                                            focusColor: kPrimaryColor,
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    photoLibraryLoading == false
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.photo_library,
                                            ),
                                            onPressed: () async {
                                              getImage(ImageSource.gallery);
                                              if (imageFile != null) {
                                                setState(() {
                                                  photoLibraryLoading = true;
                                                });
                                                String messageID =
                                                    FirebaseFirestore
                                                        .instance
                                                        .collection("chats/" +
                                                            chatId +
                                                            "/messages")
                                                        .doc()
                                                        .id;
                                                String imageURL =
                                                    await DatabaseService()
                                                        .uploadMessageImage(
                                                            imageFile,
                                                            messageID);
                                                if (imageURL != '') {
                                                  await DatabaseService()
                                                      .sendMessage(
                                                    messageID: messageID,
                                                    type: 1,
                                                    message: imageURL,
                                                    user1: currentUser.uid,
                                                    user2: otherUser.uid,
                                                    existingChatID: chatId,
                                                  );
                                                  setState(() {
                                                    photoLibraryLoading = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    photoLibraryLoading = true;
                                                  });
                                                }
                                              }
                                              setState(() {
                                                textEditingController.text = '';
                                              });
                                            },
                                            color: kPrimaryColor,
                                          )
                                        : SpinKitDoubleBounce(
                                            color: kPrimaryColor,
                                          ),
                                    cameraLoading == false
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.camera_alt,
                                            ),
                                            onPressed: () async {
                                              getImage(ImageSource.camera);
                                              if (imageFile != null) {
                                                setState(() {
                                                  cameraLoading = true;
                                                });
                                                String messageID =
                                                    FirebaseFirestore
                                                        .instance
                                                        .collection("chats/" +
                                                            chatId +
                                                            "/messages")
                                                        .doc()
                                                        .id;
                                                String imageURL =
                                                    await DatabaseService()
                                                        .uploadMessageImage(
                                                            imageFile,
                                                            messageID);
                                                if (imageURL != '') {
                                                  await DatabaseService()
                                                      .sendMessage(
                                                    messageID: messageID,
                                                    type: 1,
                                                    message: imageURL,
                                                    user1: currentUser.uid,
                                                    user2: otherUser.uid,
                                                    existingChatID: chatId,
                                                  );
                                                  setState(() {
                                                    cameraLoading = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    cameraLoading = false;
                                                  });
                                                }
                                              }
                                              setState(() {
                                                textEditingController.text = '';
                                              });
                                            },
                                            color: kPrimaryColor,
                                          )
                                        : SpinKitDoubleBounce(
                                            color: kPrimaryColor,
                                          ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.send,
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          await DatabaseService().sendMessage(
                                            type: 0,
                                            message: message,
                                            user1: currentUser.uid,
                                            user2: otherUser.uid,
                                            existingChatID: chatId,
                                          );
                                        }
                                        setState(() {
                                          textEditingController.text = '';
                                        });
                                      },
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Loading();
                    }
                  });
            } else {
              return Loading();
            }
          }),
    );
  }
}
