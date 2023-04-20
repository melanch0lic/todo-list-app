import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/record_hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentRecordName = '';
  List<Record> records = [];

  void _setup() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(RecordAdapter());
    }
    final box = await Hive.openBox<Record>('recordsBox');
    box.listenable().addListener(() {
      setState(() {
        records = box.values.toList();
      });
    });
    setState(() {
      records = box.values.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
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
                                            onPressed: () async {
                                              final box = await Hive.openBox<Record>('recordsBox');
                                              box.putAt(
                                                  index,
                                                  Record(
                                                      name: currentRecordName,
                                                      recordDate: DateTime.now(),
                                                      isChecked: false));
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
                      onPressed: (context) async {
                        final box = await Hive.openBox<Record>('recordsBox');
                        box.deleteAt(index);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: () async {
                    final box = await Hive.openBox<Record>('recordsBox');
                    box.putAt(
                        index,
                        Record(
                            name: records[index].name,
                            recordDate: records[index].recordDate,
                            isChecked: !records[index].isChecked!));
                  },
                  leading: Checkbox(
                    value: records[index].isChecked ?? false,
                    onChanged: (value) async {
                      final box = await Hive.openBox<Record>('recordsBox');
                      box.putAt(index,
                          Record(name: records[index].name, recordDate: records[index].recordDate, isChecked: value));
                    },
                  ),
                  title: Text(
                    records[index].name,
                    style: records[index].isChecked!
                        ? const TextStyle(decoration: TextDecoration.lineThrough)
                        : const TextStyle(),
                  ),
                  subtitle: Text(DateFormat('d MMMM y, EEEE, HH:mm', 'ru_RU').format(records[index].recordDate)),
                ),
              ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: records.length),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          showDialog(
              barrierDismissible: false,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
                                  onPressed: () async {
                                    if (currentRecordName.isNotEmpty) {
                                      if (!Hive.isAdapterRegistered(1)) {
                                        Hive.registerAdapter(RecordAdapter());
                                      }
                                      final box = await Hive.openBox<Record>('recordsBox');
                                      box.add(Record(
                                          name: currentRecordName, recordDate: DateTime.now(), isChecked: false));
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('Добавить')),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Отменить'))
                            ],
                          )
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
