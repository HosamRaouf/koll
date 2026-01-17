// import 'package:rive/rive.dart' as rive;
//
//
// class DropDownMenu {
// static  rive.SMITrigger? on;
// static  rive.SMITrigger? off;
//
//   static void onRiveInit(rive.Artboard artboard) {
//     final controller = rive.StateMachineController.fromArtboard(artboard, 'State Machine 1');
//     artboard.addController(controller!);
//     on = controller.findInput<bool>('open') as rive.SMITrigger;
//     off = controller.findInput<bool>('close') as rive.SMITrigger;
//   }
//
//   static void onAnimation() => on?.fire();
//   static void offAnimation() => off?.fire();
// }
