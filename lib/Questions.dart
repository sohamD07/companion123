import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Questions extends StatefulWidget{
Questions(this.doc);
final DocumentSnapshot doc;
@override
QuestionsState createState()=> QuestionsState(doc);
}

class QuestionsState extends State<Questions>{
  QuestionsState(this.document);
  String question,userId;
  User user; FirebaseAuth auth=FirebaseAuth.instance;
  DocumentSnapshot document;
  
  DocumentReference ansRef;

  void getUser() async{
    var user1= await auth.currentUser;
    user=user1;
    userId=user.uid;
  }
  
  @override
  void initState(){
    getUser();
    //ansRef=FirebaseFirestore.instance.collection("answers").doc(userId);
    super.initState();
   
  }
  
 

  void updateAnswer1(newValue) async{
    setState(() {
                FirebaseFirestore.instance.runTransaction((transaction)async{
                  DocumentSnapshot freshSnap=await transaction.get(document.reference);
                  await transaction.update(freshSnap.reference, {
                    'q1old':document.get("q1"),
                    'q1':newValue,
                  });
                });  
              });
  }
  @override
  Widget build(BuildContext context){
    if(document.get("q1")==null) document.reference.set({"q1":1});
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber,
            Colors.deepOrange
          ],
        )
      ),
      child: Stack(
        children: <Widget>[
          Align(child: Text.rich(TextSpan(text: question,
           style:TextStyle(fontStyle: FontStyle.italic,fontSize: 30.0)
           )
           ),
           alignment: Alignment.topCenter,
          ),
          Align(child:FluidSlider(
            
            value:(document.get("q1")==null)?1:document.get("q1"),
            onChanged: (newValue){
              updateAnswer1(newValue);
            },
            // start: Image.asset("less people"),
            // end: Image.asset("more people"),
            min: 1, max: 20,
          ),
          alignment: Alignment.center,
        ),
        Align(child:FlatButton(
              child: Text("Next"),
              onPressed:(){ Navigator.pop(context);},
            ),
            alignment: Alignment.bottomCenter,
         )
        ],
      )  ,
      );
  }
}