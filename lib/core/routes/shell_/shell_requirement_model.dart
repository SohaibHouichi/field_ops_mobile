
class ShellRequirementModel {
  String title;
  bool showFloatingButton;
  bool showBottomNavigationBar;
  bool isMain;
  bool isAssetTab;
  bool isRequestTap;
  ShellRequirementModel({
    required this.title ,
    required this.showBottomNavigationBar,
    required this.showFloatingButton,
    this.isMain = true,
    this.isAssetTab = false,
    this.isRequestTap = false
  });
}