import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskito_task_management/category_selection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Models/task.dart';
import 'tasks_repository.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime selectedDate = DateTime.now();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(formatter.format(selectedDate)),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TimeOfDay? time = const TimeOfDay(hour: 12, minute: 12);
  TimeOfDay? time2 = const TimeOfDay(hour: 12, minute: 12);


  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // String newTaskName = '';
  // String newDescription = '';
  String newCategory = '';
  bool isSelected = false;

  @override
  void dispose() {
    taskNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final tasksRepository = ref.watch(tasksProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.indigo.shade400,
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.width/17*4,
          leading: Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions:  [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/24, vertical: MediaQuery.of(context).size.width/19),
              child: Text(
                '👩🏼',
                textScaleFactor: 2.9,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/20, horizontal: MediaQuery.of(context).size.width/17),
              child: Row(
                children: const [
                  Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding:
                     EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/22, horizontal: MediaQuery.of(context).size.width/15),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/100),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Your Task Name',
                            labelStyle: MaterialStateTextStyle.resolveWith(
                                (Set<MaterialState> states) {
                              final Color color =
                                  states.contains(MaterialState.error)
                                      ? Theme.of(context).errorColor
                                      : Colors.black;
                              return TextStyle(color: color, letterSpacing: 1.3);
                            }),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.indigo.shade400),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.indigo.shade400),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                            controller: taskNameController,

                            // onEditingComplete: () async {
                            //   newTaskName = taskNameController.text;
                            // }

                        ),
                      ),

                      Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/45, bottom: MediaQuery.of(context).size.height/190),
                        child: Row(
                          children: const [
                            Text(
                              'DATE',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),


                            // Expanded(
                            //   child: ElevatedButton(
                            //     style: ElevatedButton.styleFrom(
                            //       primary: Colors.indigo.shade400.withOpacity(0.5),
                            //       elevation: 5,
                            //       //onPrimary: Colors.indigo,
                            //       shadowColor: Colors.indigo.shade400,
                            //     ),
                            //     //Colors.black.withOpacity(0.05)),
                            //     onPressed: () => _selectDate(context),
                            //     child:
                            //         Text("${selectedDate.toLocal()}".split(' ')[0]),
                            //   ),
                            // ),

                      InkWell(
                        child: TextField(
                          // showCursor: true,
                          readOnly: true,

                          decoration: InputDecoration(
                            hintText: '${selectedDate.toLocal()}'.split(' ')[0],
                            // labelStyle: MaterialStateTextStyle.resolveWith(
                            //         (Set<MaterialState> states) {
                            //       final Color color =
                            //       states.contains(MaterialState.error)
                            //           ? Theme.of(context).errorColor
                            //           : Colors.indigo.shade400;
                            //       return TextStyle(color: color, letterSpacing: 1.3);
                            //     }),
                            suffixIcon: const Icon(Icons.calendar_month_outlined),
                            suffixIconColor: Colors.indigo.shade400,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Colors.indigo.shade400),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Colors.indigo.shade400),
                            ),

                          ),

                          onTap: (){
                            _selectDate(context);
                          },

                        ),
                      ),


                      Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/30),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 5,
                              child: Text(
                                'Start Time',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            //Spacer(),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'End Time',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: '${time!.hour.toString()}:${time!.minute.toString()}',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2, color: Colors.indigo.shade400),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.indigo.shade400),
                                ),
                              ),
                              onTap: () async {
                                TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime: time!,
                                );
                                if (newTime != null) {
                                  setState(() {
                                    time = newTime;

                                  });
                                }
                              },
                            //    Text(
                            //       '${time!.hour.toString()}:${time!.minute.toString()}'),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 4,
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: '${time2!.hour.toString()}:${time2!.minute.toString()}',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.indigo.shade400),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.indigo.shade400),
                                ),
                              ),
                              onTap: () async {
                                TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime: time2!,
                                );
                                if (newTime != null) {
                                  setState(() {
                                    time2 = newTime;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/25),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: MaterialStateTextStyle.resolveWith(
                                    (Set<MaterialState> states) {
                                  final Color color =
                                  states.contains(MaterialState.error)
                                      ? Theme.of(context).errorColor
                                      : Colors.black;
                                  return TextStyle(color: color, letterSpacing: 1.3);
                                }),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.indigo.shade400),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.indigo.shade400),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                            controller: descriptionController,
                            // onEditingComplete: () async {
                            //   newDescription = descriptionController.text;
                            // }
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/28,bottom: MediaQuery.of(context).size.height/100),
                        child: Row(
                          children: const [
                            Text('CATEGORY',
                              style: TextStyle(
                                fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height/18,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: tasksRepository.categories.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: (){
                                    newCategory = tasksRepository.categories[index].name;

                                    ref.read(tasksProvider).CategorySelect(tasksRepository.categories[index]);

                                    // if(tasksRepository.lock == true){
                                    //   if(tasksRepository.categories[index].isSelected == true) {
                                    //     ref.read(tasksProvider).CategoryUnSelect(tasksRepository.categories[index]);
                                    //   }
                                    // }

                                    // tasksRepository.categories[index].isSelected == false ?
                                    // ref.read(tasksProvider).CategorySelect(tasksRepository.categories[index]):
                                    // ref.read(tasksProvider).CategoryUnSelect(tasksRepository.categories[index]);
                                    //selectedIndex=index;
                                  },
                                     child: CategorySelection(
                                      task_type: tasksRepository.categories[index].name,
                                      dayColor:  index == 0 && tasksRepository.categories[index].isSelected == false ? Colors.orange.shade700 :
                                                 index == 1 && tasksRepository.categories[index].isSelected == false ? Colors.lightGreen.shade700:
                                                 index == 2 && tasksRepository.categories[index].isSelected == false ? Colors.purple.shade700:
                                                 index == 0 && tasksRepository.categories[index].isSelected == true ? Colors.orange.shade50 :
                                                 index == 1 && tasksRepository.categories[index].isSelected == true ? Colors.lightGreen.shade50:
                                                 // index == 2 && tasksRepository.categories[index].isSelected == true ?
                                                 Colors.purple.shade100,
                                      backColor: index == 0 && tasksRepository.categories[index].isSelected == false ? Colors.orange.shade50 :
                                                  index == 1 && tasksRepository.categories[index].isSelected == false ? Colors.lightGreen.shade50 :
                                                  index == 2 && tasksRepository.categories[index].isSelected == false ?Colors.purple.shade100:
                                                 index == 0 && tasksRepository.categories[index].isSelected == true ? Colors.orange.shade700 :
                                                 index == 1 && tasksRepository.categories[index].isSelected == true ? Colors.lightGreen.shade700 :
                                                 //index == 2 && tasksRepository.categories[index].isSelected == true ?
                                                 Colors.purple.shade700,
                                       isSelected: tasksRepository.categories[index].isSelected,

                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/25),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height/15,
                                child: ElevatedButton(
                                    onPressed: () {
                                      ref.read(tasksProvider).addTask(
                                          Task(taskNameController.text, descriptionController.text,
                                              newCategory,DateTime.parse(selectedDate.toLocal().toString().split(' ')[0]),time,time2),ref.read(tasksProvider).lastSelectedDay??DateTime.now());
                                     // ref.read(ta(sksProvider).matchTasks(selectedDate);
                                      Navigator.pop(context);
                                    },
                                    child:
                                    const Text(
                                      'Create New Task',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                    primary: Colors.indigo.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12), // <-- Radius
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
