import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgeWeightWidget extends StatefulWidget {
  final Function(int) onChange;
  final String title;
  final int initValue;
  final int min;
  final int max;

  const AgeWeightWidget(
      {super.key,
      required this.onChange,
      required this.title,
      required this.initValue,
      required this.min,
      required this.max});

  @override
  State<AgeWeightWidget> createState() => _AgeWeightWidgetState();
}

class _AgeWeightWidgetState extends State<AgeWeightWidget> {
  final TextEditingController _controller = TextEditingController();
  int counter = 0;

  // void _validateInput(String value) {
  //   final intValue = int.tryParse(value);
  //   if (intValue == null || intValue < widget.min || intValue > widget.max) {
  //     setState(() {
  //       counter = widget.initValue;
  //       _controller.text = widget.initValue.toString();
  //     });
  //   } else {
  //     setState(() {
  //       counter = intValue;
  //     });
  //     widget.onChange(counter);
  //   }
  // }
  void _onFieldChanged(String value) {
    final intValue = int.tryParse(value) ?? widget.initValue;
    setState(() {
      counter = intValue;
    });
    widget.onChange(counter);
  }

  @override
  void initState() {
    super.initState();
    counter = widget.initValue;
    _controller.text = counter.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
            elevation: 12,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(children: [
              const SizedBox(
                height: 6,
              ),
              Text(
                widget.title,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // decrease
                    InkWell(
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.remove, color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          if (counter > widget.min) {
                            counter--;
                            _controller.text = counter.toString();
                          }
                        });
                        widget.onChange(counter);
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    ),

                    SizedBox(
                      width: 50,
                      height: 50,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _controller,
                        onChanged: _onFieldChanged,
                        // onChanged: (value) {
                        //   setState(() {
                        //     counter = widget.initValue;
                        //     _controller.text = widget.initValue.toString();
                        //     widget.onChange(counter);
                        //   });
                        // },
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),

                    const SizedBox(
                      width: 15,
                    ),

                    // increase
                    InkWell(
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          if (counter < widget.max) {
                            counter++;
                            _controller.text = counter.toString();
                          }
                        });
                        widget.onChange(counter);
                      },
                    ),
                  ],
                ),
              )
            ])));
  }
}
