import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  String ?title;
   final GestureTapCallback ? onPressed;
   final color;
   final borderColor;
   final textColor;
   MainButton({Key? key,required this.title,required this.onPressed,required this.color,required this.borderColor,required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:48,
      width:MediaQuery.of(context).size.width/2.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16)),
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(color),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: borderColor!)
                    )
                )
            ),
          child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(title!,style: TextStyle(color: textColor,fontSize: 17),)
          ),
          onPressed: onPressed,

        ),
    );
  }
}
