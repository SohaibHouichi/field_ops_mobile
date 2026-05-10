
class ShellRequirementModel {
  String title;
  bool showFloatingButton;
  bool showBottomNavigationBar;
  bool isMain;
  ShellRequirementModel({
    required this.title ,
    required this.showBottomNavigationBar,
    required this.showFloatingButton,
    this.isMain = true
  });
}