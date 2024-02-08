import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ReminderForm extends StatefulWidget {
  const ReminderForm({super.key});

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController dateController = TextEditingController(text: '');
  final TextEditingController timeController = TextEditingController(text: '');

  DateTime? date;
  TimeOfDay? time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView( 
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                DatePicker(dateController, _handleDateChanged, date),
                const SizedBox(height: 10),
                TimePicker(timeController, _handleTimeChanged, time),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleDateChanged(DateTime date) {
    setState(() {
      this.date = date;
      dateController.text = formattedDate;
    });
  }

  _handleTimeChanged(TimeOfDay time) {
    setState(() {
      this.time = time;
      timeController.text = formattedTime;
    });
  }

  String get formattedTime {
    return time?.format(context) ?? "";
  }

  String get formattedDate {
    return date != null ? DateFormat.yMd('fr_CA').format(date!) : "";
  }
}

typedef TimeChangedCallback = Function(TimeOfDay time);
typedef DateChangedCallback = Function(DateTime date);

class DatePicker extends StatelessWidget {
  final DateTime? picked;
  final DateChangedCallback dateChanged;
  final TextEditingController controller;

  const DatePicker(this.controller, this.dateChanged, this.picked, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a date';
        }
        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Due Date',
      ),
      readOnly: true,
      controller: controller,
      onTap: () async { 
        DateTime? date = await showDatePicker(
          context: context, 
          currentDate: picked ?? DateTime.now(), 
          firstDate: DateTime.now(), 
          lastDate: DateTime(2100)
        );
        if (date != null) {
          dateChanged(date);
        }
      }
    );
  }
}

class TimePicker extends StatelessWidget {
  final TimeChangedCallback timeChanged;
  final TextEditingController controller;
  final TimeOfDay? picked;

  const TimePicker(this.controller, this.timeChanged, this.picked, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a time';
        }
        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Time',
      ),
      readOnly: true,
      controller: controller,
      onTap: () async { 

        TimeOfDay? time = await showTimePicker(
          context: context, 
          initialTime: picked ?? TimeOfDay.now(),
        );
        if (time != null) {
          timeChanged(time);
        }
      }
    );
  }
}