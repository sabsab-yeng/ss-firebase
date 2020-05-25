import 'package:firebase_app/model/customer.dart';
import 'package:flutter/material.dart';

class AddCustomerDialog {
  final teFirstname = TextEditingController();
  final teLastName = TextEditingController();
  final teGender = TextEditingController();
  final tePhone = TextEditingController();

  Customer customer;

  static const TextStyle linkStyle =
      TextStyle(color: Colors.blue, decoration: TextDecoration.underline);

  Widget buildAboutDialog(
      BuildContext context,
      AddCustomerCallback _myCustomerPageState,
      bool isEdit,
      Customer customer) {
    if (customer != null) {
      this.customer = customer;
      teFirstname.text = customer.fname;
      teLastName.text = customer.lname;
      teGender.text = customer.gender;
      tePhone.text = customer.phone;
    }

    return AlertDialog(
      title: Text(isEdit ? "Edit detail" : "Add new customer"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextField("First Name", teFirstname),
            getTextField("Last Name", teLastName),
            getTextField("Gender", teGender),
            getTextField("Phone", tePhone),
            InkWell(
              onTap: () => onTap(isEdit, _myCustomerPageState, context),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: getAppBorderButton(isEdit ? "Edit" : "Add",
                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Customer getData(bool isEdit){
    return Customer(isEdit ? customer.id : "", teFirstname.text, teLastName.text, teGender.text, tePhone.text);

  }

  onTap(bool isEdit, AddCustomerCallback _myCustomerState, BuildContext context){
    if(isEdit){
      _myCustomerState.updateCustomer(getData(isEdit));
    }else{
      _myCustomerState.addCustomer(getData(isEdit));
    }
    Navigator.pop(context);
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(10),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF28324E),
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        buttonLabel,
        style: TextStyle(
          color: Color(0xFF28324E),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget getTextField(String inputBox, TextEditingController inputController) {
    var loginBtn = Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: inputController,
        decoration: InputDecoration(hintText: inputBox),
      ),
    );
    return loginBtn;
  }
}

//call back of customer page
abstract class AddCustomerCallback {
  void addCustomer(Customer customer);
  void updateCustomer(Customer customer);
}