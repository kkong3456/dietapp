import 'package:dietapp/data/data.dart';
import 'package:dietapp/data/database.dart';
import 'package:dietapp/data/utils.dart';
import 'package:dietapp/style.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class EyeBodyAddPage extends StatefulWidget{
  final EyeBody body;

  EyeBodyAddPage({Key key,this.body}):super(key:key);

  @override
  State<StatefulWidget> createState(){
    return _EyeBodyAddPageState();
  }
}

class _EyeBodyAddPageState extends State<EyeBodyAddPage>{
  EyeBody get body=>widget.body;
  TextEditingController memoController=TextEditingController();
  @override
  void initState(){
    body.memo=memoController.text;
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
                body.memo=memoController.text;
                print("body.memo is ${body.memo}");
                await db.insertEyeBody(body);
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
                      child:Align(child:body.image.isEmpty?Image.asset("assets/img/body.png"):
                      AssetThumb(asset:Asset(body.image,"body.png",0,0),
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
            itemCount:2,
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
      body.image=_img.first.identifier;
    });

  }
}

class MainEyeBodyCard extends StatelessWidget{
  final EyeBody eyeBody;
  MainEyeBodyCard({Key key,this.eyeBody}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Container(
        margin:const EdgeInsets.all(5),
        height:cardSize,
        child:ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
              aspectRatio: 1.0,
              child:Stack(
                children: [
                  Positioned.fill(
                      child:AssetThumb(
                        asset:Asset(eyeBody.image,"body.png",0,0),
                        width:cardSize.toInt(),
                        height:cardSize.toInt(),
                      )
                  ),
                  Positioned.fill(
                    child:Container(
                      color:Colors.black26,
                    ),
                  ),
                ],
              )
          ),
        )
    );
  }}
