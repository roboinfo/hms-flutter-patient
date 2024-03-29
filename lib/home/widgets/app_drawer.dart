import 'package:flutter/material.dart';
import 'package:hmz_patient/doctorsearch/doctordepartment.dart';
import 'package:hmz_patient/doctorsearch/doctordetail.dart';
import 'package:hmz_patient/doctorsearch/doctorlist.dart';
import 'package:hmz_patient/payment/allInvoices.dart';
import 'package:hmz_patient/payment/deposit.dart';
import 'package:hmz_patient/prescription/screens/prescription_detail_screen.dart';
import 'package:hmz_patient/profile/fullProfile.dart';
import '../../setting/setting.dart';
import '../../prescription/screens/user_prescriptions_screen.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth.dart';


import '../../patient/appointment.dart';
import '../../patient/showAppointment.dart';
import '../../patient/todaysappointment.dart';

import '../../jitsi/jitsi.dart';
import '../../payment/addPayment.dart';
import '../../payment/showPayment.dart';

import '../../dashboard/dashboard.dart';
import '../../profile/changePassword.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.redAccent,
              toolbarHeight: 150,
              title: Center(child: Text('Patient Express')),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              
              leading: Icon(Icons.dashboard, 
              ),
              title: Text(AppLocalizations.of(context).dashboard),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);

              },
              
            ),
            Divider(height: 3,),

            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                leading: Icon(Icons.list, 
                ),
                title: Text(AppLocalizations.of(context).appointment),
                children: <Widget>[

                  Padding(

                    padding: const EdgeInsets.only(left:20),
                    child: ListTile(
                      leading: Icon(Icons.add_circle_outline,
                      ),
                      title: Text(AppLocalizations.of(context).appointmentRequest),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(PatientAppointmentDetailsScreen.routeName);
                      },
                    ),
                  ),

                  

                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: ListTile(
                      leading: Icon(Icons.today,
                      ),
                      title: Text(AppLocalizations.of(context).todaysAppointment),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            ShowTodaysAppointmentScreen.routeName);
                      },
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: ListTile(
                      leading: Icon(Icons.list, 
                      ),
                      title: Text(AppLocalizations.of(context).appointmentList),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(ShowPatientAppointmentScreen.routeName);
                      },
                    ),
                  ),

                  
                ],
              ),
            ),

            
            
            Divider(height: 3,),

            

            ListTile(
              leading: Icon(Icons.file_copy, 
              ),
              title: Text( AppLocalizations.of(context).prescription),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(UserPrescriptionsScreen.routeName);
              },
            ),

            Divider(height: 2,),

            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                leading: Icon(Icons.payment, 
                ),
                title: Text(AppLocalizations.of(context).payment),
                children: <Widget>[

                  Padding(

                    padding: const EdgeInsets.only(left:20),
                    child: ListTile(
                      leading: Icon(Icons.payment,),
                      title: Text(AppLocalizations.of(context).addPayment),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(AddPaymentScreen.routeName);
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: ListTile(
                      leading: Icon(Icons.payments_outlined, ),
                      title: Text(AppLocalizations.of(context).allInvoices),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(AllInvoicePayment.routeName);
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: ListTile(
                      leading: Icon(Icons.payments_outlined),
                      title: Text(AppLocalizations.of(context).deposit),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(DepositPayment.routeName);
                      },
                    ),
                  ),

                  
                ],
              ),
            ),


           
            Divider(height: 3,),

            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent
              ),
              child: ExpansionTile(
                
                leading: Icon(Icons.search,
                ),
                title: Text(AppLocalizations.of(context).doctorsearch),
                children: <Widget>[

                  Padding(

                    padding: const EdgeInsets.only(left:20),
                    child: ListTile(
                      leading: Icon(Icons.add_business_rounded),
                      title: Text(AppLocalizations.of(context).department),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(DoctorDepartmentScreen.routeName);
                      },
                    ),
                  ),

                  

                 

                  
                ],
              ),
            ),


            



            Divider(height: 3,),

            ListTile(
              leading: Icon(Icons.person,
              ),
              title: Text(AppLocalizations.of(context).profile),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(FullProfile.routeName);
              },
            ),


            Divider(height: 3,),
            ListTile(
              leading: Icon(Icons.settings,
              ),
              title: Text( AppLocalizations.of(context).setting),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(SettingScreen.routeName);
              },
            ),

            
            

            
            Divider(height: 3,),
            ListTile(
              leading: Icon(Icons.exit_to_app, 
              ),
              title: Text(AppLocalizations.of(context).logout),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
