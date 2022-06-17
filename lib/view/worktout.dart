import 'package:dietapp/data/data.dart';
import 'package:dietapp/data/database.dart';
import 'package:dietapp/data/utils.dart';
import 'package:dietapp/style.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class WorkoutAddPage extends StatefulWidget{
  final Workout workout;

  WorkoutAddPage({Key key,this.workout}):super(key:key);

  @override
  State<StatefulWidget> createState(){
    return _WorkoutAddPageState();
  }
}

class _WorkoutAddPageState extends State<WorkoutAddPage>{
  Workout get workout=>widget.workout;
  TextEditingController memoController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController timeController=TextEditingController();
  TextEditingController calController=TextEditingController();
  TextEditingController distanceController=TextEditingController();

  @override
  void initState(){
    memoController.text=workout.memo;
    nameController.text=workout.name;
    timeController.text=workout.time.toString();
    calController.text=workout.kcal.toString();
    distanceController.text=workout.distance.toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: bgColor,
          iconTheme:const IconThemeData(
            color:txtColor,
          ),
          elevation: 0.3,
          actions:[
            TextButton(
              child:const Text("저장"),
              onPressed:() async {
                //저장하고 종료
                final db=DatabaseHelper.instance;
                workout.memo=memoController.text;
                workout.name=nameController.text;

                if(timeController.text.isEmpty){
                  workout.time=0;
                }else{
                  workout.time=int.parse(timeController.text);
                }

                if(calController.text.isEmpty){
                  workout.kcal=0;
                }else{
                  workout.kcal=int.parse(calController.text);
                }

                if(distanceController.text.isEmpty){
                  workout.distance=0;
                }else{
                  workout.distance=int.parse(distanceController.text);
                }
                await db.insertWorkout(workout);
                Navigator.of(context).pop();
              },
            ),
          ]
      ),
      body:Container(
          child:ListView.builder(
            itemBuilder:(ctx,idx){
              if(idx==0){
                return Container(
                  margin:const EdgeInsets.symmetric(horizontal:16,vertical:16),
                  child:Row(
                    children: [
                      Container(child:InkWell(
                        child:Image.asset("assets/img/${workout.type}.png"),
                        onTap:(){
                          setState((){
                            workout.type++;
                            workout.type=workout.type%4;
                          });
                        }
                      ),width:70,height:70,margin:const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color:ibgColor,
                          borderRadius: BorderRadius.circular(70),
                        ),
                      ),
                      Container(height:8),
                      Expanded(
                        child:TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderSide:const BorderSide(color:txtColor,width:0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )
                      )
                    ],
                  )
                );
              }else if(idx==1){

                return Container(
                  margin:const EdgeInsets.symmetric(horizontal: 26,vertical: 16),
                  child:Column(
                    children: [
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children:[
                          Text("운동시간"),
                          Container(child:TextField(
                            controller:timeController,
                            keyboardType:TextInputType.number,
                            textAlign:TextAlign.end,
                            decoration:InputDecoration(
                              border:UnderlineInputBorder(
                                borderSide:const BorderSide(width:0.5,color:txtColor,),
                                borderRadius:BorderRadius.circular(8)
                            )
                          ),),
                            width:70,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children:[
                          Text("운동칼로리"),
                          Container(child:TextField(
                            controller:calController,
                            keyboardType:TextInputType.number,
                            textAlign:TextAlign.end,
                            decoration:InputDecoration(
                                border:UnderlineInputBorder(
                                    borderSide:const BorderSide(width:0.5,color:txtColor,),
                                    borderRadius:BorderRadius.circular(8)
                                )
                            ),),
                            width:70,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children:[
                          Text("운동거리"),
                          Container(child:TextField(
                            controller:distanceController,
                            keyboardType:TextInputType.number,
                            textAlign:TextAlign.end,
                            decoration:InputDecoration(
                                border:UnderlineInputBorder(
                                    borderSide:const BorderSide(width:0.5,color:txtColor,),
                                    borderRadius:BorderRadius.circular(8)
                                )
                            ),),
                            width:70,
                          )
                        ],
                      ),

                    ],
                  ),);

              }else if(idx==2){
                return Container(
                  margin:const EdgeInsets.symmetric(horizontal: 26,vertical: 16),
                  child:Column(
                    children: [
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("운동 부위"),
                        ],
                      ),
                      Container(
                        height:8,
                      ),
                      GridView.count(
                        physics:const NeverScrollableScrollPhysics(),
                        shrinkWrap:true,
                        crossAxisCount: 4,
                        childAspectRatio:2.5/1, //2가로, 1 세로
                        crossAxisSpacing:4,
                        children: List.generate(wPart.length, (_idx){
                          return InkWell(child:Container(
                            margin:const EdgeInsets.symmetric(vertical: 3,horizontal: 1),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(8),
                              color:workout.part==_idx?mainColor:ibgColor,
                            ),
                            child:Text(wPart[_idx],style:TextStyle(color:workout.part==_idx?Colors.white:iTxColor)),
                          ),
                              onTap:(){
                                setState((){
                                  workout.part=_idx;
                                });
                              }
                          );
                        }),
                      )
                    ],
                  ),);
              }else if(idx==3){
                return Container(
                  margin:const EdgeInsets.symmetric(horizontal: 26,vertical: 16),
                  child:Column(
                    children: [
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("운동 강도"),
                        ],
                      ),
                      Container(
                        height:8,
                      ),
                      GridView.count(
                        physics:const NeverScrollableScrollPhysics(),
                        shrinkWrap:true,
                        crossAxisCount: 4,
                        childAspectRatio:2.5/1, //2가로, 1 세로
                        crossAxisSpacing:4,
                        children: List.generate(wIntense.length, (_idx){
                          return InkWell(child:Container(
                            margin:const EdgeInsets.symmetric(vertical:3,horizontal:1),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(8),
                              color:workout.intense==_idx?mainColor:ibgColor,
                            ),
                            child:Text(wIntense[_idx],style:TextStyle(color:workout.intense==_idx?Colors.white:iTxColor)),
                          ),
                              onTap:(){
                                setState((){
                                  workout.intense=_idx;
                                });
                              }
                          );
                        }),
                      )
                    ],
                  ),);
              }else if(idx==4){
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                  child:Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      const Text("메모"),
                      Container(height:12),
                      TextField(
                        maxLines:5,
                        minLines:5,
                        // keyboardType:TextInputType.multiline,
                        controller: memoController,
                        decoration:InputDecoration(
                            border:OutlineInputBorder(
                              borderSide:const BorderSide(color:txtColor,width:5),
                              borderRadius:BorderRadius.circular(12),
                            )
                        ),
                      )
                    ],
                  ),
                );
              }

              return Container();
            },
            itemCount:5,
          )
      ),
    );
  }
  Future<void> selectImage() async {
    final _img=await MultiImagePicker.pickImages(maxImages: 1,enableCamera: true);

    if(_img.isEmpty){
      return "ERROR";
    }

    setState((){
      // workout.image=_img.first.identifier;
    });

  }
}

class MainWorkoutCard extends StatelessWidget{
  final Workout workout;

  MainWorkoutCard({Key key,this.workout}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Container(
      child:ClipRRect(
        child:AspectRatio(
          aspectRatio: 1/1,
          child:Container(
            margin:const EdgeInsets.all(8),
            padding:const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:bgColor,
              borderRadius:BorderRadius.circular(12),
              boxShadow:const [BoxShadow(blurRadius: 4,spreadRadius:4,color:Colors.black12)]
            ),
            child:Column(
              children: [
                Row(
                  children: [
                    Container(child:Image.asset("assets/img/${workout.type}.png"),width:50,height:50,margin:const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color:ibgColor,
                        borderRadius: BorderRadius.circular(70),
                      ),
                    ),
                    Expanded(
                      child:Text(
                          "${Utils.makeTwoDigit(workout.time ~/60)}:"
                              "${Utils.makeTwoDigit(workout.time%60)}",
                        textAlign:TextAlign.end,

                      ),
                    ),
                  ],
                ),
                Container(height:8),
                Expanded(
                  child:Text(workout.name),
                ),
                Text(workout.kcal==0?"":"${workout.kcal}Kcal"),
                Text(workout.distance==0?"":"${workout.distance}Km"),
              ],
            )
          )
        )
      )
    );
  }
}