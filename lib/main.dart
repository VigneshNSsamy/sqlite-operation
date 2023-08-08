import 'package:add_details/screens/addUser.dart';
import 'package:add_details/model/user.dart';
import 'package:add_details/screens/viewUser.dart';
import 'package:add_details/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:add_details/screens/edituser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHome(),
    );
  }
}


class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late List<User> _userList;
  final _userservice = UserService();
  getUserDetails() async{
    var users= await _userservice.readAllUsers();
    _userList=<User>[];
    users.forEach((user){
      setState(() {
        var userModel=User();
        userModel.id=user['id'];
        userModel.name=user['name'];
        userModel.contact=user['contact'];
        userModel.description=user['description'];
        _userList.add(userModel);
      });
    }

    );
  }
  @override
  void initState() {
    getUserDetails();
    super.initState();
  }
  _showSuccessSnackBar(String message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        )
    );
  }
  _deleteFromDialog(BuildContext context,userID){
    return showDialog(context: context, builder: (param){
      return AlertDialog(
        title: Text('Wanna Delete?'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.redAccent
              ),
              onPressed: () async {
                var resultD= await _userservice.deleteUser(userID);
                if(resultD!=null){
                  Navigator.pop(context);
                  getUserDetails();
                  _showSuccessSnackBar('Deleted Successfully...');
                }
              },
              child: Text('YES'),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.green
              ),
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('NO'),),
          )
        ],
      );
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text('Student Details'),
        centerTitle: true,
        //surfaceTintColor: Colors.indigo,
      ),
      body: ListView.builder(
          itemCount: _userList.length,
          itemBuilder: (context,index){
            return Card(
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>ViewUser(user: _userList[index],)
                  ));
                },
                title: Text(_userList[index].name ?? '',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                subtitle: Text(_userList[index].contact ?? ''),
                leading: Icon(Icons.person_sharp),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>EditUser(user: _userList[index],)
                      )).then((data) => {
                        if(data!=null){
                          getUserDetails(),
                          _showSuccessSnackBar('Updated Successfully...'),
                        }
                      });
                    },
                      icon: Icon(Icons.edit),color: Colors.teal,),
                    IconButton(onPressed: (){
                      _deleteFromDialog(context,_userList[index].id);
                    },
                      icon: Icon(Icons.delete),color: Colors.red,)
                  ],
                ),
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_box,size: 30,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=> AddUser()
          )).then((data) => {
            if(data!=null){
              getUserDetails(),
              _showSuccessSnackBar('User Details Added.'),
            }
          });
        },
      ),
    );
  }
}
