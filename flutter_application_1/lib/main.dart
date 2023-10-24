import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/auth_bloc_bloc.dart';
import 'package:flutter_application_1/profile_info_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final usernameContoller = TextEditingController();
  late AuthBlocBloc authBloc;


  @override
  void initState() {
    authBloc = AuthBlocBloc();
    super.initState();
  }

  void dispose() {
    usernameContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("AppBar"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              buildAuthBlocListener(),
              buildTextFormFiled(),
              buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAuthBlocListener() {
    return BlocConsumer(
      bloc: authBloc,
      listener: (context, state) {
        if (state is LoadedAuthState) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileInfoPage()));
        }
        if (state is FailureLoginState) {
          showError(context);
        }
      },
      builder: (context, state) {
        if (state is LoadingAuthState) {
          return Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              color: Colors.black.withOpacity(0.2),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget buildTextFormFiled() {
    return TextField(
      controller: usernameContoller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(Icons.login_rounded),
        hintText: "Введите логин",
      ),
    );
  }

  Widget buildButton() {
    return OutlinedButton(
      onPressed: () {
        String username = usernameContoller.text;
        authBloc.add(GetAuthEvent(username));
      },
      child: const Text("Submit"),
    );
  }

  Future<void> showError(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Error"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new OutlinedButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
