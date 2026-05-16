import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/core/routes/shell_/shell_requirement_model.dart';

Map<String, ShellRequirementModel> shellConfigRoute = {
  customerHomePagePath: ShellRequirementModel(
    title: '',
    showBottomNavigationBar: true,
    showFloatingButton: false,
  ),
  customerProfilePagePath: ShellRequirementModel(
    title: '',
    showBottomNavigationBar: true,
    showFloatingButton: false,
  ),
  customerRequestsPagePath: ShellRequirementModel(
    title: '',
    showBottomNavigationBar: true,
    showFloatingButton: false,
  ),
  technicianHomePagePath: ShellRequirementModel(
    title: '',
    showBottomNavigationBar: true,
    showFloatingButton: false,
  ),
  taskPagePath: ShellRequirementModel(
    title: '',
    showBottomNavigationBar: true,
    showFloatingButton: false,
  ),
  taskDetailPath: ShellRequirementModel(
    title: 'Task Detail',
    showBottomNavigationBar: false,
    showFloatingButton: false,
    isMain: false,
  ),
  schedulePagePath: ShellRequirementModel(
    title: '',
    showBottomNavigationBar: true,
    showFloatingButton: false,
  ),
  profilePagePath: ShellRequirementModel(
    title: '',
    showBottomNavigationBar: true,
    showFloatingButton: true,
  ),
};
