import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../providers/task_provider.dart';

Future<void> showSmallTaskDialog({
  required BuildContext context,
  ImmutableTask? task,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TransitionBuilder? builder,
}) async {
  Widget dialog = SmallTaskDialog(task: task);
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    anchorPoint: anchorPoint,
  );
}

class SmallTaskDialog extends StatefulWidget {
  final ImmutableTask? task;
  const SmallTaskDialog({super.key, this.task});

  @override
  State<SmallTaskDialog> createState() => _SmallTaskDialogState();
}

class _SmallTaskDialogState extends State<SmallTaskDialog> {
  _SmallTaskDialogState();
  final TextEditingController _taskTitleController = TextEditingController();
  int? _dropdownPriorityValue = Priority.none.value;
  Priority _priority = Priority.none;
  DateTime? _newDateDue;
  bool _hasDueByTime = false;
  bool _isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _taskTitleController.text = widget.task!.title; //task title
      _dropdownPriorityValue = widget.task!.priority.value;
      _priority = widget.task!.priority; //task priority
      _newDateDue = widget.task!.dateDue; //task due date
      _hasDueByTime = widget.task!.hasDueByTime ?? false; //task has due by time
      _isTextFieldEmpty = false;
    }
  }

  void _editTask() {
    String taskTitleText = _taskTitleController.text;
    while (taskTitleText.contains(RegExp(r'  '))) {
      // Remove all extra spaces in sentence.
      taskTitleText = taskTitleText.replaceAll(RegExp(r'  '), ' ');
    }
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (taskTitleText.isNotEmpty) {
      taskProvider.updateTask(
        widget.task!.id,
        newTitle: taskTitleText,
        newPriority: _priority,
        newDateDue: _newDateDue,
        hasDueByTime: _hasDueByTime,
      );
    }

    _taskTitleController.clear();
    Navigator.of(context).pop();
  }

  void _addTask() {
    String taskTitleText = _taskTitleController.text;
    while (taskTitleText.contains(RegExp(r'  '))) {
      // Remove all extra spaces in sentence.
      taskTitleText = taskTitleText.replaceAll(RegExp(r'  '), ' ');
    }
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = taskProvider.createTask(
      title: taskTitleText,
      priority: _priority,
      dateDue: _newDateDue,
      hasDueByTime: _hasDueByTime,
    );
    if (taskTitleText.isNotEmpty) {
      taskProvider.addTask(task);
      _taskTitleController.clear();
      Navigator.of(context).pop();
    }
  }

  void dropdownPriorityCallback(int? priorityValue) {
    setState(() {
      _dropdownPriorityValue = priorityValue;
      _priority = Priority.values.firstWhere((p) => p.value == priorityValue);
    });
  }

  void _showDatePicker() {
    final today = DateTime.now();
    final prevDate = _newDateDue;
    showDatePicker(
      context: context,
      cancelText: "Clear",
      initialDate: _newDateDue ?? today,
      firstDate: today.subtract(const Duration(days: 365 * 25)), // 25 yrs ago
      lastDate: today.add(const Duration(days: 365 * 50)), // 50 yrs from now
    ).then((datePicked) {
      setState(() {
        if (datePicked != null && prevDate != null && _hasDueByTime) {
          _newDateDue = DateTime(
            datePicked.year,
            datePicked.month,
            datePicked.day,
            prevDate.hour,
            prevDate.minute,
          );
        } else {
          _newDateDue = datePicked;
        }
      });
    });
  }

  void _showTimePicker() {
    final TimeOfDay? prevTime =
        _newDateDue == null ? null : TimeOfDay.fromDateTime(_newDateDue!);
    showTimePicker(
      context: context,
      cancelText: "Clear",
      initialTime: prevTime ?? TimeOfDay.now(),
    ).then(
      (timePicked) {
        setState(() {
          var date = _newDateDue!;
          if (timePicked == null) {
            _newDateDue = date;
            _hasDueByTime = false;
          } else {
            _newDateDue = DateTime(
              date.year,
              date.month,
              date.day,
              timePicked.hour,
              timePicked.minute,
            );
            _hasDueByTime = true;
          }
        });
      },
    );
  }

  void _showDateTimePicker() async {
    final today = DateTime.now();
    var datePicked = await showDatePicker(
      context: context,
      cancelText: "Clear",
      initialDate: _newDateDue ?? today,
      firstDate: today.subtract(const Duration(days: 365 * 25)), // 25 yrs ago
      lastDate: today.add(const Duration(days: 365 * 50)), // 50 yrs in future
    );
    if (datePicked == null) {
      setState(() {
        _newDateDue = datePicked;
        _hasDueByTime = false;
      });
    } else {
      var timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        cancelText: "Skip",
      );
      setState(() {
        if (timePicked == null) {
          _newDateDue = datePicked;
          _hasDueByTime = false;
        } else {
          _newDateDue = DateTime(
            datePicked.year,
            datePicked.month,
            datePicked.day,
            timePicked.hour,
            timePicked.minute,
          );
          _hasDueByTime = true;
        }
      });
    }
  }

  var formatterDate = DateFormat('MMM d, yyyy');
  var formatterTime = DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      backgroundColor: themeColors.primaryContainer,
      titlePadding:
          const EdgeInsetsDirectional.only(start: 8, top: 24, end: 24),
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 4),
          widget.task != null
              ? const Text("Edit Task")
              : const Text("Add a Task"),
        ],
      ),
      contentPadding: EdgeInsetsDirectional.only(
        start: 24,
        top: _newDateDue == null ? 0 : 2,
        end: 24,
        // bottom: 24,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_newDateDue != null) ...[
            Container(
              decoration: BoxDecoration(
                  color: themeColors.primaryContainer,
                  border: Border.all(
                    color: themeColors.onPrimaryContainer.withAlpha(50),
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: _showDatePicker,
                    style: TextButton.styleFrom(
                      overlayColor: Colors.transparent,
                    ),
                    child: Text(
                      formatterDate.format(_newDateDue!),
                      style: textTheme.titleSmall!.copyWith(
                        color: themeColors.secondary,
                      ),
                    ),
                  ),
                  if (_hasDueByTime) ...[
                    SizedBox(
                      height: 20,
                      child: VerticalDivider(
                        width: 8,
                        thickness: 1.5,
                        color: themeColors.onPrimaryContainer.withAlpha(75),
                      ),
                    ),
                    TextButton(
                      onPressed: _showTimePicker,
                      style: TextButton.styleFrom(
                        overlayColor: Colors.transparent,
                      ),
                      child: Text(
                        formatterTime.format(_newDateDue!),
                        style: textTheme.titleSmall!.copyWith(
                          color: themeColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          TextField(
            autofocus: widget.task != null ? false : true,
            textInputAction:
                TextInputAction.done, // submit on enter... no new lines
            maxLines: 3, // limit lines displayed
            maxLength: 150, // max # of chars
            maxLengthEnforcement:
                MaxLengthEnforcement.truncateAfterCompositionEnds,
            textCapitalization: TextCapitalization.sentences,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r"\n")), //remove ne
              FilteringTextInputFormatter.deny(RegExp(r"\t")),
            ],
            controller: _taskTitleController,
            decoration: const InputDecoration(
              hintText: 'What are you going to do?',
              border: InputBorder.none, //OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                if (widget.task != null) {
                  _editTask();
                } else {
                  _addTask();
                }
              }
            },
            onChanged: (value) {
              if (_isTextFieldEmpty != value.isEmpty) {
                setState(() {
                  _isTextFieldEmpty = value.isEmpty;
                });
              }
            },
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      // actionsPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      actions: <Widget>[
        Row(
          children: [
            IconButton(
              onPressed: _showDateTimePicker,
              icon: _newDateDue == null
                  ? Icon(Icons.event_busy,
                      color: themeColors.onPrimaryContainer.withAlpha(150))
                  : Icon(Icons.edit_calendar_rounded,
                      color: themeColors.onPrimaryContainer),
            ),
            DropdownButton(
              value: _dropdownPriorityValue,
              iconSize: 0, //remove dropdown arrow
              underline: const SizedBox.shrink(), //remove underline
              borderRadius: BorderRadius.circular(8), //effects dropdown
              items: List.generate(Priority.values.length, (i) {
                Priority priority = Priority.values[i];
                return DropdownMenuItem(
                  value: priority.value,
                  child: Icon(
                    priority == Priority.none
                        ? Icons.flag_outlined
                        : Icons.flag,
                    color: priority.color,
                  ),
                );
              }),
              onChanged: dropdownPriorityCallback,
            ),
            const Spacer(),
            IconButton.filled(
              // style: OutlinedButton.styleFrom(
              //   backgroundColor: themeColors.primary,
              //   foregroundColor: themeColors.primaryContainer,
              //   disabledBackgroundColor: themeColors.error.withOpacity(0.25),
              //   disabledForegroundColor: themeColors.onError.withOpacity(0.5),
              // ),
              color: themeColors.primaryContainer, //icon color
              onPressed: _isTextFieldEmpty
                  ? null // to disable update button
                  : widget.task != null
                      ? () => _editTask()
                      : () => _addTask(),
              icon: widget.task != null
                  ? const Icon(Icons.check)
                  : const Icon(Icons.add),
            ),
          ],
        )
      ],
      actionsAlignment: MainAxisAlignment.center,
      // buttonPadding: const EdgeInsets.symmetric(horizontal: 15),
      // contentPadding: EdgeInsets.symmetric(),
      // actionsPadding: const EdgeInsets.only(bottom: 15),
      // insetPadding: const EdgeInsets.all(50), // outside dialog
    );
  }
}
