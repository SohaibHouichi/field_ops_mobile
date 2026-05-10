import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  bool isAvailable = false; // get it from db //same same we do post ...
  int taskCountPerDay = 8 ; //get from db
  int currentProjects = 2 ; //get from db

  void toggle (bool value) {
    isAvailable = value;
    // call repository to do post 
    emit(HomeInitial());
  }




}
