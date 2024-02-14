import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmz_patient/dashboard/dashboard.dart';
import 'package:hmz_patient/language/provider/language_provider.dart';
import 'package:hmz_patient/utils/colors.dart';

import '../home/widgets/bottom_navigation_bar.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:date_field/date_field.dart';

import 'dart:async';
import 'dart:convert';

import 'showAppointment.dart';
import '../auth/providers/auth.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class Doctor {
  final String id;
  final String image;
  final String name;

  Doctor({
    this.id,
    this.image,
    this.name,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class PatientAppointmentDetailsScreen extends StatefulWidget {
  static const routeName = '/PatientAppointmentdetail';

  String idd;
  String useridd;
  PatientAppointmentDetailsScreen(this.idd, this.useridd);

  @override
  PatientAppointmentDetailsScreenState createState() =>
      PatientAppointmentDetailsScreenState(this.idd, this.useridd);
}

class PatientAppointmentDetailsScreenState
    extends State<PatientAppointmentDetailsScreen> {
  String idd;
  String useridd;

  PatientAppointmentDetailsScreenState(this.idd, this.useridd);

  bool errordoctorselect = false;
  bool errordoctorslotselect = false;
  

  final _formKey = GlobalKey<FormState>();
  String _ddoctor;
  String _ddoctorId;
  var patientlist = "";

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  String url;

  String _mySelection;
  String _mySelection2;
  String _mySelection3;

  List data = List();

  List doctorDataList = [];
  List<DropdownMenuItem<Doctor>> dropdownDoctorItems;

  List doctorSlotList = [];
  List<DropdownMenuItem> dropdownDoctorSlotItems;
  var selectedDoctorSlot;

  List data2 = List();
  List data3 = ['Confirmed', 'Pending', 'Requested'];
  String availableSlot = '';
  TextEditingController appointmentStatus = TextEditingController();
  String _patient;
  DateTime selectedDate;

  bool _isloading = true;

  String _date = "";
  TextEditingController _remarks = TextEditingController();

  List<dynamic> buildDoctorSlotItems(List doctorslot) {
    List<String> itemss = List();
    doctorSlotList = new List();
    for (var zdoctor in doctorslot) {
      doctorSlotList
          .add([zdoctor['s_time'] + " To " + zdoctor['e_time'], false]);

      itemss.add(
        zdoctor['s_time'] + " To " + zdoctor['e_time'],
      );
    }

    return itemss;
  }

  

  Future<String> getDoctorSlot(getslot) async {
    var res = await http
        .get(Uri.encodeFull(getslot), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data2 = resBody;

      buildDoctorSlotItems(resBody);
      
    });

    return "success";
  }

  

  Future<String> getSWData() async {
    String urrr1 = url;

    var res = await http.get(
      urrr1,
      headers: {"Accept": "application/json"},
    );
    var resBody = json.decode(res.body);
    

    setState(() {
      doctorDataList = resBody;
      

      _isloading = false;
    });


    return "Sucess";
  }

  Future<String> makeAppointment(context) async {
    String posturl = Auth().linkURL + "api/addAppointment";
    

    final res = await http.post(
      posturl,
      body: {
        'patient': this._patient,
        'doctor': this._ddoctor,
        'date': this._date,
        'status': this.appointmentStatus.text,
        'time_slot': this.availableSlot,
        'user_type': 'patient',
        'remarks': this._remarks.text,
      },
    );

    if (res.statusCode == 200 && _patient != "") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).success),
              content:
                  Text(AppLocalizations.of(context).appointmentCreatedMessage),
              actions: [
                FlatButton(
                  child: Text(AppLocalizations.of(context).ok),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        ShowPatientAppointmentScreen.routeName);
                  },
                )
              ],
            );
          });

      return 'success';
    } else {
      return "error";
    }
  }

  bool _firstclick = true;

  @override
  void initState() {
    super.initState();

    url = Auth().linkURL + "api/getDoctorList?id=${this.useridd}";

    

   

    this.getSWData();

    _patient = this.idd;
    appointmentStatus = new TextEditingController(text: 'Requested');
  }

  AppColor appcolor = new AppColor();
  
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).appointment,
          style: TextStyle(
            color: appcolor.appbartext(),
            fontWeight: appcolor.appbarfontweight()
          ),
        ),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed(DashboardScreen.routeName),
        ),
        centerTitle: true,
        backgroundColor: appcolor.appbarbackground(),
        elevation: 0.0,
        iconTheme: IconThemeData(color: appcolor.appbaricontheme()),
      ),
      body: (_isloading)
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: ListView(
              padding: EdgeInsets.only(left: 20, right: 20),
              children: [
                SizedBox(height: 10),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: SearchableDropdown.single(

                          displayClearIcon: false,
                          items: doctorDataList.map((item) {
                            return new DropdownMenuItem(
                              child: Container(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                          'assets/images/icon.png'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(item["name"]),
                                  ],
                                ),
                              ),
                              value: item,
                            );
                          }).toList(),
                          value: _ddoctor,
                          hint: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Choose a doctor",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          searchHint: "Search doctor",
                          onChanged: (value) {
                            setState(() {
                              errordoctorselect = false;
                              _ddoctor = value["id"];
                              
                              availableSlot="";

                               
                                    
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                    this._date = formattedDate;
                                    String getslot = Auth().linkURL +
                                        'api/getDoctorTimeSlop?doctor_id=' +
                                        _ddoctor +
                                        '&date=' +
                                        this._date;
                                    getDoctorSlot(getslot);
                                  
                            });
                          },
                          isExpanded: true,
                        ),
                      ),

                      (errordoctorselect)
                          ? Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                " No Doctor selected",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(),

                     

                      Container(
                        padding: EdgeInsets.all(20),
                        child: TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          headerStyle: HeaderStyle(
                              formatButtonVisible: false, titleCentered: true),


                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },

                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay =
                                  focusedDay; 
                              

                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(_selectedDay);
                              this._date = formattedDate;
                              
                              String getslot = Auth().linkURL +
                                  'api/getDoctorTimeSlop?doctor_id=' +
                                  _ddoctor +
                                  '&date=' +
                                  formattedDate;
                              availableSlot = "";
                              getDoctorSlot(getslot);

                            });
                          },

                          calendarFormat: CalendarFormat.twoWeeks,
                          
                          calendarStyle: CalendarStyle(
                            defaultTextStyle: TextStyle(
                              fontSize: 15,
                            ),
                            isTodayHighlighted: false,
                            cellMargin: EdgeInsets.all(5),
                            selectedDecoration: BoxDecoration(
                              color: Colors.orange[800].withOpacity(.7),
                              shape: BoxShape.circle,
                            ),
                            selectedTextStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                          locale: langProvider.locale.languageCode,
                          pageJumpingEnabled: true,
                          pageAnimationEnabled: true,
                        ),
                      ),

                      

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: Center(child: Text("Available slots")),
                        ),
                      ),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: (true) ? 180 : 0,
                            decoration: BoxDecoration(
                                border: Border(
                              top: BorderSide(
                                  width: 1, 
                                  color: Colors.black12
                                ),
                              bottom: BorderSide(
                                  width: 1, color: Colors.black12),
                            )),
                            child: Scrollbar(
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: (50 / 23),
                                  ),
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: const EdgeInsets.all(5),
                                  physics: ClampingScrollPhysics(),
                                  itemCount: doctorSlotList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextButton(
                                        style: (doctorSlotList[index][1] ==
                                                true)
                                            ? ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.amber[800]),
                                              )
                                            : ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                              ),
                                        onPressed: () {
                                          setState(() {
                                            for (var listdatas = 0;listdatas <doctorSlotList.length;listdatas++) {
                                              if (doctorSlotList[listdatas][0] !=doctorSlotList[index][0]) {
                                                doctorSlotList[listdatas][1] =false;
                                              }
                                              errordoctorslotselect = false;
                                            }
                                            doctorSlotList[index][1] = true;
                                            availableSlot = doctorSlotList[index][0];

                                            
                                          });
                                        },
                                        child: Container(
                                          child: Center(
                                              child: Text(
                                            "${doctorSlotList[index][0]}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: (!doctorSlotList[index]
                                                        [1])
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ),
                      (errordoctorslotselect)
                          ? Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                " No Slot selected",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(),

                      

                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1.5, color: Colors.blue[100]),
                            )),
                            child: Theme(
                              data: theme.copyWith(primaryColor: Colors.blue),
                              child: TextFormField(
                                controller: _remarks,
                                decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context).remarks,
                                    hintText: AppLocalizations.of(context)
                                        .giveYourRemarks,
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context)
                                        .invalidInput;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      

                      Container(
                        width: double.infinity,
                        
                        child: ElevatedButton(
                          onPressed: () {
                            

                            if (_formKey.currentState.validate()) {
                              if (_ddoctor == "" || _ddoctor == null) {
                                
                                setState(() {
                                  errordoctorselect = true;
                                });
                              } else if (availableSlot == "" ||
                                  availableSlot == null) {

                                setState(() {
                                  errordoctorslotselect = true;
                                });
                              } else {
                                
                                makeAppointment(context);

                              }
                            }
                            
                          },
                          child: Text(AppLocalizations.of(context).save),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
    );
  }
}
