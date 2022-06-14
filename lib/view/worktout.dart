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

  @override
  void initState(){
    workout.memo=memoController.text;
    workout.name=nameController.text;
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
                      ),width:70,height:70),
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
                        children:const [
                          Text("식사시간"),
                          Text("식사시간"),
                        ],
                      ),
                      Container(
                        height:12,
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