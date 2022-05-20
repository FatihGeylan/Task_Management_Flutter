import 'dart:developer';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskito_task_management/add_task.dart';
import 'package:taskito_task_management/task_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Models/task.dart';
import 'calendar.dart';
import 'dates_days.dart';
import 'tasks_repository.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  int? selectedIndex;
  DateTime _selectedValue = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  //List<Task> datedTasks = [];

  // @override
  // void initState() {
  //
  //   super.initState();
  //   ref.read(tasksProvider).matchTasks(_selectedValue);
  // }


  @override
  Widget build(BuildContext context) {
    final tasksRepository = ref.watch(tasksProvider);


    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          'Task',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),


        ),
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text('👩🏼',
              textScaleFactor: 2.9,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/100),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        children: <TextSpan>[
                          TextSpan(text: '${_selectedValue.toLocal()}'.split(' ')[0],
                              style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 24),
                        children: <TextSpan>[
                          TextSpan(text: 'Today',style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _gotoAddTask(context),
                  icon: const Icon(Icons.add_outlined),
                  label: Text('Add Task'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                )

              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width/60),
          Container(
            height: MediaQuery.of(context).size.width/5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DatePicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.parse(formatter.format(_selectedValue)),
                  selectionColor: Colors.indigo.shade400,
                  selectedTextColor: Colors.white,

                  onDateChange: (date) {
                    // New date selected
                    log(date.toString());

                    setState(() {
                      _selectedValue = date;
                      ref.read(tasksProvider).lastSelectedDay=date;
                      // for(int i=0; i<tasksRepository.tasks.length;i++ ){
                      //   if(tasksRepository.tasks[i].date == _selectedValue){
                      //     datedTasks.add(tasksRepository.tasks[i]);
                      //   }
                      // }
                    });
                    ref.read(tasksProvider).matchTasks(_selectedValue);
                  },
                ),
              ],
            )
          ),
          Divider(
            height: MediaQuery.of(context).size.width/20,
            thickness: 1,
            indent: MediaQuery.of(context).size.width/20,
            endIndent: MediaQuery.of(context).size.width/20,
            color: Colors.grey,
          ),
           SizedBox(height: MediaQuery.of(context).size.width/150),
          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height/20*13,
              // width: MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                color: Colors.indigo.shade50,

              ),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: tasksRepository.datedTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  // if(tasksRepository.tasks[index].date == _selectedValue){
                  //   datedTasks.add(tasksRepository.tasks[index]);
                  // }
                  return InkWell(
                    onTap: (){
                      String? name;
                      //name=taskName[index];
                      selectedIndex=index;
                    },
                    child: taskCard(
                      tasksRepository.datedTasks[index],index, _selectedValue,
                      //datedTasks[index],index, _selectedValue,
                    ),
                  );
                },
              ),
            ),
          ),

        ],
      ),
    );
  }

  void _gotoAddTask(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return const AddTaskPage();
    },));
  }
  
}

class taskCard extends StatelessWidget {
  final Task task;
  final int index;
  final DateTime selectedValue;
  const taskCard(this.task,this.index, this.selectedValue, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //bu returnu task.date ile seçilen date uyuyor mu diye kontrol
    //eden bir if statement içine al.
    // if(task.date == selectedValue){
    //
    // }
    return TaskCard(
      task_type: task.category,
      task_name: task.name,
      dayColor: task.category == 'URGENT' ? Colors.deepOrangeAccent : task.category == 'RUNNING'?Colors.lightGreen:Colors.deepPurpleAccent,
      description: task.description,
      date: task.date,
      startTime: task.startTime,
      endTime: task.endTime,

    );
  }
}
