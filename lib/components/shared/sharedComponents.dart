import 'package:flutter/material.dart';
import 'package:todo_remake1/shared/cubit/cubit.dart';

Widget defaultInputForm(
        {required TextEditingController controller,
        required TextInputType type,
        required String? Function(String?)? validator,
        required String label,
        String? hint,
        IconData? suffixIcon,
        bool obsecure = false,
        bool enable = true,
        required IconData prefixIcon,
        void Function()? onTap,
        void Function(String)? onSubmitted,
        void Function(String)? onChanged}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white),
          fillColor: const Color.fromARGB(255, 155, 0, 0),
          label: Text(label),
          hintText: hint,
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.white,
          ),
          suffixIcon: Icon(
            suffixIcon,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 85, 208, 149),
              )),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Colors.white,
              )),
        ),
        controller: controller,
        keyboardType: type,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        obscureText: obsecure,
        onTap: onTap,
        enabled: enable,
      ),
    );

String truncateString(String text, int length) {
  if (text.length <= length) {
    return text;
  } else {
    return '${text.substring(0, length)}...';
  }
}

Widget doneTaskItem(Map model, BuildContext context, {int currentScreen = 0}) =>
    Dismissible(
      key: Key(model["id"].toString()),
      background: Container(
        color: Colors.red,
        child: const Center(
          child: Text(
            "delete",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: const Center(
          child: Text(
            "delete",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        TaskatyCubit.get(context).deleteFromDB(model["id"]);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: const Color.fromARGB(40, 0, 0, 0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      truncateString(model["title"], 22),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          model['time'],
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          model["date"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      TaskatyCubit.get(context)
                          .updateDB(model["id"], "archived");
                    },
                    icon: const Icon(
                      Icons.archive,
                      color: Color.fromARGB(255, 85, 208, 149),
                    )),
              ],
            ),
          ),
        ),
      ),
    );

Widget currentTaskItem(Map model, BuildContext context) => Dismissible(
      key: Key(model["id"].toString()),
      background: Container(
        color: Colors.green,
        child: const Center(
          child: Text(
            "done",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: const Center(
          child: Text(
            "delete",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          TaskatyCubit.get(context).deleteFromDB(model["id"]);
        } else if (direction == DismissDirection.startToEnd) {
          TaskatyCubit.get(context).updateDB(model["id"], "done");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: const Color.fromARGB(40, 0, 0, 0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      truncateString(model["title"], 22),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          model['time'],
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          model["date"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      TaskatyCubit.get(context)
                          .updateDB(model["id"], "archived");
                    },
                    icon: const Icon(
                      Icons.archive,
                      color: Color.fromARGB(255, 85, 208, 149),
                    )),
              ],
            ),
          ),
        ),
      ),
    );

Widget archivedTaskItem(Map model, BuildContext context) => Dismissible(
      key: Key(model["id"].toString()),
      background: Container(
        color: Colors.green,
        child: const Center(
          child: Text(
            "done",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: const Center(
          child: Text(
            "delete",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          TaskatyCubit.get(context).deleteFromDB(model["id"]);
        } else if (direction == DismissDirection.startToEnd) {
          TaskatyCubit.get(context).updateDB(model["id"], "done");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: const Color.fromARGB(40, 0, 0, 0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      truncateString(model["title"], 22),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          model['time'],
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          model["date"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      TaskatyCubit.get(context)
                          .updateDB(model["id"], "current");
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Color.fromARGB(255, 85, 208, 149),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
