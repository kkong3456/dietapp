import 'dart:async';

import 'package:dietapp/data/data.dart';
import 'package:dietapp/data/database.dart';
import 'package:dietapp/data/utils.dart';
import 'package:dietapp/style.dart';
import 'package:dietapp/view/body.dart';
import 'package:dietapp/view/food.dart';
import 'package:dietapp/view/worktout.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp();
  changeToDarkMode();
  initializeDateFormatting().then((_) { //캘린더 테이블의 한글지원을 위해
    runZonedGuarded(() async {
      runApp(const MyApp());
    },(error,stackTrace){
      FirebaseCrashlytics.instance.recordError(error,stackTrace);
    }
    );});

}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  final anaylitics=FirebaseAnalytics();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: mainMColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: anaylitics)
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;

  int currentIndex = 0;

  DateTime dateTime = DateTime.now();

  List<Food> foods = [];
  List<Food> allFoods = [];

  List<Workout> workouts = [];
  List<Workout> allWorkouts = [];

  List<EyeBody> bodies = [];
  List<EyeBody> allBodies = [];

  List<Weight> weight = [];
  List<Weight> weights = [];

  void getHistories() async {
    int _d = Utils.getFormatTime(dateTime);

    foods = await dbHelper.queryFoodByDate(_d);
    allFoods = await dbHelper.queryAllFood();

    workouts = await dbHelper.queryWorkoutByDate(_d);
    allWorkouts = await dbHelper.queryAllWorkout();

    bodies = await dbHelper.queryEyeBodyByDate(_d);
    allBodies = await dbHelper.queryAllEyeBody();

    weight = await dbHelper.queryWeightByDate(_d);
    weights = await dbHelper.queryAllWeight();

    if (weight.isNotEmpty) {
      final w = weight.first;
      wCtrl.text = w.weight.toString();
      mCtrl.text = w.muscle.toString();
      fCtrl.text = w.fat.toString();
    } else {
      wCtrl.text = "";
      mCtrl.text = "";
      fCtrl.text = "";
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getHistories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: const Text(''),
          backgroundColor: bgColor,
        ),
        preferredSize: const Size.fromHeight(1.1),
      ),
      body: getPage(),
      backgroundColor: bgColor,
      floatingActionButton: ![0, 1].contains(currentIndex)
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                // setState(() {
                //   changeToDarkMode();
                // });
                // return;
                showModalBottomSheet(
                    backgroundColor: bgColor,
                    context: context,
                    builder: (ctx) {
                      return SizedBox(
                        height: 250,
                        child: Column(
                          children: [
                            TextButton(
                                child: const Text("식단"),
                                onPressed: () async {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (ctx) => FoodAddPage(
                                                  food: Food(
                                                date: Utils.getFormatTime(
                                                    dateTime),
                                                kcal: 0,
                                                memo: "",
                                                type: 0,
                                                meal: 0,
                                                image: "",
                                                time: 1130,
                                              ))));
                                  getHistories();
                                }),
                            TextButton(
                              child: Text("운동"),
                              onPressed: () async {
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (ctx) => WorkoutAddPage(
                                                workout: Workout(
                                              date:
                                                  Utils.getFormatTime(dateTime),
                                              time: 1130,
                                              type: 0,
                                              kcal: 0,
                                              intense: 0,
                                              part: 0,
                                              distance: 0,
                                              name: "",
                                              memo: "",
                                            ))));
                                getHistories();
                              },
                            ),
                            TextButton(
                              child: Text("몸무게"),
                              onPressed: () {},
                            ),
                            TextButton(
                              child: Text("눈바디"),
                              onPressed: () async {
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (ctx) => EyeBodyAddPage(
                                                body: EyeBody(
                                              date:
                                                  Utils.getFormatTime(dateTime),
                                              image: "",
                                              memo: "",
                                            ))));
                                getHistories();
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
      // This trailing comma makes
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: bgColor,
          unselectedItemColor: txtColor,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "오늘",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "기록",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: "몸무게",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "통계",
            )
          ],
          currentIndex: currentIndex,
          onTap: (idx) {
            setState(() {
              currentIndex = idx;
            });
          }), // auto-formatting nicer for build methods.
    );
  }

  Widget getPage() {
    if (currentIndex == 0) {
      return getHomeWidget();
    } else if (currentIndex == 1) {
      return getHistoryWidget();
    } else if (currentIndex == 2) {
      return getWeightWidget();
    } else if (currentIndex == 3) {
      return getStatisticWidget();
    }

    return Container();
  }

  CalendarController calendarController = CalendarController();
  CalendarController weightController = CalendarController();

  TextEditingController wCtrl = TextEditingController();
  TextEditingController mCtrl = TextEditingController();
  TextEditingController fCtrl = TextEditingController();

  Widget getHomeWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: foods.isEmpty
                ? Container(
                    child: ClipRRect(
                      child: Image.asset("assets/img/food.png"),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8))
                : ListView.builder(
                    itemBuilder: (ctx, idx) {
                      return Container(
                        child: MainFoodCard(food: foods[idx]),
                        height: cardSize,
                        width: cardSize,
                      );
                    },
                    itemCount: foods.length,
                    scrollDirection: Axis.horizontal,
                  ),
            height: cardSize,
          ),
          Container(
              child: workouts.isEmpty
                  ? Container(
                      child: ClipRRect(
                        child: Image.asset("assets/img/workout.png"),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, idx) {
                        return Container(
                          height: cardSize,
                          width: cardSize,
                          child: MainWorkoutCard(workout: workouts[idx]),
                        );
                      },
                      itemCount: workouts.length,
                      scrollDirection: Axis.horizontal,
                    ),
              height: cardSize),
          Container(
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                if (idx == 0) {
                  //몸무게
                  if (weight.isEmpty) {
                    return Container();
                  } else {
                    final w = weight.first;
                    return Container(
                      height: cardSize,
                      width: cardSize,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 4,
                                blurRadius: 4,
                              )
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${w.weight}kg",
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  if (bodies.isEmpty) {
                    return Container(
                      child: ClipRRect(
                          child: Image.asset("assets/img/body.png"),
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(8),
                      height: cardSize,
                      width: cardSize,
                      color: mainColor,
                    );
                  }
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainEyeBodyCard(eyeBody: bodies[0]),
                  );
                }
                return Container(
                  height: cardSize,
                  width: cardSize,
                  color: mainColor,
                );
              },
              itemCount: 2,
              scrollDirection: Axis.horizontal,
            ),
            height: cardSize,
          ),
        ],
      ),
    );
  }

  Widget getHistoryWidget() {
    return Container(
        child: ListView.builder(
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          return Container(
              child: TableCalendar(
                locale:"ko-KR",
            calendarController: calendarController,
            initialSelectedDay: dateTime,
            calendarStyle: CalendarStyle(
              selectedColor: mainColor,
            ),
            onDaySelected: (date, events, holiday) {
              dateTime = date;
              getHistories();
            },
            headerStyle: const HeaderStyle(centerHeaderTitle: true),
            initialCalendarFormat: CalendarFormat.month,
            availableCalendarFormats: {CalendarFormat.month: ""},
          ));
        } else if (idx == 1) {
          return getHomeWidget();
        }
        return Container();
      },
      itemCount: 2,
    ));
  }

  int chartIndex = 0;

  Widget getWeightWidget() {
    return Container(
        child: ListView.builder(
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          return Container(
              child: TableCalendar(
                locale:"ko-KR",
            calendarController: weightController,
            initialSelectedDay: dateTime,
            onDaySelected: (date, events, holiday) {
              dateTime = date;
              getHistories();
            },
            headerStyle: const HeaderStyle(centerHeaderTitle: true),
            initialCalendarFormat: CalendarFormat.week,
            availableCalendarFormats: {CalendarFormat.week: ""},
          ));
        } else if (idx == 1) {
          return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${dateTime.month}월 ${dateTime.day}일",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      InkWell(
                          child: Container(
                            child: const Text("저장",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                          ),
                          onTap: () async {
                            Weight w;
                            if (weight.isEmpty) {
                              w = Weight(date: Utils.getFormatTime(dateTime));
                            } else {
                              w = weight.first;
                            }
                            w.muscle = int.tryParse(mCtrl.text) ?? 0;
                            w.weight = int.tryParse(wCtrl.text) ?? 0;
                            w.fat = int.tryParse(wCtrl.text) ?? 0;

                            await dbHelper.insertWeight(w);
                            getHistories();
                            FocusScope.of(context).unfocus();
                          })
                    ],
                  ),
                  Container(height: 12),
                  Row(
                    children: [
                      Container(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("몸무게", textAlign: TextAlign.center),
                            TextField(
                              controller: wCtrl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: txtColor,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("근육량", textAlign: TextAlign.center),
                            TextField(
                              controller: mCtrl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: txtColor,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("지방", textAlign: TextAlign.center),
                            TextField(
                              controller: fCtrl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: txtColor,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ));
        } else if (idx == 2) {
          List<FlSpot> spots = [];

          for (final w in weights) {
            if (chartIndex == 0) {
              //몸무게
              spots.add(FlSpot(w.date.toDouble(), w.weight.toDouble()));
            } else if (chartIndex == 1) {
              //근육량
              spots.add(FlSpot(w.date.toDouble(), w.muscle.toDouble()));
            } else {
              //지방
              spots.add(FlSpot(w.date.toDouble(), w.fat.toDouble()));
            }
          }
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: Text("몸무게",
                              style: TextStyle(
                                  color: chartIndex == 0
                                      ? Colors.white
                                      : iTxColor)),
                          decoration: BoxDecoration(
                              color: chartIndex == 0 ? mainColor : ibgColor,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onTap: () {
                          setState(() {
                            chartIndex = 0;
                          });
                        }),
                    InkWell(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                          child: Text("근육량",
                              style: TextStyle(
                                  color: chartIndex == 1
                                      ? Colors.white
                                      : iTxColor)),
                          decoration: BoxDecoration(
                              color: chartIndex == 1 ? mainColor : ibgColor,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onTap: () {
                          setState(() {
                            chartIndex = 1;
                          });
                        }),
                    InkWell(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                          child: Text("지 방",
                              style: TextStyle(
                                  color: chartIndex == 2
                                      ? Colors.white
                                      : iTxColor)),
                          decoration: BoxDecoration(
                              color: chartIndex == 2 ? mainColor : ibgColor,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onTap: () {
                          setState(() {
                            chartIndex = 2;
                          });
                        })
                  ],
                ),
                Container(
                    height: 300,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: bgColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 4,
                            blurRadius: 4,
                          )
                        ]),
                    child: LineChart(LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            colors: [mainColor],
                          ),
                        ],
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(touchTooltipData:
                            LineTouchTooltipData(getTooltipItems: (spots) {
                          return [
                            LineTooltipItem(
                              "${spots.first.y}kg",
                              TextStyle(color: mainColor),
                            )
                          ];
                        })),
                        titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                                showTitles: true,
                                getTitles: (value) {
                                  DateTime date = Utils.stringToDateTime(
                                      value.toInt().toString());
                                  print("date is $value");
                                  return "${date.day} 일";
                                }),
                            leftTitles: SideTitles(
                              showTitles: false,
                            )))))
              ],
            ),
          );
        }
        return Container();
      },
      itemCount: 3,
    ));
  }

  Widget getStatisticWidget() {
    return Container(
        child: ListView.builder(
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          List<FlSpot> spots = [];

          for (final w in allWorkouts) {
            if (chartIndex == 0) {
              //운동시간
              spots.add(FlSpot(w.date.toDouble(), w.time.toDouble()));
            } else if (chartIndex == 1) {
              //칼로리
              spots.add(FlSpot(w.date.toDouble(), w.kcal.toDouble()));
            } else {
              //운동거리
              spots.add(FlSpot(w.date.toDouble(), w.distance.toDouble()));
            }
          }
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: Text("운동시간",
                              style: TextStyle(
                                  color: chartIndex == 0
                                      ? Colors.white
                                      : iTxColor)),
                          decoration: BoxDecoration(
                              color: chartIndex == 0 ? mainColor : ibgColor,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onTap: () {
                          setState(() {
                            chartIndex = 0;
                          });
                        }),
                    InkWell(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                          child: Text("칼로리",
                              style: TextStyle(
                                  color: chartIndex == 1
                                      ? Colors.white
                                      : iTxColor)),
                          decoration: BoxDecoration(
                              color: chartIndex == 1 ? mainColor : ibgColor,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onTap: () {
                          setState(() {
                            chartIndex = 1;
                          });
                        }),
                    InkWell(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                          child: Text("운동거리",
                              style: TextStyle(
                                  color: chartIndex == 2
                                      ? Colors.white
                                      : iTxColor)),
                          decoration: BoxDecoration(
                              color: chartIndex == 2 ? mainColor : ibgColor,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onTap: () {
                          setState(() {
                            chartIndex = 2;
                          });
                        })
                  ],
                ),
                Container(
                    height: 300,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: bgColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 4,
                            blurRadius: 4,
                          )
                        ]),
                    child: LineChart(LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            colors: [mainColor],
                          ),
                        ],
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(touchTooltipData:
                            LineTouchTooltipData(getTooltipItems: (spots) {
                          return [
                            LineTooltipItem(
                              "${spots.first.y}",
                              TextStyle(color: mainColor),
                            )
                          ];
                        })),
                        titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                                showTitles: true,
                                getTitles: (value) {
                                  DateTime date = Utils.stringToDateTime(
                                      value.toInt().toString());
                                  print("date is $value");
                                  return "${date.day} 일";
                                }),
                            leftTitles: SideTitles(
                              showTitles: false,
                            )))))
              ],
            ),
          );
        } else if (idx == 1) {
          return Container(
              height: cardSize,
              width: cardSize,
              child: ListView.builder(
                itemBuilder: (ctx, _idx) {
                  return MainFoodCard(food: allFoods[_idx]);
                },
                itemCount: allFoods.length,
                scrollDirection: Axis.horizontal,
              ));
        } else if (idx == 2) {
          return Container(
              height: cardSize,
              width: cardSize,
              child: ListView.builder(
                itemBuilder: (ctx, _idx) {
                  return MainWorkoutCard(workout: allWorkouts[_idx]);
                },
                itemCount: allWorkouts.length,
                scrollDirection: Axis.horizontal,
              ));
        } else if (idx == 3) {
          return Container(
              height: cardSize,
              width: cardSize,
              child: ListView.builder(
                itemBuilder: (ctx, _idx) {
                  return MainEyeBodyCard(eyeBody: allBodies[_idx]);
                },
                itemCount: allBodies.length,
                scrollDirection: Axis.horizontal,
              ));
        }
        return Container();
      },
      itemCount: 4,
    ));
  }
}
