import 'package:flutter/material.dart';
import '../screens/journey_planner_screen.dart';

class PanelWidgetTripScheduler extends StatefulWidget {
  const PanelWidgetTripScheduler(
      {Key? key, required ScrollController controller})
      : super(key: key);

  @override
  _PanelWidgetTripScheduler createState() => _PanelWidgetTripScheduler();
}

class _PanelWidgetTripScheduler extends State<PanelWidgetTripScheduler> {
  ScrollController controller = ScrollController();
  int numberOfCyclist = 1; //minimum one cyclist allowed

  void _incrementCounter() {
    setState(() {
      numberOfCyclist++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (numberOfCyclist != 1) {
        numberOfCyclist--;
      }
    });
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 36,
          ),
          fillInInfoText(),
          const SizedBox(height: 24),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const Text(
                "Number of cyclist: ",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
              const SizedBox(
                width: 20,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: "DecBtn",
                      onPressed: _decrementCounter,
                      child: const Icon(
                        Icons.remove_rounded,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('$numberOfCyclist',
                        style: const TextStyle(fontSize: 30.0)),
                    const SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton(
                      heroTag: "IncBtn",
                      onPressed: _incrementCounter,
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 36,
          ),

          Row(
              children:   [
                const SizedBox(
                  width: 20,
                ),
                const SizedBox(
                  width: 180,
                  child: Text(
                    "When would you like to cycle? ",
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.green[500],
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => JourneyPlanner()));
                  },
                  child: const Text('Now'),
                ),

                SizedBox(width: 10,),

                TextButton(
                  style: TextButton.styleFrom(
                     textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.green[500],
                    primary: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text('Later'),
                ),

              ]
            ),
          ],
        );

  Widget fillInInfoText() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Please fill in the following details of your trip",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            )
          ],
        ),
      );
}
