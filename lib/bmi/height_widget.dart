import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HeightWidget extends StatefulWidget {
  final Function(int) onChange;

  const HeightWidget({
    super.key,
    required this.onChange,
  });

  @override
  State<HeightWidget> createState() => _HeightWidgetState();
}

class _HeightWidgetState extends State<HeightWidget> {
  int _height = 160;
  TextEditingController _heightcon = TextEditingController();

  void _validateHeight(String value) {
    final intValue = int.tryParse(value);
    if (value.isEmpty || intValue == null || intValue > 260) {
      setState(() {
        _height = 160;
        _heightcon.text = '160';
      });
    } else {
      setState(() {
        _height = intValue;
      });
    }
    widget.onChange(_height);
  }

  @override
  void initState() {
    super.initState();
    _heightcon = TextEditingController(text: _height.toInt().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
      child: Card(
          elevation: 12,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              const Text(
                "Height",
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // height value
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _heightcon,
                      onChanged: (value) {
                        _validateHeight(value);
                      },
                      onEditingComplete: () {
                        _validateHeight(_heightcon.text);
                        FocusScope.of(context).unfocus();
                      },
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "cm",
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                ],
              ),
              Slider(
                min: 0,
                max: 260,
                value: _height.toDouble(),
                thumbColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    _height = value.toInt();
                    _heightcon.text = _height.toString();
                  });
                  widget.onChange(_height);
                },
              )
            ],
          )),
    );
  }
}
