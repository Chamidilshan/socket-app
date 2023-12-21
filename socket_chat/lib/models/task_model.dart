class Task{
  String task;

  Task({
    required this.task,
});

  factory Task.fromJson(Map<String, dynamic> json){
    return Task(task: json["task"],);
  }

}