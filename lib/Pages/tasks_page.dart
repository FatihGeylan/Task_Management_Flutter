import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:taskito_task_management/Pages/add_task.dart';
import 'package:taskito_task_management/hasura_queries_mutations/task_queries_mutations.dart';
import 'package:taskito_task_management/Pages/task_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Models/task.dart';
import '../Repositories/tasks_repository.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  int? selectedIndex;
  DateTime _selectedValue = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DatePickerController _controller = DatePickerController();
  void executeAfterBuild() {
    _controller.animateToSelection();
  }
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => executeAfterBuild());
    super.initState();
  }

  final startTime = DateTime.utc(2022, 5, 1);


  late VoidCallback refetchQuery;

  //List<Task> datedTasks = [];

  // @override
  // void initState() {
  //
  //   super.initState();
  //   ref.read(tasksProvider).matchTasks(_selectedValue);
  // }

  // final DataRepository repository = DataRepository();

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
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                        children: <TextSpan>[
                          TextSpan(text: '${_selectedValue.toLocal()}'.split(' ')[0],
                              style: const TextStyle(fontSize: 16),
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
                  label: const Text('Add Task'),
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
          SizedBox(
            height: MediaQuery.of(context).size.width/5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DatePicker(
                  startTime,
                  //buraya bir DateTime değişkeni vererek geçmiş günlerin de görüntülenmesi sağlanabilmekte.

                  initialSelectedDate: DateTime.parse(formatter.format(_selectedValue)),
                  selectionColor: Colors.indigo.shade400,
                  selectedTextColor: Colors.white,
                  controller: _controller,
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
                   // ref.read(tasksProvider).matchTasks(_selectedValue);
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

          Container(
             height: MediaQuery.of(context).size.height/40*27,
             width: MediaQuery.of(context).size.width,

            decoration: BoxDecoration(
              color: Colors.indigo.shade50,

            ),
            child: Query(
                      options: QueryOptions(
                        fetchPolicy: FetchPolicy.noCache,
                        document: gql(FetchTask().fetchTaskByDate(_selectedValue.toString().split(' ')[0])),
                     // variables: {'page': 0},
                      // variables: {"is_public": false},
                      ),
                      builder: (
                        QueryResult result, {
                        Refetch? refetch,
                        FetchMore? fetchMore,
                        }) {
                        refetchQuery = refetch!;
                        if (result.hasException) {
                          return Text(result.exception.toString());
                        }
                        if (result.isLoading && result.data == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        tasksRepository.datedTasks.clear();
                        if (result.data!['tasks'] != null &&
                            result.data?['tasks'].length != 0) {
                          tasksRepository.datedTasks = result.data!['tasks']
                              .map<Task>((e) => Task.fromJson(e))
                              .toList();
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: tasksRepository.datedTasks.length,
                            itemBuilder: (BuildContext context, int index) {
                              // if(tasksRepository.tasks[index].date == _selectedValue){
                              //   datedTasks.add(tasksRepository.tasks[index]);
                              // }
                              return taskCard(
                                tasksRepository.datedTasks[index], index,
                                //datedTasks[index],index, _selectedValue,
                              );
                            },
                          );
                        // return Column(
                        //   children: <Widget>[
                        //     Expanded(
                        //       child: DisplayTasks(
                        //         tasks: result.data!['tasks'].cast<Map<String, dynamic>>(),
                        //       ),
                        //     ),
                        //     // (result.isLoading)
                        //     //     ? Center(
                        //     //   child: CircularProgressIndicator(),
                        //     // )
                        //     //     : ElevatedButton(
                        //     //   onPressed: () {
                        //     //     fetchMore(
                        //     //       FetchMoreOptions.partial(
                        //     //         variables: {'page': nextPage},
                        //     //         updateQuery: (existing, newReviews) => ({
                        //     //           'reviews': {
                        //     //             'page': newReviews['reviews']['page'],
                        //     //             'reviews': [
                        //     //               ...existing['reviews']['reviews'],
                        //     //               ...newReviews['reviews']['reviews']
                        //     //             ],
                        //     //           }
                        //     //         }),
                        //     //       ),
                        //     //     );
                        //     //   },
                        //     //   child: Text('LOAD PAGE ${nextPage + 1}'),
                        //     // ),
                        //   ],
                        // );

                        // return ListView.builder(
                        //   shrinkWrap: true,
                        //   scrollDirection: Axis.vertical,
                        //   itemCount: tasksRepository.datedTasks.length,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     // if(tasksRepository.tasks[index].date == _selectedValue){
                        //     //   datedTasks.add(tasksRepository.tasks[index]);
                        //     // }
                        //     return InkWell(
                        //       onTap: () {
                        //         String? name;
                        //         //name=taskName[index];
                        //         selectedIndex = index;
                        //       },
                        //       child: taskCard(
                        //         tasksRepository.datedTasks[index], index,
                        //         _selectedValue.toLocal().toString().split(
                        //             ' ')[0],
                        //         //datedTasks[index],index, _selectedValue,
                        //       ),
                        //     );
                        //   },
                        // );
                      }
            ),
          ),

          // StreamBuilder<QuerySnapshot>(
          //     stream: repository.getStream(),
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData) return LinearProgressIndicator();
          //
          //       return _buildList(context, snapshot.data?.docs ?? []);
          //     }),

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
  const taskCard(this.task,this.index, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TaskCard(
      task_type: task.category,
      task_name: task.name,
      dayColor: task.category == 'URGENT' ? Colors.deepOrangeAccent : task.category == 'RUNNING'?Colors.lightGreen:Colors.deepPurpleAccent,
      description: task.description,
      date: task.date,
      startTime: task.start_time,
      endTime: task.end_time,
    );
  }
}
