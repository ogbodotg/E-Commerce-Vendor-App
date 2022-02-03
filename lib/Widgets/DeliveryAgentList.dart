import 'package:ahia_vendor/Providers/DeliveryProvider.dart';
import 'package:ahia_vendor/Services/FirebaseServices.dart';
import 'package:ahia_vendor/Services/OrderServices.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryAgentList extends StatefulWidget {
  final DocumentSnapshot document;
  DeliveryAgentList(this.document);
  @override
  _DeliveryAgentListState createState() => _DeliveryAgentListState();
}

class _DeliveryAgentListState extends State<DeliveryAgentList> {
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();

  int tag = 0;
  List<String> options = [
    'ALL STATES',
    'ABIA',
    'ADAMAWA',
    'AKWA IBOM',
    'ANAMBRA',
    'BAUCHI',
    'BAYELSA',
    'BENUE',
    'BORNO',
    'CROSS RIVER',
    'DELTA',
    'EBONYI',
    'EDO',
    'EKITI',
    'ENUGU',
    'GOMBE',
    'IMO',
    'JIGAWA',
    'KADUNA',
    'KANO',
    'KATSINA',
    'KEBBI',
    'KOGI',
    'KWARA',
    'LAGOS',
    'NASARAWA',
    'NIGER',
    'OGUN',
    'ONDO',
    'OSUN',
    'OYO',
    'PLATEAU',
    'RIVERS',
    'SOKOTO',
    'TARABA',
    'YOBE',
    'ZAMFARA',
    'FCT-ABUJA',
  ];

  @override
  Widget build(BuildContext context) {
    var _deliveryAgentProvider = Provider.of<DeliveryProvider>(context);
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: Text('Select Delivery Agent',
                  style: TextStyle(color: Colors.white)),
            ),
            Column(
              children: [
                Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width,
                  child: ChipsChoice<int>.single(
                    value: tag,
                    onChanged: (val) {
                      if (val == 0) {
                        setState(() {
                          _deliveryAgentProvider.status = null;
                        });
                      }
                      setState(() {
                        tag = val;
                        _deliveryAgentProvider.status = options[val];
                      });
                    },
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: options,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _services.ahiaDelivery
                        .where('accountVerified', isEqualTo: true)
                        .where('state',
                            isEqualTo:
                                tag > 0 ? _deliveryAgentProvider.status : null)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.data.size == 0) {
                        return Center(
                          child: Text(tag > 0
                              ? 'No delivery agent in ${options[tag]}'
                              : ''),
                        );
                      }

                      return new ListView(
                        shrinkWrap: true,
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return Column(
                            children: [
                              new ListTile(
                                onTap: () {
                                  EasyLoading.show(
                                      status: 'Assigning Delivery Agent');
                                  _services
                                      .selectDeliveryAgents(
                                    orderId: widget.document.id,
                                    location:
                                        '${document.data()['city']} - ${document.data()['state']}',
                                    phoneNumber: document.data()['phoneNumber'],
                                    name: document.data()['deliveryAgentName'],
                                    image:
                                        document.data()['deliveryAgentImage'],
                                    email: document.data()['email'],
                                  )
                                      .then((value) {
                                    EasyLoading.showSuccess(
                                        'Order assigned to delivery agent');
                                    Navigator.pop(context);
                                  });
                                },
                                leading: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white,
                                    child: Image.network(
                                        document.data()['deliveryAgentImage'])),
                                title: new Text(
                                    document.data()['deliveryAgentName'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Phone Number: ${document.data()['phoneNumber']}'),
                                    Text('Email: ${document.data()['email']}'),
                                    Text(
                                        'Address: ${document.data()['address']}'),
                                    Text(
                                        'City/State: ${document.data()['city'] + '-' + document.data()['state']}'),
                                  ],
                                ),
                                trailing: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.phone,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        _orderServices.launchCall(
                                            'tel:${document.data()['phoneNumber']}');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.email,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        _orderServices.launchEmail(
                                            'mailto:${document.data()['email']}?subject=Delivery Agent Contact');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Divider(thickness: 3, color: Colors.grey),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
