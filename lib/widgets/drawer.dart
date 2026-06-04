import 'package:flutter/material.dart';

class Drawers extends StatefulWidget {
  const Drawers({super.key});

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        UserAccountsDrawerHeader(
            accountName: Text('Guest'),
            accountEmail: Text('Email@email.com'))
      ],
    );
  }
}
