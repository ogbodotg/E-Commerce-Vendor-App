import 'package:ahia_vendor/Pages/AddEditCoupon.dart';
import 'package:ahia_vendor/Services/FirebaseServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: _services.coupons
              .where('sellerId', isEqualTo: _services.user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            // if (!snapshot.hasData) {
            //   return Center(
            //     child: Text('No discount coupons added yet'),
            //   );
            // }

            return new Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.pushNamed(context, AddEditCoupon.id);
                        },
                        child: Text(
                          'Add New Coupon',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                FittedBox(
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Discount Rate')),
                      DataColumn(label: Text('Expiry Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Details')),
                    ],
                    rows: _couponList(snapshot.data, context),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  List<DataRow> _couponList(QuerySnapshot snapshot, context) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      if (document != null) {
        var date = document.data()['expiryDate'];
        var expiry = DateFormat.yMMMd().add_jm().format(date.toDate());
        return DataRow(cells: [
          DataCell(Text(document.data()['title'])),
          DataCell(Text(document.data()['discountRate'].toString())),
          DataCell(Text(expiry.toString())),
          DataCell(Text(document.data()['active'] ? 'Active' : 'Inactive')),
          DataCell(IconButton(
            icon: Icon(Icons.info_outline_rounded),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditCoupon(document: document)));
            },
          )),
        ]);
      }
    }).toList();
    return newList;
  }
}
