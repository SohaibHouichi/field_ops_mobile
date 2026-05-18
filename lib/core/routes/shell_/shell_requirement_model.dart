
class ShellRequirementModel {
  String title;
  bool showFloatingButton;
  bool showBottomNavigationBar;
  bool isMain;
  bool isAssetTab;
  ShellRequirementModel({
    required this.title ,
    required this.showBottomNavigationBar,
    required this.showFloatingButton,
    this.isMain = true,
    this.isAssetTab = false
  });
}