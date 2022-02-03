import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  CollectionReference vendorBanner =
      FirebaseFirestore.instance.collection('vendorBanner');

  CollectionReference coupons =
      FirebaseFirestore.instance.collection('coupons');

  CollectionReference ahiaDelivery =
      FirebaseFirestore.instance.collection('AhiaDelivery');

  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  CollectionReference ahiaUsers =
      FirebaseFirestore.instance.collection('Ahia Users');

  Future<void> publishProduct({id}) {
    return products.doc(id).update({
      'published': true,
    });
  }

  Future<void> unPublishProduct({id}) {
    return products.doc(id).update({
      'published': false,
    });
  }

  Future<void> deleteProduct({id}) {
    return products.doc(id).delete();
  }

  Future<void> saveVendorBanner(url) {
    return vendorBanner.add({
      'bannerUrl': url,
      'sellerUid': user.uid,
    });
  }

  Future<void> deleteVendorBanner({id}) {
    return vendorBanner.doc(id).delete();
  }

  Future<void> saveCoupon(
      {document, title, discountRate, expiryDate, details, active}) {
    if (document == null) {
      return coupons.doc(title).set({
        'title': title,
        'discountRate': discountRate,
        'expiryDate': expiryDate,
        'details': details,
        'active': active,
        'sellerId': user.uid,
      });
    }
    return coupons.doc(title).update({
      'title': title,
      'discountRate': discountRate,
      'expiryDate': expiryDate,
      'details': details,
      'active': active,
      'sellerId': user.uid,
    });
  }

  Future<void> selectDeliveryAgents(
      {orderId, location, name, phoneNumber, image, email}) {
    var result = orders.doc(orderId).update({
      'deliveryBoy': {
        'location': location,
        'name': name,
        'phoneNumber': phoneNumber,
        'image': image,
        'email': email,
      }
    });
    return result;
  }

  Future<DocumentSnapshot> getCustomerDetails(id) async {
    DocumentSnapshot doc = await ahiaUsers.doc(id).get();
    return doc;
  }
}
