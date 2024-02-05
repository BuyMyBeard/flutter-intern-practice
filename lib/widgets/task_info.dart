import 'package:flutter/material.dart';
import 'package:task_manager/providers/task.dart';

// class TaskInfo extends StatelessWidget {

//   final Task task;

//   const TaskInfo(this.task, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text("INfo"),
//     );
//   }
// }

class TaskInfo<T> extends PopupRoute<T> {

  TaskInfo(this.task);

  final Task task;

  @override
  Color? get barrierColor => Colors.black.withAlpha((0x50));

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => task.title;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    double minWidth = MediaQuery.of(context).size.width * .6;
    double maxWidth = MediaQuery.of(context).size.width * .9;
    double maxHeight = MediaQuery.of(context).size.height * .5;
    return Center(
      // Provide DefaultTextStyle to ensure that the dialog's text style
      // matches the rest of the text in the app.
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        // UnconstrainedBox is used to make the dialog size itself
        // to fit to the size of the content.
        child: Container(
            constraints: BoxConstraints(minWidth:minWidth, maxWidth: maxWidth, maxHeight: maxHeight),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )),
                const SizedBox(height: 20),
                Text(
                  task.description,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                ),
              ],
            ),
          ),
        ),
      );
  }
  
}