import 'package:dietapp/style.dart';
import 'package:flutter/material.dart';

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
  int currentIndex=0;

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
                      child:Text("식단"),
                      onPressed:(){}
                    ),
                    TextButton(
                      child:Text("운동"),
                      onPressed:(){},
                    ),
                    TextButton(
                      child:Text("몸무게"),
                      onPressed:(){},
                    ),
                    TextButton(
                      child:Text("눈바디"),
                      onPressed:(){},
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
                height:cardSize,
                width:cardSize,
                color:mainColor,
              );
            },
            itemCount:3,
            scrollDirection: Axis.horizontal,
          ),
            height:cardSize+20,
          ),
          Container(child:ListView.builder(
            itemBuilder:(ctx,idx){
              return Container(
                height:cardSize,
                width:cardSize,
                color:mainColor,
              );
            },
            itemCount:3,
            scrollDirection: Axis.horizontal,
          ),
          height:cardSize+20
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
            height:cardSize+20,
          ),
        ],
      ),
    );
  }
}
