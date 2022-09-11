import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirbhaya/dashboard.dart';
import 'package:nirbhaya/global_variables.dart';
import 'package:nirbhaya/myContactsScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneBook extends StatefulWidget {
  @override
  _PhoneBookState createState() => _PhoneBookState();
}

class _PhoneBookState extends State<PhoneBook> {
  List<Contact>? _contacts;
  List<Contact>? filteredContacts;
  List<Contact> _userSelectedContacts = [];

  Permission _permission = Permission.contacts;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  Future<PermissionStatus> _getContactPermission() async {
    _permissionStatus = await _permission.status;

    if (_permissionStatus != PermissionStatus.granted) {
      _permissionStatus = await _permission.request();
      return _permissionStatus;
    } else {
      return _permissionStatus;
    }
  }

  refreshContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      var contacts = (await ContactsService.getContacts(
        withThumbnails: false,
      ))
          .toList();
      setState(() {
        _contacts = contacts;
        filteredContacts = _contacts;
      });
      print(contacts);
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  @override
  initState() {
    super.initState();
    refreshContacts();
  }

  goBack() async {
    // checkFor contacts existance
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Dashboard()), (route) => false);
  }

  saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> numbers = prefs.getStringList("numbers") ?? [];
    if (_userSelectedContacts.isNotEmpty) {
      for (Contact c in _userSelectedContacts) {
        String entity = "";
        if (c.phones!.isNotEmpty) {
          String refactoredNumber =
              refactorPhoneNumbers(c.phones!.first.value!);
          entity = "${c.displayName ?? "User"}***$refactoredNumber";
        } else {
          entity = "${c.displayName ?? "User"}***";
        }
        if (!numbers.contains(entity)) numbers.add(entity);
      }

      prefs.setStringList("numbers", numbers);
      Fluttertoast.showToast(msg: "List Has been Saved");
      goBack();
    } else {
      Fluttertoast.showToast(msg: "Please add atleast one contact");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: saveContacts,
        backgroundColor: GlobalVariables.primaryColor,
        child: Text(
          "Save",
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0),
        ),
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            goBack();
          },
        ),
        title: TextField(
          textInputAction: TextInputAction.search,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            prefixIcon:
                Icon(Icons.search, color: Colors.white70, size: height * 0.03),
            hintText: 'Search Name',
            hintStyle: TextStyle(color: Colors.white70),
          ),
          onChanged: (string) {
            setState(() {
              filteredContacts = _contacts
                  ?.where(
                    (c) => (c.displayName!.toLowerCase().contains(
                          string.toLowerCase(),
                        )),
                  )
                  .toList();
            });
          },
        ),
      ),
      body: _contacts != null
          ? Container(
              height: height,
              width: width,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                separatorBuilder: (context, index) {
                  Contact c = filteredContacts!.elementAt(index);
                  if (c.phones!.isEmpty) {
                    return SizedBox();
                  }
                  return Divider(height: height * 0.01);
                },
                itemCount: filteredContacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact? c = filteredContacts?.elementAt(index);
                  return ItemsTile(addToContacts, c!, c.phones);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      GlobalVariables.primaryColor))),
    );
  }

  addToContacts(Contact con) {
    print(con.phones);
    bool alreadyInList = false;
    for (Contact c in _userSelectedContacts) {
      print("Inside contacts: ID: ${c.displayName}");
      if (c.displayName != null || c.displayName != "") {
        if (c.displayName == con.displayName) {
          alreadyInList = true;
          break;
        }
      } else {
        if (c.phones!.isNotEmpty) {
          if (c.phones!.contains(con.phones!.first)) {
            alreadyInList = true;
            break;
          }
        }
      }
    }
    if (!alreadyInList) {
      _userSelectedContacts.add(con);
      Fluttertoast.showToast(
          msg: "${_userSelectedContacts.length} contacts selected");
    } else {
      Fluttertoast.showToast(msg: "Already in your selected List");
    }
  }

  String refactorPhoneNumbers(String phone) {
    if (phone == null || phone == "") {
      return "";
    }
    var newPhone = phone.replaceAll(RegExp(r"[^\name\w]"), '');
    if (newPhone.length == 12) {
      newPhone = "+" + newPhone.substring(0, newPhone.length);
    }
    if (newPhone.length == 11) {
      newPhone = "+92" + newPhone.substring(1, newPhone.length);
    }
    if (newPhone.length > 12) {
      var start2Number = newPhone.substring(0, 2);
      if (start2Number == "92") {
        newPhone = "+" + newPhone.substring(0, 12);
      }
      if (start2Number == "03") {
        newPhone = "+92" + newPhone.substring(1, newPhone.length);
      }
    }

    return newPhone;
  }
}

class ItemsTile extends StatefulWidget {
  ItemsTile(this.addToContacts, this.c, this._items);
  final Function addToContacts;
  final Contact c;
  final List<Item>? _items;

  @override
  _ItemsTileState createState() => _ItemsTileState();
}

class _ItemsTileState extends State<ItemsTile> {
  String currentContact = '';

  @override
  void initState() {
    super.initState();

    currentContact = '';
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (currentContact.isNotEmpty) {
      currentContact = '';
    }
    return widget._items!.isEmpty
        ? SizedBox()
        : Card(
            elevation: 0,
            child: ListTile(
              onTap: () {
                widget.addToContacts(widget.c);
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              leading: CircleAvatar(
                  backgroundColor: GlobalVariables.primaryColor,
                  child: Text(
                    '${widget.c.displayName![0]}'.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                  radius: height * 0.025),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.c.displayName ?? "",
                    style: TextStyle(
                        color: GlobalVariables.primaryTextColor,
                        fontSize: height * 0.022),
                  ),
                  SizedBox(height: height * 0.01),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget._items!.map((
                        i,
                      ) {
                        if (currentContact == i.value!.replaceAll(" ", "")) {
                          return Row();
                        }
                        currentContact = i.value!.replaceAll(" ", "");
                        return Text(
                          i.value ?? i.label ?? "",
                          style: TextStyle(color: Colors.grey[600]),
                        );
                      }).toList())
                ],
              ),
              trailing: Text('Tap', style: TextStyle(color: Colors.grey[400])),
            ),
          );
  }
}
