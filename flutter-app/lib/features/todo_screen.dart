import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_chat/controller/task_controller.dart';
import 'package:socket_chat/models/task_model.dart';
import 'package:socket_chat/task_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  TextEditingController taskTypingController = TextEditingController();
  TextEditingController dateTypingController = TextEditingController();
  late IO.Socket socket;
  TaskController  taskController = TaskController();

  @override
  void initState() {
    socket = IO.io(
        'http://localhost:4000',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());

    socket.connect();
    setUpSocketListner();
    super.initState(); 
  }

  void setUpSocketListner() {
    socket.on('message-receive', (data) {
      print(data);
      taskController.taskMessages.add(Task.fromJson(data));
    });
  }


  void addTask(String text) {

    var taskJson = {
      "task": text,
     // "date": date
    };

    // Emit the taskJson object, not just the text
    socket.emit("message", text);
    taskController.taskMessages.add(Task.fromJson(taskJson));

    print('hello');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Expanded(
              flex: 4,
              child: Obx(
                  () => Center(
                    child: ListView.builder(
                      itemCount: taskController.taskMessages.length,
                      itemBuilder: (context, index) {
                        var currentTask = taskController.taskMessages[index];
                        return TaskCard(
                          taskName: currentTask.task,
                          //date: currentTask.date,
                        );
                      }
                ),
                  ),
              )
          ),
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.purple,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: taskTypingController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Task',
                          filled: true,
                          fillColor: Colors.grey,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 6.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: dateTypingController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Date',
                          filled: true,
                          fillColor: Colors.grey,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 6.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(color: Colors.red)
                                )
                            )
                        ),
                        onPressed: () {
                        if(taskTypingController.text.isNotEmpty
                            //&& dateTypingController.text.isNotEmpty
                        ){
                          addTask(taskTypingController.text);
                          taskTypingController.clear();
                          dateTypingController.clear();
                        }else{

                        }
                        },
                        child: Text(
                            "Submit",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        )
                    )
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
