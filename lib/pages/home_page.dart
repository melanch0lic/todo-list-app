import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/record.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentRecordName = '';
  List<Record> records = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoList'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  records.sort(
                      (a, b) => b.recordDate.millisecondsSinceEpoch.compareTo(a.recordDate.millisecondsSinceEpoch));
                });
              },
              icon: const Icon(Icons.sort))
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => Slidable(
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          onChanged: (value) => currentRecordName = value,
                                          decoration: InputDecoration(
                                              labelText: records[index].name,
                                              border: const OutlineInputBorder(),
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                records.removeAt(index);
                                                records.insert(
                                                    0, Record(name: currentRecordName, recordDate: DateTime.now()));
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Редактировать'))
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      backgroundColor: const Color.fromARGB(255, 38, 93, 222),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          records.removeAt(index);
                        });
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(records[index].name),
                  subtitle: Text(DateFormat('d MMMM y, EEEE, HH:mm', 'ru_RU').format(records[index].recordDate)),
                ),
              ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: records.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            onChanged: (value) => currentRecordName = value,
                            decoration: const InputDecoration(
                                hintText: 'Запись',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (currentRecordName.isNotEmpty) {
                                  setState(() {
                                    records.add(Record(name: currentRecordName, recordDate: DateTime.now()));
                                  });
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Добавить'))
                        ],
                      ),
                    ),
                  ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
