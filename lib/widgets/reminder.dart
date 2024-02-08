import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef TimeChangedCallback = Function(TimeOfDay time);
typedef DateChangedCallback = Function(DateTime date);
typedef RepeatChangedCallback = Function(Repeat? repeat);

class Reminder {
  final DateTime date;
  final TimeOfDay time;
  final Repeat repeat;

  const Reminder(this.date, this.time, this.repeat);
}

class ReminderForm extends StatefulWidget {
  final Reminder? initialReminder;

  const ReminderForm(this.initialReminder, {super.key});

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController(text: '');
  final TextEditingController timeController = TextEditingController(text: '');

  DateTime? date;
  TimeOfDay? time;
  Repeat repeat = Repeat.none;

  @override
  void initState() {
    if (widget.initialReminder != null) {
      date = widget.initialReminder!.date;
      dateController.text = formattedDate;

      time = widget.initialReminder!.time;
      timeController.text = formattedTime;

      repeat = widget.initialReminder!.repeat;
    }
    super.initState();
  }

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
                const SizedBox(height:30),
                RepeatRadioButtons(repeat, _handleRepeatChanged),
                FilledButton(
                  onPressed: () => _submitForm(context), 
                  child: const Text('Set reminder'), 
                ),

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

  _handleRepeatChanged(Repeat? repeat) {
    setState(() {
      this.repeat = repeat!;
    });
  }

  _submitForm(BuildContext context) {
    if(!_formKey.currentState!.validate()) return;

    Reminder reminder = Reminder(date!, time!, repeat);
    Navigator.pop<Reminder>(context, reminder);
  }

  String get formattedTime {
    if (time == null) return "";

    DateTime current = DateTime(0, 1, 1, time!.hour, time!.minute);
    return DateFormat.Hm('fr_CA').format(current);
  }

  String get formattedDate {
    return date != null ? DateFormat.yMd('fr_CA').format(date!) : "";
  }
}

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
        labelText: 'Date',
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



enum Repeat { none, daily, weekly,}

class RepeatRadioButtons extends StatelessWidget {
  final Repeat selected;
  final RepeatChangedCallback repeatChanged;

  const RepeatRadioButtons(this.selected, this.repeatChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.only(left: 20,), child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Repeat", style: TextStyle(
            fontSize: 20,
          )),
        )),
        ListTile(
          title: const Text('None'),
          leading: Radio<Repeat>(
            value: Repeat.none,
            groupValue: selected,
            onChanged: repeatChanged,
          ),
        ),
        ListTile(
          title: const Text('Daily'),
          leading: Radio<Repeat>(
            value: Repeat.daily,
            groupValue: selected,
            onChanged: repeatChanged,
          ),
        ),
        ListTile(
          title: const Text('Weekly'),
          leading: Radio<Repeat>(
            value: Repeat.weekly,
            groupValue: selected,
            onChanged: repeatChanged,
          ),
        ),
      ],
    );
  }
}
