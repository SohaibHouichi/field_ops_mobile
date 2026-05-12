import 'package:field_ops/core/constants/about_routing.dart';
import 'package:field_ops/layers/presentation/screens/shell_/shell_requirement_model.dart';

Map<String, ShellRequirementModel> shellConfigRoute = {
  homePagePath: ShellRequirementModel(
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
};
