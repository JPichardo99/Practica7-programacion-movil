import 'package:flutter/material.dart';
import 'package:socialtec/constants.dart';
import 'package:socialtec/database/database_helper.dart';
import 'package:socialtec/models/event_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  Map<DateTime, List<EventModel>>? selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DatabaseHelper? database;
  bool isCalendarView = true;
  EventModel? evento;

  TextEditingController _eventController = TextEditingController();
  final txtdscEvent = TextEditingController();

  @override
  void initState() {
    super.initState();
    database = DatabaseHelper();
    selectedEvents = {};
  }

  List<EventModel> _getEventsfromDay(DateTime date) {
    return selectedEvents![date] ?? [];
  }

  Future<List<EventModel>> _getEventsfromDayList(DateTime date) async {
    final eventos =
        await database!.getEventsForDay(date.toIso8601String() + 'Z');
    if (eventos != null && eventos.isNotEmpty) {
      return eventos;
    } else {
      return [];
    }
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Eventos")),
        actions: [
          IconButton(
            icon:
                isCalendarView ? Icon(Icons.list) : Icon(Icons.calendar_today),
            onPressed: () {
              setState(() {
                isCalendarView = !isCalendarView;
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<EventModel>>(
        future: database!.getAllEventos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            selectedEvents = {};
            for (var evento in snapshot.data!) {
              DateTime fechaEvento = DateTime.parse(evento.fechaEvento!);
              if (selectedEvents![fechaEvento] == null) {
                selectedEvents![fechaEvento] = [];
              }
              selectedEvents![fechaEvento]!.add(evento);
            }
            return isCalendarView
                ? Column(
                    children: [
                      TableCalendar(
                        focusedDay: selectedDay,
                        firstDay: DateTime.utc(2023, 01, 01),
                        lastDay: DateTime.utc(2050, 01, 01),
                        calendarFormat: format,
                        onFormatChanged: (CalendarFormat _format) {
                          setState(() {
                            format = _format;
                          });
                        },
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        daysOfWeekVisible: true,

                        //Day Changed
                        onDaySelected: (DateTime selectDay, DateTime focusDay) {
                          setState(() {
                            selectedDay = selectDay;
                            focusedDay = focusDay;
                          });
                        },
                        selectedDayPredicate: (DateTime date) {
                          return isSameDay(selectedDay, date);
                        },
                        eventLoader: _getEventsfromDay,
                        //To style the Calendar
                        calendarStyle: CalendarStyle(
                          isTodayHighlighted: true,
                          selectedDecoration: BoxDecoration(
                            color: kPrimaryColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          selectedTextStyle: TextStyle(color: Colors.white),
                          todayDecoration: BoxDecoration(
                            color: kPrimaryLightColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          defaultDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          formatButtonShowsNext: false,
                          formatButtonDecoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          formatButtonTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            BoxDecoration? decoration;
                            TextStyle? textStyle;
                            if (events.isNotEmpty) {
                              int daysDifference =
                                  date.difference(DateTime.now()).inDays;
                              EventModel eventito = events[0] as EventModel;
                              bool? completado = eventito.completado;
                              if (daysDifference >= 1) {
                                // Event is today
                                decoration = const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.yellow,
                                );
                              } else if (daysDifference >= -1 &&
                                  daysDifference < 1) {
                                // Event is in 1 or 2 days
                                decoration = const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.yellow,
                                );
                              } else if (daysDifference < 0 && !completado!) {
                                // Event has passed and not completed
                                decoration = const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                );
                              } else if (daysDifference < 0 && completado!) {
                                // Event has passed and not completed
                                decoration = const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                );
                              } else if (completado!) {
                                // Event has passed and not completed
                                decoration = const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                );
                              }
                            }
                            return Container(
                              width: 10,
                              height: 10,
                              decoration: decoration,
                            );
                          },
                        ),
                      ),
                      ..._getEventsfromDay(selectedDay).map(
                        (EventModel event) => ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  event.dscEvento.toString(),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Center(
                                            child: Text('Detalles del evento',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          content: Form(
                                              child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text('Descripcion del evento'),
                                              SizedBox(height: 5.0),
                                              TextFormField(
                                                initialValue:
                                                    event.dscEvento.toString(),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Por favor, ingresa una descripcion para el evento';
                                                  }
                                                  txtdscEvent.text = event
                                                      .dscEvento
                                                      .toString();
                                                  return null;
                                                },
                                              ),
                                              SizedBox(height: 5.0),
                                              Text('¿Se completo el evento?',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 5.0),
                                              Switch(
                                                value: event.completado!,
                                                onChanged: (value) {
                                                  setState(() {
                                                    event.completado = value;
                                                    event.dscEvento =
                                                        txtdscEvent.text
                                                            .toString();
                                                  });
                                                },
                                                activeColor: kPrimaryColor,
                                                inactiveThumbColor:
                                                    Colors.white,
                                                inactiveTrackColor: Colors.grey,
                                              ),
                                            ],
                                          )),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Actualizar'),
                                              onPressed: () {
                                                database!
                                                    .UPDATE(
                                                        'tblEvento',
                                                        {
                                                          'idEvento':
                                                              event.idEvento,
                                                          'dscEvento':
                                                              txtdscEvent.text
                                                                  .toString(),
                                                          'completado':
                                                              event.completado,
                                                        },
                                                        'idEvento')
                                                    .then((value) {
                                                  var msg = value > 0
                                                      ? 'Evento actualizado'
                                                      : 'Ocurrio un error';
                                                  var snackBar = SnackBar(
                                                      content: Text(msg));
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  setState(() {});
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              content: Text(
                                                  '¿Deseas borrar el evento?'),
                                              actions: [
                                                TextButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                                TextButton(
                                                    child: Text("Borrar"),
                                                    onPressed: () {
                                                      database!
                                                          .DELETE(
                                                              'tblEvento',
                                                              event.idEvento!,
                                                              'idEvento')
                                                          .then((value) {
                                                        var msg = value > 0
                                                            ? 'El evento se ha borrado correctamente'
                                                            : 'Ocurrio un problema';
                                                        var snackBar = SnackBar(
                                                            content: Text(msg));
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                        setState(() {});
                                                      });
                                                    }),
                                              ]));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: 30, // número de días a mostrar en la lista
                          itemBuilder: (context, index) {
                            final day =
                                DateTime.now().add(Duration(days: index));
                            final fecha = DateFormat('yyyy-MM-dd').format(day);
                            return FutureBuilder<List<EventModel>>(
                              future:
                                  _getEventsfromDayList(DateTime.parse(fecha)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // muestra un indicador de carga mientras se espera el resultado
                                }
                                final events = snapshot.data ?? [];
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        DateFormat('EEEE, MMMM d').format(day),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (events.isNotEmpty)
                                      ...events.map(
                                        (event) => ListTile(
                                          title: Row(
                                            children: [
                                              Text(event.dscEvento.toString()),
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Center(
                                                            child: Text(
                                                                'Detalles del evento',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          content: Form(
                                                              child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Text(
                                                                  'Descripcion del evento'),
                                                              SizedBox(
                                                                  height: 5.0),
                                                              TextFormField(
                                                                initialValue: event
                                                                    .dscEvento
                                                                    .toString(),
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                      .isEmpty) {
                                                                    return 'Por favor, ingresa una descripcion para el evento';
                                                                  }
                                                                  txtdscEvent
                                                                          .text =
                                                                      event
                                                                          .dscEvento
                                                                          .toString();
                                                                  return null;
                                                                },
                                                              ),
                                                              SizedBox(
                                                                  height: 5.0),
                                                              Text(
                                                                  '¿Se completo el evento?',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 5.0),
                                                              Switch(
                                                                value: event
                                                                    .completado!,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    event.completado =
                                                                        value;
                                                                    event.dscEvento =
                                                                        txtdscEvent
                                                                            .text
                                                                            .toString();
                                                                  });
                                                                },
                                                                activeColor:
                                                                    kPrimaryColor,
                                                                inactiveThumbColor:
                                                                    Colors
                                                                        .white,
                                                                inactiveTrackColor:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          )),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancelar'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                  'Actualizar'),
                                                              onPressed: () {
                                                                database!
                                                                    .UPDATE(
                                                                        'tblEvento',
                                                                        {
                                                                          'idEvento':
                                                                              event.idEvento,
                                                                          'dscEvento': txtdscEvent
                                                                              .text
                                                                              .toString(),
                                                                          'completado':
                                                                              event.completado,
                                                                        },
                                                                        'idEvento')
                                                                    .then(
                                                                        (value) {
                                                                  var msg = value >
                                                                          0
                                                                      ? 'Evento actualizado'
                                                                      : 'Ocurrio un error';
                                                                  var snackBar =
                                                                      SnackBar(
                                                                          content:
                                                                              Text(msg));
                                                                  Navigator.pop(
                                                                      context);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                  setState(
                                                                      () {});
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                              content: Text(
                                                                  '¿Deseas borrar el evento?'),
                                                              actions: [
                                                                TextButton(
                                                                  child: Text(
                                                                      "Cancel"),
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                ),
                                                                TextButton(
                                                                    child: Text(
                                                                        "Borrar"),
                                                                    onPressed:
                                                                        () {
                                                                      database!
                                                                          .DELETE(
                                                                              'tblEvento',
                                                                              event.idEvento!,
                                                                              'idEvento')
                                                                          .then((value) {
                                                                        var msg = value >
                                                                                0
                                                                            ? 'El evento se ha borrado correctamente'
                                                                            : 'Ocurrio un problema';
                                                                        var snackBar =
                                                                            SnackBar(content: Text(msg));
                                                                        Navigator.pop(
                                                                            context);
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(snackBar);
                                                                        setState(
                                                                            () {});
                                                                      });
                                                                    }),
                                                              ]));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (events.isEmpty)
                                      ListTile(
                                        title: Text(
                                            'No se han encontrado eventos para esta fecha'),
                                      ),
                                    Divider(),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return Center(
              child: Text("No se encontraron eventos"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Añadir nuevo evento"),
            content: TextFormField(
                controller: _eventController,
                decoration: InputDecoration(
                  hintText: "Descripcion del evento",
                )),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Guardar"),
                onPressed: () {
                  if (_eventController.text.isEmpty) {
                    print("El nombre del evento no puede estar vacío");
                  } else {
                    final evento = EventModel(
                        dscEvento: _eventController.text,
                        fechaEvento: selectedDay.toIso8601String(),
                        completado: false);
                    database!.INSERT('tblEvento', evento.toMap()).then((value) {
                      var msg = value > 0
                          ? 'El evento se ha añadido correctamente'
                          : 'Ocurrio un problema';
                      var snackBar = SnackBar(content: Text(msg));
                      Navigator.pop(context);
                      _eventController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {});
                    });
                  }
                },
              ),
            ],
          ),
        ),
        label: Text("Anadir nuevo evento"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
