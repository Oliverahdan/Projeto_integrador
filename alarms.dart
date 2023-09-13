import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  await _loadIcon();
  runApp(MaterialApp(
    home: AlarmsScreen(),
  ));
}

Future<void> _loadIcon() async {
  final ByteData data = await rootBundle.load('assets/2.png');
  final List<int> bytes = data.buffer.asUint8List();
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('assets/2.png');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AlarmsScreen extends StatefulWidget {
  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  String selectedDate = 'Selecione a data';
  String selectedHour = '01'; // Hora de 1 AM
  String selectedMinute = '00'; // Minuto 0

  String alarmName = '';
  String alarmDescription = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> scheduleAlarm() async {
    if (_formKey.currentState!.validate()) {
      final DateTime scheduledTime = DateTime(
        int.parse(selectedDate.split('/')[2]), // Ano
        int.parse(selectedDate.split('/')[1]), // Mês
        int.parse(selectedDate.split('/')[0]), // Dia
        int.parse(selectedHour), // Hora
        int.parse(selectedMinute), // Minutos
      );

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'alarm_channel_id',
        'Alarm Channel',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // ID da notificação
        alarmName, // Título da notificação
        alarmDescription, // Corpo da notificação
        tz.TZDateTime.from(scheduledTime, tz.local), // Horário agendado
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'Alarme selecionado', // Dados adicionais que você pode passar para a notificação
      );

      setState(() {
        // Atualize o estado, se necessário
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despertador'),
        backgroundColor: Color(0xFFFCD167),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Novo Alarme',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome do Alarme',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do alarme.';
                  }
                  return null;
                },
                onChanged: (value) {
                  alarmName = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  alarmDescription = value;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showDateTimePicker(context);
                },
                child: Text('Selecionar Data e Hora'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFEA86BF),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Data e Hora Selecionadas:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Data: $selectedDate',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Hora: $selectedHour:$selectedMinute',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  scheduleAlarm();
                },
                child: Text('Marcar Alarme'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFEA86BF),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDateTimePicker(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: currentDate.add(Duration(days: 365)), // Um ano a partir da data atual
    );

    if (selectedDate != null) {
      setState(() {
        this.selectedDate =
            "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString()}";
      });
    }

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: 1, // Inicialmente, 1 AM
        minute: 0, // Inicialmente, 0 minuto
      ),
    );

    if (selectedTime != null) {
      setState(() {
        this.selectedHour = selectedTime.hour.toString().padLeft(2, '0');
        this.selectedMinute = selectedTime.minute.toString().padLeft(2, '0');
      });
    }
  }
}
