import 'package:get/get.dart';
import 'package:MidRemider/chatbot.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:MidRemider/card.dart';
import 'package:MidRemider/notificationPage.dart';
import 'export.dart';
import 'sql.dart';
import 'textRecognitionPage.dart';
import 'widgets.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

bool Dark = false;
List<Map> medList = [];

class _HomePageState extends State<HomePage> {
  SqlDb sql = SqlDb();

  List<Map> r = [];

  Future<List<Map>> readData() async {
    List<Map> response = await sql.read('SELECT * FROM medicine');
    setState(() {
      medList = response;
    });
    return response;
  }

  @override
  void initState() {
    AwesomeNotifications().requestPermissionToSendNotifications();
    NotificationController.startListeningNotificationEvents();
    readData();
    super.initState();
  }

  int barIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: Container(
        height: screenHeight * 0.1,
        decoration: BoxDecoration(
          gradient: Dark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 70, 68, 68),
                    Colors.black87,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue,
                    Color.fromARGB(255, 39, 132, 207),
                  ],
                ),
        ),
        child: BottomNavigationBar(
          elevation: 12,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_fields_sharp),
              label: 'Text Recognition',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_snippet_rounded),
              label: 'Export PDF',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message), // Message icon
              label: 'Message',
              backgroundColor: Colors.transparent,
            ),
          ],
          onTap: (index) {
            setState(() {
              barIndex = index;
            });
          },
          currentIndex: barIndex,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: Dark
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 70, 68, 68),
                      Colors.black87,
                    ],
                  ),
                )
              :BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                       Colors.blue,
                       Color.fromARGB(255, 6, 92, 163)
                    ],
                  ),
                ) ,
        ),
        elevation: 6,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/m.gif',
              height: 50,
              width: 50,
            )
            ,
            Text(
              '\t\t       MedMinder',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                Dark = !Dark;
              });
            },
            icon: Dark ? Icon(Icons.sunny) : Icon(Icons.dark_mode_sharp),
          )
        ],
      ),
      body: barIndex == 0
          ? medList.isNotEmpty
              ? Container(
                  decoration: Dark
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 70, 68, 68),
                              Colors.black87,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        )
                      : null,
                  child: RefreshIndicator(
                    color: Dark ? Colors.white : Colors.blue,
                    backgroundColor: Dark ? Colors.black : Colors.white,
                    onRefresh: readData,
                    child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        ListView.builder(
                          itemCount: medList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return Card1(
                              medList[i]['name'].toString(),
                              medList[i]['time'].toString(),
                              medList[i]['timet'].toString(),
                              medList[i]['frequancy'],
                              medList[i]['type'],
                              medList[i]['quantity'],
                              context,
                              sql,
                              medList[i]['id'],
                              readData,
                              medList[i]['note'],
                              medList[i]['dose'].toString(),
                              medList[i]['refill'].toString(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: Dark
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 70, 68, 68),
                              Colors.black87,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        )
                      : null,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.alarm_add_rounded,
                          size: 50,
                          color: Dark ? Colors.white : Colors.black,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add Your Medicines',
                          style: TextStyle(
                            color: Dark ? Colors.white : Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
          : barIndex == 1
              ? textR_Page()
              :barIndex == 2?Export(): ChatScreen() ,
      floatingActionButton: barIndex == 0
          ? SizedBox(
              width: screenWidth * 0.3,
              child: FloatingActionButton(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: Dark ? Colors.grey[600] : Colors.blue,
                child: Text(
                  'New Medicine',
                  textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/addMedicin');
                },
              ),
            )
          : null,
    );
  }
}

class NotificationController {
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction notification) async {
    SqlDb sql = SqlDb();
    if (notification.id! < 100000) {
      await sql.update(
          'UPDATE medicine SET quantity = quantity-dose WHERE id = "${notification.id}"');
      List<Map> row = await sql
          .read('SELECT * FROM medicine WHERE id = "${notification.id}"');

      if (row[0]['quantity'] <= row[0]['refill']) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: notification.id! + 100,
                channelKey: "basic key",
                title: "Quantity Getting low",
                body:
                    "Your Medicine ${row[0]['name']} has Low Quantity Please Refill",
                notificationLayout: NotificationLayout.BigText,
                category: NotificationCategory.Message,
                fullScreenIntent: true));
      }
      Get.offNamed('/home');
      throw ('');
    } else {
      await sql.update(
          'UPDATE medicine SET quantity = quantity-dose WHERE id = "${notification.id! - 100000}"');
      List<Map> row = await sql.read(
          'SELECT * FROM medicine WHERE id = "${notification.id! - 100000}"');

      if (row[0]['quantity'] <= row[0]['refill']) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: notification.id! + 100,
                channelKey: "basic key",
                title: "Quantity Getting low",
                body:
                    "Your Medicine ${row[0]['name']} has Low Quantity Please Refill",
                notificationLayout: NotificationLayout.BigText,
                category: NotificationCategory.Message,
                fullScreenIntent: true));
      }
      Get.offNamed('/home');
      throw ('');
    }
  }
}
