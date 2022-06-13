import 'package:dietapp/data/data.dart';
import 'package:dietapp/data/utils.dart';
import 'package:dietapp/style.dart';
import 'package:flutter/material.dart';


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
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body:Container(
        child:ListView.builder(
          itemBuilder:(ctx,idx){
            if(idx==0){
              return Container(
                // child:InkWell(
                //   child:Image.asset(""),
                //   onTap:(){},
                // ),
              );
            }else if(idx==1){
              return Container(
                margin:const EdgeInsets.symmetric(horizontal: 26),
                child:Column(
                  children: [
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                      children: const [
                        Text("식사시간"),
                        Text("오전 11:32")
                      ],
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

            }

            return Container();
          },
          itemCount:4,
        )
      ),
    );
  }

}