import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:torch_light/torch_light.dart';

class flashlight extends StatefulWidget {
  @override
  State<flashlight> createState() => _flashlightState();
}

class _flashlightState extends State<flashlight> {
  // const flashlight({super.key});
  TorchController controller = TorchController();
  bool isactive = false;
  bool IsOn = false;

  dynamic IsTorchAvailable(BuildContext context) async {
    try {
      final ispresent = await TorchLight.isTorchAvailable();
      return ispresent;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FLASHLIGHT APP',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            !isactive
                ? Image.asset(
                    'assets/images/off.png',
                    height: 400,
                  )
                : Image.asset(
                    'assets/images/on.png',
                    height: 400,
                  ),
            SizedBox(
              height: 30,
            ),
            buildswitch(),
          ],
        ),
      ),
    );
  }

  Widget buildswitch() => Transform.scale(
        scale: 3,
        child: Switch.adaptive(
          value: isactive,
          onChanged: (isactive) async {
            bool isavailable = await IsTorchAvailable(context);

            if (isavailable == true) {
              IsOn = !IsOn;

              if (IsOn) {
                try {
                  await TorchLight.enableTorch();
                  setState(() {
                    this.isactive = isactive;
                  });
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
                  IsOn = !IsOn;
                }
              } else {
                try {
                  await TorchLight.disableTorch();
                  setState(() {
                    this.isactive = isactive;
                  });
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
                  IsOn = !IsOn;
                }
              }
            }
          },
        ),
      );
}
