import 'package:black_coffer/video_controller.dart';
import 'package:black_coffer/video_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  final String valuee; //to store phone number
  const Home({super.key, required this.valuee});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController search = TextEditingController();
  bool b = false; //cicularbutton inside the add video icon in stack
  bool isFabVisible =
      true; //change the color of floating action button when cliked
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Listen to changes in focus on the text field
    _textFieldFocusNode.addListener(() {
      if (_textFieldFocusNode.hasFocus) {
        // Text field is focused, hide the FloatingActionButton
        setState(() {
          isFabVisible = false;
        });
      } else {
        // Text field lost focus, show the FloatingActionButton
        setState(() {
          isFabVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var sw = MediaQuery.of(context).size.width;
    var sh = MediaQuery.of(context).size.height;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // var n = 0;

    firestore.collection('client').doc(widget.valuee).get().then((value) {
      // n = value['variable'];
    });
    VideoController videoController = Get.put(VideoController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Center(
          child: Text(
            'BLACK COFFER',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add notification icon press logic here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 10, 15),
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Center(
                          child: TextField(
                            focusNode: _textFieldFocusNode,
                            controller: search,
                            onChanged: (Value) {
                              setState(() {});
                            },
                            textAlign: TextAlign.justify,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 20.0),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Video",
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  height: sh * 0.7,
                  width: sw,
                  margin: const EdgeInsets.all(5),
                  child: CustomScrollView(
                    slivers: [
                      FutureBuilder(
                        future: fetchData(search.text),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SliverToBoxAdapter(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                child: const Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return SliverToBoxAdapter(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  String Title =
                                      "${snapshot.data?[index]['Title']}";
                                  String Desc =
                                      "${snapshot.data?[index]['Desc']}";
                                  String Category =
                                      "${snapshot.data?[index]['Category']}";
                                  String Address =
                                      "${snapshot.data?[index]['Address']}";
                                  String Url =
                                      "${snapshot.data?[index]['path']}";
                                  return ListTile(
                                    title: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoPlayerPage(
                                                    videoUrl: Url,
                                                    Title: Title,
                                                    Desc: Desc,
                                                    Category: Category,
                                                    Address: Address,
                                                  )),
                                        );
                                      },
                                      child: SizedBox(
                                        width: sw,
                                        height: 140,
                                        child: Container(
                                            //main

                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 236, 236, 236),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Image
                                                SizedBox(
                                                  width: 60,
                                                  child: Image.asset(
                                                      "assets/images/latest1.png"),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                // Text Information
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Title
                                                        Text(
                                                          Title,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),

                                                        // Category
                                                        Text(
                                                          Category,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),

                                                        // Address
                                                        Text(
                                                          Address,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  );
                                },
                                childCount: snapshot.data?.length ?? 0,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/images/photos2.png'), // Replace with your user image
                    radius: 30,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'BLACK COFFER',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'Number: ${widget.valuee}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Add settings logic
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                // Add help logic
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // AppBar

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isFabVisible
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () async {
                setState(() {
                  b = true;
                });
                await videoController.pickVideo(context, widget.valuee);
                setState(() {
                  b = false;
                });
              },
              backgroundColor:
                  // colorchange ? Colors.black :
                  const Color.fromRGBO(253, 52, 96, 1.0),
              foregroundColor:
                  // colorchange ?
                  Colors.white,
              child: Stack(children: [
                if (b == false) const Icon(Icons.add),
                if (b == true)
                  const SpinKitCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
              ])
              // : Colors.white,
              )
          : null, // FloatingActionButton
      bottomNavigationBar: Container(
        height: 65,
        decoration: const BoxDecoration(color: Colors.white),
        child: BottomAppBar(
          notchMargin: 5,
          shape: const CircularNotchedRectangle(),
          color: const Color.fromARGB(255, 255, 255, 255),
          child: IconTheme(
            data: const IconThemeData(
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  tooltip: 'Open navigation menu',
                  icon: const Icon(Icons.home),
                  onPressed: () {},
                ),
                IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.feed),
                  onPressed: () {},
                ),
                IconButton(
                  tooltip: 'Download',
                  icon: const Icon(Icons.download),
                  onPressed: () {},
                ),
                IconButton(
                  tooltip: 'Open navigation menu',
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    ); // BottomAppBar
    // Scaffold
  }

  Future<List<Map<String, dynamic>>> fetchData(String searchQuery) async {
    List<Map<String, dynamic>> data = [];

    for (int index = 0; index >= 0; index++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('client')
          .doc(widget.valuee)
          .collection('0')
          .doc('$index')
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> itemData =
            documentSnapshot.data() as Map<String, dynamic>;
        if (itemData['Title'] != null) {
          if (searchQuery == "") {
            data.add(itemData);
          } else {
            if (itemData['Title']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase())) {
              data.add(itemData);
            }
          }
        } else {}
      } else {
        break;
      }
    }

    return data;
  }
}
