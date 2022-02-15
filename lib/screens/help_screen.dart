import 'package:flutter/material.dart';
import 'package:veloplan/utilities/help_bot_manager.dart';

class HelpPage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<HelpPage> {
  late HelpBotManager helpBot;
  @override
  void initState() {
    helpBot = HelpBotManager();
    super.initState();
  }

  List<String> someList = [];

  List<Widget> _createChildren() {
    return new List<Widget>.generate(someList.length, (int index) {
      return Text(someList[index].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Center(
        child: Column(
          children: [
            Column(
              children: _createChildren(),
            ),
            Row(
              children: <Widget>[
                for (String item in helpBot.getAllMessageTopics())
                  TextButton(
                    onPressed: () {
                      setState(() {
                        someList.add(helpBot.getMessageTextsbyTopic(item));
                        someList.add(helpBot.getAnswerToQuestion(item));
                      });
                    },
                    child: Text(item),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://cdn.vox-cdn.com/thumbor/qCfHPH_9Mw78vivDlVDMu7xYc78=/715x248:1689x721/920x613/filters:focal(972x299:1278x605):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/69305239/shrek4_disneyscreencaps.com_675.0.jpg'),
          ),
          SizedBox(width: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("HelpBot")],
          )
        ],
      ),
    );
  }
}
