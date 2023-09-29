import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Adicione esta linha

  await _configureLocalTimeZone();

  runApp(MaterialApp(
    home: ReunioesPage(),
  ));
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = 'America/Sao_Paulo'; // Defina o fuso horário desejado
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ReunioesPage extends StatefulWidget {
  @override
  _ReunioesPageState createState() => _ReunioesPageState();
}

class _ReunioesPageState extends State<ReunioesPage> {
  String selectedDate = 'Selecione a data';
  String selectedHour = '01';
  String selectedMinute = '00';
  String alarmName = '';
  String alarmDescription = '';
  int importance = 2; // 0 = Simples, 1 = Normal, 2 = Importante (ou personalize conforme necessário)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reuniões'),
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
                'Nova Reunião',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome da Reunião',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da reunião.';
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
              DropdownButton<int>(
                value: importance,
                onChanged: (int? newValue) {
                  setState(() {
                    importance = newValue ?? 2; // Definir o valor padrão se for nulo
                  });
                },
                items: [
                  DropdownMenuItem<int>(
                    value: 0,
                    child: Text('Simples'),
                  ),
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text('Normal'),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text('Importante'),
                  ),
                ],
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
              ElevatedButton(
                onPressed: () {
                  scheduleMeetingNotification();
                  _showMeetingScheduledDialog(context); // Mostra o pop-up após marcar a reunião
                },
                child: Text('Marcar Reunião'),
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

  void scheduleMeetingNotification() async {
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
        'meeting_channel_id',
        'Meeting Channel',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // ID da notificação
        'Reunião: $alarmName', // Título da notificação
        alarmDescription, // Corpo da notificação
        tz.TZDateTime.from(scheduledTime, tz.local), // Horário agendado
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'Reunião marcada: $alarmName', // Dados adicionais que você pode passar para a notificação
      );

      setState(() {
        // Atualize o estado, se necessário
      });
    }
  }

  void _showDateTimePicker(BuildContext context) async {
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

  void _showMeetingScheduledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reunião Marcada'),
          content: Text('A reunião foi marcada com sucesso.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o pop-up
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
