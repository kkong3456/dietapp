import 'package:dietapp/data/data.dart';
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
            onPressed:(){
              //저장하고 종료
              selectImage();
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
                    child:food.image.isEmpty?Image.asset("assets/img/food.png"):
                        AssetThumb(asset:Asset(food.image,"food.png",0,0),
                        width:cardSize.toInt(),
                        height:cardSize.toInt(),
                        ),
                    aspectRatio: 1/1,
                  ),
                  onTap:(){},
                ),
              );
            }else if(idx==1){
              return Container(
                margin:const EdgeInsets.symmetric(horizontal: 26,vertical: 16),
                child:Column(
                  children: [
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("식사시간"),
                        Text("오전 11:32")
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