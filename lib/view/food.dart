import 'package:dietapp/data/data.dart';
import 'package:dietapp/data/database.dart';
import 'package:dietapp/data/utils.dart';
import 'package:dietapp/style.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class FoodAddPage extends StatefulWidget{
  final Food food;

  FoodAddPage({Key key,this.food}):super(key:key);

  @override
  State<StatefulWidget> createState(){
    return _FoodAddPageState();
  }
}

class _FoodAddPageState extends State<FoodAddPage>{
  Food get food=>widget.food;
  TextEditingController memoController=TextEditingController();
  @override
  void initState(){
    food.memo=memoController.text;
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme:IconThemeData(
          color:txtColor,
        ),
        elevation: 0.3,

        actions:[
          TextButton(
            child:const Text("저장"),
            onPressed:() async {
              print("저장하고 종료");
              final db=DatabaseHelper.instance;
              food.memo=memoController.text;
              // print(food.id);
              // print(food.date);
              // print(food.type);
              // print(food.meal);
              // print(food.kcal);
              // print(food.time);
              // print(food.memo);
              // print(food.image);
              await db.insertFood(food);
              print("저장완료");
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
                margin:const EdgeInsets.symmetric(vertical: 16),
                height: cardSize,
                width:cardSize,
                child:InkWell(
                  child:AspectRatio(
                    child:Align(child:food.image.isEmpty?Image.asset("assets/img/food.png"):
                        AssetThumb(asset:Asset(food.image,"food.png",0,0),
                        width:cardSize.toInt(),
                        height:cardSize.toInt(),
                        )),
                    aspectRatio: 1/1,
                  ),
                  onTap:(){
                    selectImage();
                  },
                ),
              );
            }else if(idx==1){
              String _t=food.time.toString();
              String _m=_t.substring(_t.length-2);
              String _h=_t.substring(0,_t.length-2);
              TimeOfDay time=TimeOfDay(hour:int.parse(_h),minute:int.parse(_m));
              // print("xxx is $_m");
              // print("yyy is $_h");
              return Container(
                margin:const EdgeInsets.symmetric(horizontal: 26,vertical: 16),
                child:Column(
                  children: [
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        Text("식사시간"),
                        InkWell(
                          child:food.time!=null ?
                            Text("${time.hour>11?"오후 ":"오전 "}${Utils.makeTwoDigit(time.hour%12)}"
                                ":${Utils.makeTwoDigit(time.minute)}"):Text("오전 11:32"),
                          onTap:() async {
                            TimeOfDay _time=await showTimePicker(
                              context: context, initialTime: TimeOfDay.now(),
                            );

                            if(_time==null){
                              return;
                            }

                            setState((){
                              food.time=int.parse("${_time.hour}${Utils.makeTwoDigit(_time.minute)}");
                            });
                          }
                        ),
                      ],
                    ),
                    Container(
                      height:12,
                    ),
                    GridView.count(
                      physics:const NeverScrollableScrollPhysics(),
                      shrinkWrap:true,
                      crossAxisCount: 4,
                      childAspectRatio:2.5/1, //2가로, 1 세로
                      crossAxisSpacing:4,
                      children: List.generate(mealTime.length, (_idx){
                        return InkWell(child:Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:BorderRadius.circular(8),
                            color:food.type==_idx?mainColor:ibgColor,
                          ),
                          child:Text(mealTime[_idx],style:TextStyle(color:food.type==_idx?Colors.white:iTxColor)),
                        ),
                          onTap:(){
                            setState((){
                              food.type=_idx;
                            });
                          }
                        );
                      }),
                    )
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
                        Text("식단 평가"),
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
                      children: List.generate(mealType.length, (_idx){
                        return InkWell(child:Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:BorderRadius.circular(8),
                            color:food.meal==_idx?mainColor:ibgColor,
                          ),
                          child:Text(mealType[_idx],style:TextStyle(color:food.meal==_idx?Colors.white:iTxColor)),
                        ),
                            onTap:(){
                              setState((){
                                food.meal=_idx;
                              });
                            }
                        );
                      }),
                    )
                  ],
                ),);


            }else if(idx==3){
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
                      keyboardType:TextInputType.multiline,
                      controller: memoController,
                      decoration:InputDecoration(
                        border:OutlineInputBorder(
                          borderSide:BorderSide(color:txtColor,width:5),
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
          itemCount:4,
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
      food.image=_img.first.identifier;
    });

  }
}

class MainFoodCard extends StatelessWidget{
  final Food food;
  MainFoodCard({Key key,this.food}):super(key:key);

  @override
  Widget build(BuildContext context){
    String _t=food.time.toString();
    String _m=_t.substring(_t.length-2);
    String _h=_t.substring(0,_t.length-2);

    TimeOfDay time=TimeOfDay(hour:int.parse(_h),minute: int.parse(_m));
    
    return Container(
      margin:const EdgeInsets.all(5),
      child:ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 1.0,
          child:Stack(
            children: [
              Positioned.fill(
                child:AssetThumb(
                  asset:Asset(food.image,"food.png",0,0),
                  width:cardSize.toInt(),
                  height:cardSize.toInt(),
                )
              ),
              Positioned.fill(
                child:Container(
                  color:Colors.black26,
                ),
              ),
              Positioned.fill(

                child:Container(
                  child: Text(
                  "${time.hour>11?"오후":"오전"}"
                  "${Utils.makeTwoDigit(time.hour%12)}:"
                  "${Utils.makeTwoDigit(time.minute)}",
                  style:const TextStyle(color:Colors.white, fontWeight:FontWeight.bold,),
                    // textAlign:TextAlign.center,
                  ),
                  alignment:Alignment.center,
                ),
              ),
              Positioned(
                right:6,
                bottom:6,
                child:Container(
                  padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                  child:Text(mealTime[food.meal],style:const TextStyle(color:Colors.white),),
                  decoration: BoxDecoration(
                    color:mainColor,
                    borderRadius:BorderRadius.circular(8)
                  ),
                )
              )
            ],
          )
        ),
      )
    );
  }
}