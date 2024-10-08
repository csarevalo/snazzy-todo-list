import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task_sort_options.dart';
import '../../providers/task_preferences_controller.dart';

Future<void> showSortTasksDialog({
  required BuildContext context,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TransitionBuilder? builder,
}) async {
  Widget dialog = const SortTasksDialog();
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

class SortTasksDialog extends StatelessWidget {
  const SortTasksDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final taskPreferences = context.read<TaskPreferencesController>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: themeColors.primaryContainer,
      alignment: Alignment.bottomCenter,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Group By",
                style: textTheme.titleSmall,
              ),
            ],
          ),
          Selector<TaskPreferencesController, TaskSortOptions>(
              selector: (_, taskPrefs) => taskPrefs.taskSortOptions,
              builder: (_, taskSortOptions, __) {
                return SortDropdownButton(
                  value: groupByToString(taskSortOptions.groupBy),
                  menuItems: taskSortOptions.groupOptions,
                  onValueChanged: (value) {
                    if (value == null) return;
                    GroupBy groupBy = strToGroupBy(value);
                    taskPreferences.updateTaskSortOptions(newGroupBy: groupBy);
                  },
                );
              }),
          Row(
            children: [
              Text(
                "Sort By",
                style: textTheme.titleSmall,
              ),
            ],
          ),
          Selector<TaskPreferencesController, TaskSortOptions>(
              selector: (_, taskPrefs) => taskPrefs.taskSortOptions,
              builder: (_, taskSortOptions, __) {
                return SortDropdownButton(
                  value: sortByToString(taskSortOptions.sort1stBy),
                  menuItems: taskSortOptions.sortOptions
                      .where((opt) => opt != "None")
                      .toList(),
                  onValueChanged: (value) {
                    if (value == null) return;
                    SortBy sortBy = strToSortBy(value);
                    taskPreferences.updateTaskSortOptions(
                      newSort1stBy: sortBy,
                    );
                  },
                  onToggleSorting: () => taskPreferences.updateTaskSortOptions(
                    newDesc1: !taskSortOptions.desc1,
                  ),
                  desc: taskSortOptions.desc1,
                );
              }),
          Row(children: [
            Text(
              "Then By",
              style: textTheme.titleSmall,
            ),
          ]),
          Selector<TaskPreferencesController, TaskSortOptions>(
              selector: (_, taskPrefs) => taskPrefs.taskSortOptions,
              builder: (_, taskSortOptions, __) {
                return SortDropdownButton(
                  value: sortByToString(taskSortOptions.sort2ndBy),
                  menuItems: taskSortOptions.sortOptions,
                  onValueChanged: (value) {
                    if (value == null) return;
                    SortBy sortBy = strToSortBy(value);
                    taskPreferences.updateTaskSortOptions(
                      newSort2ndBy: sortBy,
                    );
                  },
                  onToggleSorting: () => taskPreferences.updateTaskSortOptions(
                    newDesc2: !taskSortOptions.desc2,
                  ),
                  desc: taskSortOptions.desc2,
                );
              }),
        ],
      ),
    );
  }
}

class SortDropdownButton extends StatelessWidget {
  final String value;
  final List<String> menuItems;
  final void Function(String?)? onValueChanged;
  final void Function()? onToggleSorting;
  final bool? desc;

  const SortDropdownButton({
    super.key,
    required this.value,
    required this.menuItems,
    required this.onValueChanged,
    this.onToggleSorting,
    this.desc = true,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme themeColors = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: DropdownButton(
        isExpanded: true,
        // isDense: true,
        style: textTheme.titleMedium!.copyWith(color: themeColors.primary),
        underline: const SizedBox.shrink(),
        value: value,
        onChanged: onValueChanged,
        items: (menuItems).map<DropdownMenuItem<String>>((String strMenuItem) {
          return DropdownMenuItem(
            value: strMenuItem,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: onToggleSorting == null
                      ? themeColors.error
                      : themeColors.tertiary,
                  radius: 5,
                ),
                const SizedBox.square(dimension: 8),
                Text(strMenuItem),
              ],
            ),
          );
        }).toList(),
        icon: onToggleSorting == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: onToggleSorting,
                  padding: const EdgeInsets.all(0),
                  icon: desc!
                      ? Icon(
                          Icons.keyboard_double_arrow_down,
                          color: themeColors.primary,
                        )
                      : Icon(Icons.keyboard_double_arrow_up,
                          color: themeColors.primary),
                ),
              ),
      ),
    );
  }
}