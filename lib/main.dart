import 'package:dietapp/data/data.dart';
import 'package:dietapp/data/database.dart';
import 'package:dietapp/data/utils.dart';
import 'package:dietapp/style.dart';
import 'package:dietapp/view/body.dart';
import 'package:dietapp/view/food.dart';
import 'package:dietapp/view/worktout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper=DatabaseHelper.instance;

  int currentIndex=0;

  DateTime dateTime=DateTime.now();

  List<Food> foods=[];
  List<Workout> workouts=[];
  List<EyeBody> bodies=[];
  List<Weight> weight=[];

  void getHistories() async{
    int _d=Utils.getFormatTime(dateTime);

    foods=await dbHelper.queryFoodByDate(_d);
    workouts=await dbHelper.queryWorkoutByDate(_d);
    bodies=await dbHelper.queryEyeBodyByDate(_d);
    weight=await dbHelper.queryWeightByDate(_d);

    if(weight.isNotEmpty){
      final w=weight.first;
      wCtrl.text=w.weight.toString();
      mCtrl.text=w.muscle.toString();
      fCtrl.text=w.fat.toString();
    }else{
      wCtrl.text="";
      mCtrl.text="";
      fCtrl.text="";
    }
    setState((){});
  }

  @override
  void initState(){
    super.initState();
    getHistories();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: const Text('비니의 다이어트'),
      ),
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
            backgroundColor: bgColor,
            context:context,
            builder:(ctx){
              return SizedBox(
                height:250,
                child:Column(
                  children: [
                    TextButton(
                      child:const Text("식단"),
                      onPressed:() async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder:(ctx)=>FoodAddPage(
                              food:Food(
                                date:Utils.getFormatTime(dateTime),
                                kcal:0,
                                memo:"",
                                type:0,
                                meal:0,
                                image:"",
                                time:1130,
                              )
                          )));
                        getHistories();
                      }
                    ),
                    TextButton(
                      child:Text("운동"),
                      onPressed:() async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder:(ctx)=>WorkoutAddPage(
                            workout:Workout(
                              date:Utils.getFormatTime(dateTime),
                              time:1130,
                              type:0,
                              kcal:0,
                              intense:0,
                              part:0,
                              distance:0,
                              name:"",
                              memo:"",
                            )
                          ))
                        );
                        getHistories();
                      },
                    ),
                    TextButton(
                      child:Text("몸무게"),
                      onPressed:(){},

                    ),
                    TextButton(
                      child:Text("눈바디"),
                      onPressed:() async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder:(ctx)=>EyeBodyAddPage(
                            body:EyeBody(
                              date:Utils.getFormatTime(dateTime),
                              image:"",
                              memo:"",
                            )
                          ))
                        );
                        getHistories();
                      },
                    ),
                  ],
                ),
              );
            }
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes
      bottomNavigationBar:BottomNavigationBar(

        type:BottomNavigationBarType.fixed,
        items:const [
          BottomNavigationBarItem(
            icon:Icon(Icons.home),
            label:"오늘",
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.calendar_today),
            label:"기록",
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.show_chart),
            label:"몸무게",
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.bar_chart),
            label:"통계",
          )
        ],
        currentIndex: currentIndex,
        onTap:(idx){
          setState((){
            currentIndex=idx;
          });
        }
      ), // auto-formatting nicer for build methods.
    );
  }

  Widget getPage(){
    if(currentIndex==0){
      return getHomeWidget();
    }else if(currentIndex==1){
      return getHistoryWidget();
    }else if(currentIndex==2){
      return getWeightWidget();
    }

    return Container();
  }
  CalendarController calendarController=CalendarController();
  CalendarController weightController=CalendarController();

  TextEditingController wCtrl=TextEditingController();
  TextEditingController mCtrl=TextEditingController();
  TextEditingController fCtrl=TextEditingController();

  Widget getHomeWidget(){
    return Container(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(child:foods.isEmpty? Container(child:ClipRRect(
              child: Image.asset("assets/img/food.png"),borderRadius: BorderRadius.circular(12),)
              ,padding:const EdgeInsets.all(8)):ListView.builder(
            itemBuilder: (ctx,idx){
              return Container(
                child:MainFoodCard(food:foods[idx]),
                height:cardSize,
                width:cardSize,
              );
            },
            itemCount:foods.length,
            scrollDirection: Axis.horizontal,
          ),
            height:cardSize,
          ),
          Container(child:workouts.isEmpty? Container(child:ClipRRect(
            child:Image.asset("assets/img/workout.png"),borderRadius: BorderRadius.circular(12),),
            padding:const EdgeInsets.all(8),):ListView.builder(
            itemBuilder:(ctx,idx){
              return Container(
                height:cardSize,
                width:cardSize,
                child:MainWorkoutCard(workout:workouts[idx]),
              );
            },
            itemCount:workouts.length,
            scrollDirection: Axis.horizontal,
          ),
          height:cardSize
          ),
          Container(child:ListView.builder(
            itemBuilder:(ctx,idx){
              if(idx==0){
                //몸무게
              }else{
                if(bodies.isEmpty){
                  return Container(
                    child:ClipRRect(child:Image.asset("assets/img/body.png"),borderRadius:BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(8),
                    height:cardSize,
                    width:cardSize,
                    color:mainColor,
                  );
                }
                return Container(
                  height:cardSize,
                  width:cardSize,
                  child:MainEyeBodyCard(eyeBody:bodies[0]),
                );
              }
              return Container(
                height:cardSize,
                width:cardSize,
                color:mainColor,
              );
            },
            itemCount:2,
            scrollDirection: Axis.horizontal,
          ),
            height:cardSize,
          ),
        ],
      ),
    );
  }

  Widget getHistoryWidget(){
    return Container(
      child:ListView.builder(
        itemBuilder: (ctx,idx){
          if(idx==0){
            return Container(
              child:TableCalendar(
                calendarController: calendarController,
                initialSelectedDay: dateTime,
                onDaySelected: (date,events,holiday){
                  dateTime=date;
                  getHistories();
                },
                headerStyle:const HeaderStyle(centerHeaderTitle: true),
                initialCalendarFormat: CalendarFormat.month,
                availableCalendarFormats: {CalendarFormat.month:""},
              )
            );
          }else if(idx==1){
            return getHomeWidget();
          }
          return Container();
        },
        itemCount:2,
      )
    );
  }


  Widget getWeightWidget(){

    return Container(
        child:ListView.builder(
          itemBuilder: (ctx,idx){
            if(idx==0){
              return Container(
                  child:TableCalendar(
                    calendarController: weightController,
                    initialSelectedDay: dateTime,
                    onDaySelected: (date,events,holiday){
                      dateTime=date;
                      getHistories();
                    },
                    headerStyle:const HeaderStyle(centerHeaderTitle: true),
                    initialCalendarFormat: CalendarFormat.week,
                    availableCalendarFormats: {CalendarFormat.week:""},
                  )
              );
            }else if(idx==1){
              return Container(
                margin:const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                child:Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${dateTime.month}월 ${dateTime.day}일",style:TextStyle(fontSize:16,fontWeight:FontWeight.bold)),
                        InkWell(
                          child: Container(
                            child:Text("저장",style:TextStyle(fontWeight:FontWeight.bold)),
                            decoration: BoxDecoration(
                              color:mainColor,
                              borderRadius:BorderRadius.circular(8),
                            ),
                            padding:const EdgeInsets.symmetric(horizontal: 10,vertical:6),
                          ),
                          onTap:() async{
                            Weight w;
                            if(weight.isEmpty){
                              w=Weight(date:Utils.getFormatTime(dateTime));
                            }else{
                              w=weight.first;
                            }
                            w.muscle=int.tryParse(mCtrl.text)??0;
                            w.weight=int.tryParse(wCtrl.text)??0;
                            w.fat=int.tryParse(wCtrl.text)??0;

                            await dbHelper.insertWeight(w);
                          }
                        )
                      ],
                    ),
                    Container(height:12),
                    Row(
                      children: [
                        Container(width:8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.stretch,
                            children: [

                              const Text("몸무게",textAlign:TextAlign.center),
                              TextField(
                                controller: wCtrl,
                                keyboardType:TextInputType.number,
                                textAlign:TextAlign.end,
                                decoration: InputDecoration(
                                  border:UnderlineInputBorder(
                                    borderSide:const BorderSide(
                                      color:txtColor,
                                      width:0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8)
                                  ),

                                ),

                              )
                            ],
                          ),
                        ),
                        Container(width:8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.stretch,
                            children: [
                              const Text("근육량",textAlign:TextAlign.center),
                              TextField(
                                controller: mCtrl,
                                keyboardType:TextInputType.number,
                                textAlign:TextAlign.end,
                                decoration: InputDecoration(
                                  border:UnderlineInputBorder(
                                      borderSide:const BorderSide(
                                        color:txtColor,
                                        width:0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                        Container(width:8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.stretch,
                            children: [
                              const Text("지방",textAlign:TextAlign.center),
                              TextField(
                                controller: fCtrl,
                                keyboardType:TextInputType.number,
                                textAlign:TextAlign.end,
                                decoration: InputDecoration(
                                  border:UnderlineInputBorder(
                                      borderSide:const BorderSide(
                                        color:txtColor,
                                        width:0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8)
                                  ),

                                ),

                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )
              );
            }
            return Container();
          },
          itemCount:2,
        )
    );
  }
}
