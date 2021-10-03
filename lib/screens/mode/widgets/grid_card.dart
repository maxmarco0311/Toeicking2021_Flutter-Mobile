import 'package:flutter/material.dart';

class GridCard extends StatelessWidget {
  final String imageSrc;
  final String title;
  final Function press;
  const GridCard({
    Key key,
    @required this.imageSrc,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 螢幕size
    var size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 將container()裁切，這樣Inkwell()點按時，效果才不會超出Container()的範圍
        // 因為Container是圓角(BorderRadius.circular(13))
        return ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Container(
            // 要設寬度，並且和InkWell()的寬度
            width: (constraints.maxWidth / 2) - 10,
            // padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              // 陰影
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 17),
                  blurRadius: 17,
                  spreadRadius: -23,
                  color: Color(0xFFE6E6E6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: press,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: (constraints.maxWidth / 2) - 10,
                    height: 1.7 * (size.height / 10),
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        // 圖片要外包一個有固定長度的SizedBox()，才會避免OverFlow的問題
                        SizedBox(
                          height: 1.3 * (size.height / 10),
                          child: Image.asset(
                            imageSrc,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Spacer(),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
