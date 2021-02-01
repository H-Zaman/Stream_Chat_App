import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';

class IsScreenLoading extends StatelessWidget {

  final bool screenLoading;
  final Widget child;
  IsScreenLoading({@required this.screenLoading, @required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: LoadingOverlay(
        isLoading: screenLoading,
        progressIndicator: SpinKitDualRing(
          color: Color(0xff50C3E9),
        ),
        color: Colors.grey,
        child: WillPopScope(
            onWillPop: () async => screenLoading ? false : true,
            child: child
        ),
      ),
    );
  }
}