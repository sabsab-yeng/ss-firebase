import 'package:firebase_app/model/customer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_app/ui/customer/add_customer_infor.dart';
import 'package:firebase_app/service/customer_api_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerListViewPage extends StatefulWidget {
  @override
  _CustomerListViewPageState createState() => _CustomerListViewPageState();
}

class _CustomerListViewPageState extends State<CustomerListViewPage>
    implements AddCustomerCallback {
  bool _anchorToBottom = false;

  // instance of util class
  CustomerApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = CustomerApiService();
    apiService.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // apiService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // it will show title of screen
    Widget _buildTitle(BuildContext context) {
      return InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Customers', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      );
    }

//It will show new customer icon
    List<Widget> _buildActions() {
      return <Widget>[
        IconButton(
          icon: const Icon(
            Icons.add,
          ), // display pop for new entry
          onPressed: () => showEditWidget(null, false),
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        actions: _buildActions(),
        centerTitle: true,
        elevation: 0,
      ),

      // Firebase predefile list widget. It will get customer info from firebase database
      body: FirebaseAnimatedList(
        key: ValueKey<bool>(_anchorToBottom),
        query: apiService.getCustomer(),
        reverse: _anchorToBottom,
        sort: _anchorToBottom
            ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
            : null,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          return SizeTransition(
            sizeFactor: animation,
            child: showCustomer(snapshot),
          );
        },
      ),
    );
  }

  //It will display a item in the list of customers.
  Widget showCustomer(DataSnapshot res) {
    Customer customer = Customer.fromSnapshot(res);
    var item = Card(
      child: Container(
          child: Center(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  child: Text(getShortName(customer)),
                  backgroundColor: const Color(0xFF20283e),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          customer.fname,
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.lightBlueAccent),
                        ),
                        Text(
                          customer.lname,
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.lightBlueAccent),
                        ),
                        Text(
                          customer.phone,
                          style: TextStyle(fontSize: 20.0, color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: const Color(0xFF167F67),
                      ),
                      onPressed: () => showEditWidget(customer, true),
                    ),
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.trash,
                          color: const Color(0xFF167F67)),
                      onPressed: () => showAlertDialog(context, customer),
                    ),
                  ],
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
    );

    return item;
  }

  showAlertDialog(BuildContext context, Customer customer) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        deleteCustomer(customer);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Warning",
        textAlign: TextAlign.center,
      ),
      content: Text("Do you want to delete?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Get first letter from the name of customer
  String getShortName(Customer customer) {
    String shortName = "";
    if (customer.fname.isNotEmpty && customer.lname.isNotEmpty) {
      shortName = customer.fname.substring(0, 1) +
          "." +
          customer.lname.substring(0, 1);
    }
    return shortName;
  }

  //Display popup in customer info update mode.
  showEditWidget(Customer customer, bool isEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AddCustomerDialog().buildAboutDialog(context, this, isEdit, customer),
    );
  }

  //Delete a entry from the Firebase console.
  deleteCustomer(Customer customer) {
    setState(() {
      apiService.deleteCustomer(customer);
    });
  }

// Call util method for add customer information
  @override
  void addCustomer(Customer customer) {
    setState(() {
      apiService.addCustomer(customer);
    });
  }

  // call util method for update old data.
  @override
  void updateCustomer(Customer customer) {
    setState(() {
      apiService.updateCustomer(customer);
    });
  }
}
