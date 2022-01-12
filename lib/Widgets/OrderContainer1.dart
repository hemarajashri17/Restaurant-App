import 'package:restaurant_app/sizeConfig/sizeConfig.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'Button.dart';

class OrderContainer extends StatefulWidget {
  final String? img;
  final String? name;
  final String? price;
  final String? type;
  final String? doc_id;
  final String? count;
  final String? collectionName;
  final String? availability;
  const OrderContainer(
      {Key? key,
      this.img,
      this.name,
      this.price,
      this.type,
      this.doc_id,
      this.count,
      this.collectionName,
      this.availability})
      : super(key: key);

  @override
  _OrderContainerState createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 2),
      child: Container(
        height: SizeConfig.height! * 23,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: widget.img != "No preview"
                            ? CircleAvatar(
                                radius: SizeConfig.height! * 4.5,
                                backgroundImage: NetworkImage(widget.img!),
                              )
                            : Text(
                                "No Preview",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                      )),
                  Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.name!.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .merge(TextStyle(
                                        fontSize: SizeConfig.height! * 2.2)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "₹  " + widget.price!,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                      child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: widget.count == "0" ? Text(
                            "",
                            style: Theme.of(context).textTheme.subtitle1,
                          ) : Text(
                            widget.count!,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                    ],
                  )),

                ],
              ),
            ),
            Expanded(
              child: Divider(
                height: SizeConfig.height! * 2,
                color: Theme.of(context).buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
