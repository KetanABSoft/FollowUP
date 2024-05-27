import 'package:followup/controller/add_task_controller.dart';
import 'package:followup/controller/create_lead_controller.dart';
import 'package:followup/controller/lead_list_controller.dart';
import 'package:followup/controller/task_incompleted_controller.dart';
import 'package:followup/controller/task_recieve_controller.dart';
import 'package:followup/controller/task_send_controller.dart';
import 'package:followup/controller/test_controller.dart';
import 'package:followup/controller/view_notification_controller.dart';
import 'package:followup/controller/view_task_controller.dart';
import 'package:get/get.dart';
import '../controller/edit_recorder_controller.dart';
import '../controller/edit_task_controller.dart';
import '../controller/list_all_controller.dart';
import '../controller/notification_screen_controller.dart';
import '../controller/notification_service_controller.dart';
import '../controller/overdue_task_controller.dart';
import '../controller/page_transition_controller.dart';
import '../controller/profile_controller.dart';
import '../controller/recorder_controller.dart';
import '../controller/remark_controller.dart';
import '../controller/task_completed_controller.dart';

class AddTaskBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => AddTaskController());
  }
}

class CreateLeadBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => CreteLeadController());
  }
}

class DashBoardBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => DashBoardBinding());
  }
}

class EditRecorderBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => EditRecorderController());
  }
}

class EditTaskBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => EditTaskController());
  }
}

class LeadListBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => LeadListController());
  }
}

class ListAllBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => ListAllController());
  }
}

class LoginBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => LoginBinding());
  }
}

class NotificationServiceBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => NotificationServiceController());
  }
}

class NotificationScreenBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => NotificationScreenController());
  }
}

class OverdueTaskBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => OverdueTaskController());
  }
}

class PageTransitionBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => PageTransitionController());
  }
}

class ProfileBinding extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}

class RecorderBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => RecorderController());
  }
}

class RemarkBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => RemarkController());
  }
}

class TaskCompletedBinding extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut(() => TaskCompletedController());
  }
}

class TaskInCompletedBinding extends Bindings
{
  @override
  void dependencies() {
  Get.lazyPut(() => TaskInCompletedController());
  }
}

class TaskRecieveBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => TaskRecieveController());
  }
}

class TaskSendBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => TaskSendController());
  }
}

class TestBindings extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut(() => TestController());
  }
}

class ViewNotificationBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => ViewNotificationController());
  }
}

class ViewTaskBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => ViewTaskController());
  }
}