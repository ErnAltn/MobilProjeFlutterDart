import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Contact {
  String name;
  String surname;
  String phoneNumber;

  Contact(
      {required this.name, required this.surname, required this.phoneNumber});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Contact> contacts = [
    Contact(name: 'Eren', surname: 'Altan', phoneNumber: '05051420185'),
    Contact(name: 'Kadir', surname: 'Çiftçi', phoneNumber: '5555555555'),
    Contact(name: 'Ahmet', surname: 'Şengül', phoneNumber: '11111111111'),
    Contact(name: 'Cihat', surname: 'Bakır', phoneNumber: '22222222222'),
    Contact(name: 'Ahmet', surname: 'Altan', phoneNumber: '33333333333'),
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  bool showForm = false;
  bool isEditing = false;
  int editingIndex = -1;

  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = contacts;
  }

  void toggleForm() {
    setState(() {
      showForm = !showForm;
      if (!showForm) {
        isEditing = false;
        editingIndex = -1;
        nameController.clear();
        surnameController.clear();
        phoneNumberController.clear();
      }
    });
  }

  void addContact() {
    String name = nameController.text;
    String surname = surnameController.text;
    String phoneNumber = phoneNumberController.text;

    if (isEditing) {
      setState(() {
        contacts[editingIndex] = Contact(
          name: name,
          surname: surname,
          phoneNumber: phoneNumber,
        );
        filteredContacts = contacts;
        toggleForm();
      });
    } else {
      setState(() {
        contacts.add(
          Contact(
            name: name,
            surname: surname,
            phoneNumber: phoneNumber,
          ),
        );
        filteredContacts = contacts;
        toggleForm();
      });
    }
  }

  void editContact(int index) {
    setState(() {
      isEditing = true;
      editingIndex = index;
      Contact contact = contacts[index];
      nameController.text = contact.name;
      surnameController.text = contact.surname;
      phoneNumberController.text = contact.phoneNumber;
      toggleForm();
    });
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
      filteredContacts = contacts;
    });
  }

  void searchContacts(String keyword) {
    setState(() {
      filteredContacts = contacts.where((contact) {
        final name = contact.name.toLowerCase();
        final surname = contact.surname.toLowerCase();
        final searchLower = keyword.toLowerCase();

        return name.contains(searchLower) || surname.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kişiler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GestureDetector(
        onTap: () {
          if (showForm) {
            toggleForm();
          }
          FocusManager.instance.primaryFocus?.unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Kişiler'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    searchContacts(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    enabled: true,
                    suffixIcon: searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              searchController.clear();
                              searchContacts('');
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                          )
                        : null,
                    hintText: 'Kişi ara...',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: filteredContacts.length,
            itemBuilder: (context, index) {
              return ListTile(
                key: Key(filteredContacts[index].phoneNumber),
                title: Text(
                  '${filteredContacts[index].name} ${filteredContacts[index].surname}',
                ),
                subtitle: Text(filteredContacts[index].phoneNumber),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => editContact(index),
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => deleteContact(index),
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: toggleForm,
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomSheet: showForm ? buildAddContactForm() : null,
        ),
      ),
    );
  }

  Widget buildAddContactForm() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEditing ? 'Kişiyi Düzenle' : 'Kişiyi Ekle',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Ad',
            ),
          ),
          TextField(
            controller: surnameController,
            decoration: InputDecoration(
              labelText: 'Soyad',
            ),
          ),
          TextField(
            controller: phoneNumberController,
            decoration: InputDecoration(
              labelText: 'Telefon Numarası',
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: addContact,
                child: Text(isEditing ? 'Güncelle' : 'Ekle'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: toggleForm,
                child: Text('İptal'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
