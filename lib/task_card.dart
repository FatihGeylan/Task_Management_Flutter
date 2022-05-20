import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TaskCard extends StatelessWidget {
  final String task_type;
  final String task_name;
  final String description;
  final Color dayColor;
  final DateTime date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  TaskCard({
        required this.task_type,
        required this.task_name,
        required this.dayColor,
        required this.description,
        required this.date,
        required this.startTime,
        required this.endTime,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/50, horizontal: MediaQuery.of(context).size.width/22),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/40,right: MediaQuery.of(context).size.width/40,top:MediaQuery.of(context).size.width/40),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30),
                    child: Container(
                      height: MediaQuery.of(context).size.height/19,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task_type,
                            style: TextStyle(
                                fontSize: 20,
                                color: dayColor,
                                fontWeight: FontWeight.normal),
                          ),
                          const Divider(
                            height: 20,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              IntrinsicHeight(
                child: Row(
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    VerticalDivider(
                      width: MediaQuery.of(context).size.width/21,
                      thickness: 2,
                      indent: MediaQuery.of(context).size.width/80,
                      endIndent: 0,
                      color: dayColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Container(

                            width: MediaQuery.of(context).size.width-90,
                            child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  task_name,
                                  style: const TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold),
                                ),

                                  Spacer(),

                                       // IconButton(
                                       //   icon: const Icon(Icons.more_vert), onPressed: () {  },
                                       // ),
                                PopupMenuButton(
                                  // add icon, by default "3 dot" icon
                                     icon: Icon(Icons.more_vert),
                                    itemBuilder: (context){
                                      return [
                                        PopupMenuItem<int>(
                                          value: 0,
                                          child: Text("Does"),
                                        ),

                                        PopupMenuItem<int>(
                                          value: 1,
                                          child: Text("Nothing"),
                                        ),

                                        PopupMenuItem<int>(
                                          value: 2,
                                          child: Text("For now"),
                                        ),
                                      ];
                                    },
                                    onSelected:(value){
                                      if(value == 0){
                                        print("My account menu is selected.");
                                      }else if(value == 1){
                                        print("Settings menu is selected.");
                                      }else if(value == 2){
                                        print("Logout menu is selected.");
                                      }
                                    }
                                ),



                              ],
                            ),
                          ),
                          Text(description, style: TextStyle(fontSize: 16),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.access_time)
                        ),
                        // const Text('10 - 11 AM', style: TextStyle(fontSize: 16),)
                        Text('${startTime!.hour.toString()}:${startTime!.minute.toString()} - ${endTime!.hour.toString()}:${endTime!.minute.toString()}'
                            ,style: TextStyle(fontSize: 15),
                        ),
                        // Text('${endTime!.hour.toString()}:${endTime!.minute.toString()}'),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     IconButton(
                  //         onPressed: (){},
                  //         icon: const Icon(Icons.people_alt)
                  //     ),
                  //     const Text('2 People', style: TextStyle(fontSize: 16),)
                  //   ],
                  // ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.calendar_month_outlined),
                        ),
                        Text('${date.toLocal()}'.split(' ')[0]
                          ,style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
