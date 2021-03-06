import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Models/category.dart';
import '../Models/task.dart';

class TasksRepository extends ChangeNotifier{


  DateTime? lastSelectedDay;




  List<Task> tasks = [ ];

  List<Task> datedTasks = [];

  bool isSelected = false;

  void matchTasks(DateTime date ){
    int counter =0;
    for(int i=0; i<tasks.length;i++ ){
      if(tasks[i].date == date){
        if(i==0){
          datedTasks.clear();
        }
        counter++;
        datedTasks.add(tasks[i]);
      }
      if(counter == 0){
        datedTasks.clear();
      }
    }

    notifyListeners();
  }

  void addTask(Task task,DateTime date){
    tasks.add(task);
    matchTasks(date);
  }

  List<Category> categories = [
    Category('URGENT', false),
    Category('RUNNING', false),
    Category('ONGOING', false),
  ];

  void CategorySelect(Category category){
    if(category.isSelected == true) {
      CategoryUnSelectAll();
    }
    else{
      CategoryUnSelectAll();
      category.isSelected = true;
    }
    // CategoryUnSelectAll();
    // if(category.isSelected == true) {
    //   category.isSelected = true;
    // }

    //lock = true;

    notifyListeners();
  }

  void CategoryUnSelectAll(){
    // category.isSelected = false;
    // lock = false;

    for(int i=0;i<categories.length;i++){
      categories[i].isSelected = false;
    }

    notifyListeners();
  }

  bool lock = false;
}

final tasksProvider = ChangeNotifierProvider((ref){
  return TasksRepository();
});










// List<String> Categories = [
//   'URGENT',
//   'RUNNING',
//   'ONGOING',
// ];
//
// List<String> taskName = [
//   'New Web UI Design Project',
//   'Application Design Meeting',
//   'Web Design Meeting',
// ];

