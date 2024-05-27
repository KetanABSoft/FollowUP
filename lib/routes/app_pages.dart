import 'package:followup/binding/app_binding.dart';
import 'package:followup/routes/route.dart';
import 'package:followup/screens/AddTask.dart';
import 'package:followup/screens/loginscreen.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../screens/EditRecorder.dart';
import '../screens/EditTask.dart';
import '../screens/Lead_list.dart';
import '../screens/ListAll.dart';
import '../screens/OverdueTask.dart';
import '../screens/Profile.dart';
import '../screens/Remark.dart';
import '../screens/TaskCompleted.dart';
import '../screens/TaskReceive.dart';
import '../screens/TaskSend.dart';
import '../screens/Taskincompleted.dart';
import '../screens/Test.dart';
import '../screens/ViewTask.dart';
import '../screens/create_lead.dart';
import '../screens/dashboard.dart';
import '../screens/login_screen.dart';
import '../screens/viewNotification.dart';

class AppPages
{
  static String INITIAL_ROUTE = Route.LOGIN_SCREEN_ROUTE;

  static final Pages =
  [
    GetPage(
        name: Route.LOGIN_SCREEN_ROUTE,
        page: () => LoginScreen(),
        binding:LoginBinding()
    ),
    GetPage(
        name: Route.ADD_TASK_ROUTE,
        page: () => AddTask(audioPath: ""),
        binding:LoginBinding()
    ),
    GetPage(
        name: Route.CREATE_LEAD_ROUTE,
        page: () => LeadForm(id: '', task: '',),
        binding:CreateLeadBinding()
    ),
    GetPage(
        name: Route.DASHBOARD_ROUTE,
        page: () => DashboardScreen(),
        binding:DashBoardBinding()
    ),
    GetPage(
        name: Route.EDIT_RECORD_ROUTE,
        page: () => EditRecord(id: '', task: '',),
        binding:EditRecorderBinding()
    ),
    GetPage(
        name: Route.EDIT_TASK_ROUTE,
        page: () => Edit(id: '', task: '', audiopath: '', backto: '',),
        binding:EditTaskBinding()
    ),
    GetPage(
        name: Route.LEAD_LIST_ROUTE,
        page: () => LeadList(),
        binding:LeadListBinding()
    ),
    GetPage(
        name: Route.LIST_ALL_ROUTE,
        page: () => DashBoard(admin_type: '',),
        binding:ListAllBinding()
    ),
    GetPage(
        name: Route.NOTIFICATION_SCREEN_ROUTE,
        page: () => DashBoard(admin_type: '',),
        binding:NotificationScreenBinding()
    ),
    GetPage(
        name: Route.OVERDUE_TASK_ROUTE,
        page: () => OverdueTask(admin_type: '',),
        binding:OverdueTaskBinding()
    ),
    GetPage(
        name: Route.PROFILE_ROUTE,
        page: () => Profile(),
        binding:ProfileBinding()
    ),
    GetPage(
        name: Route.RECORDER_ROUTE,
        page: () => MyApp(),
        binding:RecorderBinding()
    ),
    GetPage(
        name: Route.REMARK_ROUTE,
        page: () => Remark(id: '',),
        binding:RemarkBinding()
    ),
    GetPage(
        name: Route.TASK_COMPLETED_ROUTE,
        page: () => Completed(admin_type: '',),
        binding:TaskCompletedBinding()
    ),
    GetPage(
        name: Route.TASK_IN_COMPLETED_ROUTE,
        page: () => Taskincompleted(admin_type: '',),
        binding:TaskInCompletedBinding()
    ),
    GetPage(
        name: Route.TASK_RECEIEVE_ROUTE,
        page: () => Receive(admin_type: '',),
        binding:TaskRecieveBinding()
    ),
    GetPage(
        name: Route.TASK_SEND_ROUTE,
        page: () => Send(admin_type: '',),
        binding:TaskSendBinding()
    ),
    GetPage(
        name: Route.TEST_ROUTE,
        page: () => TimerPage(),
        binding:TestBindings()
    ),
    GetPage(
        name: Route.VIEW_NOTIFICATION_ROUTE,
        page: () => Viewnotification(id: '',),
        binding:ViewNotificationBinding()
    ),
    GetPage(
        name: Route.VIEW_TASK_ROUTE,
        page: () => Viewtask(id: '',),
        binding:ViewTaskBinding()
    ),
  ];
}