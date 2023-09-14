import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final List<String> routes;

  NavBar({required this.routes});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade200,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < routes.length; i++)
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/${routes[i]}');
                },
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: Image.asset('assets/images/${routes[i]}.png'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
