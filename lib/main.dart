import 'package:dietapp/data/data.dart';
import 'package:dietapp/data/database.dart';
import 'package:dietapp/data/utils.dart';
import 'package:dietapp/style.dart';
import 'package:dietapp/view/body.dart';
import 'package:dietapp/view/food.dart';
import 'package:dietapp/view/worktout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    // weight=await dbHelper.queryWeightByDate(_d);

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
                                date:Utils.getFormatTime(DateTime.now()),
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
                              date:Utils.getFormatTime(DateTime.now()),
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
                              date:Utils.getFormatTime(DateTime.now()),
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
      return getHomeWidget(DateTime.now());
    }

    return Container();
  }

  Widget getHomeWidget(DateTime date){
    return Container(
      child:Column(
        children: [
          Container(child:ListView.builder(
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
          Container(child:ListView.builder(
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
                //눈바디
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
}
