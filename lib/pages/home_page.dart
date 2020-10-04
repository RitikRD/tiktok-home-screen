import 'package:flutter/material.dart';
import 'package:tik_tok_ui/constant/data_json.dart';
import 'package:tik_tok_ui/theme/colors.dart';
import 'package:tik_tok_ui/widgets/header_home_page.dart';
import 'package:tik_tok_ui/widgets/column_social_icon.dart';
import 'package:tik_tok_ui/widgets/left_panel.dart';
import 'package:tik_tok_ui/widgets/tik_tok_icons.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return RotatedBox(
      quarterTurns: 1,
      child: TabBarView(
        controller: _tabController,
        children: List.generate(items.length, (index) {
          return VideoPlayerItem(
            videoUrl: items[index]['videoUrl'],
            size: size,
            name: items[index]['name'],
            caption: items[index]['caption'],
            songName: items[index]['songName'],
            profileImg: items[index]['profileImg'],
            likes: items[index]['likes'],
            comments: items[index]['comments'],
            shares: items[index]['shares'],
            albumImg: items[index]['albumImg'],
          );
        }),
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String caption;
  final String songName;
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String albumImg;
  VideoPlayerItem(
      {Key key,
      @required this.size,
      this.name,
      this.caption,
      this.songName,
      this.profileImg,
      this.likes,
      this.comments,
      this.shares,
      this.albumImg,
      this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoController = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((value) {
       _videoController.play();
        setState(() {
          
          isShowPlaying = false;
        });
      });

      
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController.dispose();

    
  }
  Widget isPlaying(){
    return _videoController.value.isPlaying && !isShowPlaying  ? Container() : Icon(Icons.play_arrow,size: 80,color: white.withOpacity(0.5),);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _videoController.value.isPlaying
              ? _videoController.pause()
              : _videoController.play();
        });
      },
      child: RotatedBox(
        quarterTurns: -1,
        child: Container(
            height: widget.size.height,
            width: widget.size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  decoration: BoxDecoration(color: black),
                  child: Stack(
                    children: <Widget>[
                      VideoPlayer(_videoController),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                          ),
                          child: isPlaying(),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          HeaderHomePage(),
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              LeftPanel(
                                size: widget.size,
                                name: "${widget.name}",
                                caption: "${widget.caption}",
                                songName: "${widget.songName}",
                              ),
                              RightPanel(
                                size: widget.size,
                                likes: "${widget.likes}",
                                comments: "${widget.comments}",
                                shares: "${widget.shares}",
                                profileImg: "${widget.profileImg}",
                                albumImg: "${widget.albumImg}",
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class RightPanel extends StatelessWidget {
  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;
  const RightPanel({
    Key key,
    @required this.size,
    this.likes,
    this.comments,
    this.shares,
    this.profileImg,
    this.albumImg,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.3,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getProfile(profileImg),
                getIcons(TikTokIcons.heart, likes, 35.0),
                getIcons(TikTokIcons.chat_bubble, comments, 35.0),
                getIcons(TikTokIcons.reply, shares, 25.0),
                getAlbum(albumImg)
              ],
            ))
          ],
        ),
      ),
    );
  }
}
// in this code you can also simply the thing and you can use custom icon as well i added many features like double tap like tab changes etc
import 'dart:convert';

import 'package:TikTokUI/constant/data_json.dart';
import 'package:TikTokUI/drawerpages/Search.dart';
import 'package:TikTokUI/drawerpages/block.dart';
import 'package:TikTokUI/drawerpages/logout.dart';
import 'package:TikTokUI/drawerpages/notifications.dart';
import 'package:TikTokUI/drawerpages/report.dart';
import 'package:TikTokUI/drawerpages/save.dart';
import 'package:TikTokUI/pages/UserProfile.dart';
import 'package:TikTokUI/pages/BuildMoreOption.dart';
import 'package:TikTokUI/widgets/ExploreTabView.dart';
import 'package:TikTokUI/widgets/moreOption.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:TikTokUI/widgets/FollowingplayerItem.dart';
import 'package:video_player/video_player.dart';
class HomePage extends StatefulWidget {

  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController _tabController;
  bool like = false;
  void initState() {
    super.initState();

    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void choiceAction(String choice) {}
  bool followbutton = true;
  bool explorebutton = false;
  void buttonFollowing() {}
  // Future<bool> _onBackPressed() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: Text('Do you want to exit the app'),
  //             actions: <Widget>[
  //               FlatButton(
  //                   onPressed: () => {Navigator.pop(context, false)},
  //                   child: Text('No')),
  //               FlatButton(
  //                   onPressed: () => {Navigator.pop(context, true)},
  //                   child: Text('Yes'))
  //             ],
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Column(

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(icon: Icon(Icons.close), onPressed: (){})
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      CircleAvatar( radius: 40,
                      backgroundImage: AssetImage('assets/userimage.png'),
                    ),
                    //SizedBox(width: 20,),
                    Column(
                      children: [
                        Text("User Name",style: TextStyle(fontSize: 18.0,fontFamily: 'Pacifico'),),
                        Text("@User Id",style: TextStyle(fontSize: 13.0,fontFamily: 'Pacifico'),),
                      ],
                    ),
                    IconButton(icon: Icon(Icons.search), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));})


                  ],
                )
              ],
              )),
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey))
                ),
              ),
              customTile(Icons.search,'Search',(){Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));}),
              customTile(Icons.save_alt,'Save',(){Navigator.push(context, MaterialPageRoute(builder: (context) => Save()));}),
              customTile(Icons.notifications_none,'Notification',(){Navigator.push(context, MaterialPageRoute(builder: (context) => Notification1()));}),
              customTile(Icons.block,'Blocked User',(){Navigator.push(context, MaterialPageRoute(builder: (context) => Block()));}),
              customTile(Icons.close,'Report',(){Navigator.push(context, MaterialPageRoute(builder: (context) => Report()));}),
              SizedBox(height: 250,),
              Container(
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey))
                ),
              ),
              customTile(Icons.label_important,'Logout',(){Navigator.push(context, MaterialPageRoute(builder: (context) => Log()));}),
            ],
          ),
        ),
        appBar: AppBar(
          leading:
          IconButton(icon: Icon(Icons.more_vert,color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
               ),

          elevation: 0,
          title: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: GoogleFonts.pacifico(
                fontStyle: FontStyle.italic,
                fontSize: MediaQuery.of(context).textScaleFactor * 16,
                textStyle: TextStyle(
                  color: Colors.white,
                )),
            tabs: <Widget>[
              Tab(
                text: "Following",
              ),
              Tab(
                text: "Explore",
              ),
            ],
          ),
          backgroundColor: Colors.transparent.withOpacity(0),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => UserProfile()));
                },
                child: CircleAvatar(),
              ),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: TabBarView(
          children: <Widget>[
            getFollowingBody(),
            getExploreBody(),
          ],
        ),
        // floatingActionButton: Container(
        //   width: 80,
        //   height: 80,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: FloatingActionButton(
        //       onPressed: () {
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => VideoCamera()));
        //       },
        //       child: Center(
        //         child: Image.asset(
        //           'assets/Middleone.png',
        //           width: 45,
        //           height: 45,
        //         ),
        //       ),
        //       backgroundColor: Colors.white,
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget getFollowingBody() {
    var size = MediaQuery.of(context).size;
    return RotatedBox(
      quarterTurns: 1,
      child: TabBarView(
        controller: _tabController,
        children: List.generate(items.length, (index) {
          return FollowPlayerItem(
            videoUrl: items[index]['videoUrl'],
            size: size,
            name: items[index]['name'],
            caption: items[index]['caption'],
            songName: items[index]['songName'],
            profileImg: items[index]['profileImg'],
            likes: items[index]['likes'],
            comments: items[index]['comments'],
            shares: items[index]['shares'],
            views: items[index]['views'] ?? 10,
          );
        }),
      ),
    );
  }

  getExploreBody() {
    var size = MediaQuery.of(context).size;
    return RotatedBox(
      quarterTurns: 1,
      child: TabBarView(
        controller: _tabController,
        children: List.generate(items.length, (index) {
          return ExplorePlayerItem(
            videoUrl: items[index]['videoUrl'],
            size: size,
            name: items[index]['name'],
            caption: items[index]['caption'],
            songName: items[index]['songName'],
            profileImg: items[index]['profileImg'],
            likes: items[index]['likes'],
            comments: items[index]['comments'],
            shares: items[index]['shares'],
            views: items[index]['views'] ?? 10,
          );
        }),
      ),
    );
  }
}

class customTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  customTile(this.icon,this.text,this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          child: Row(
            children: [
              Icon(icon),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text,style: TextStyle(fontSize: 15.0,fontFamily: 'Pacifico'),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

