import 'package:couples_client_app/models/temp_couple.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCodeBloc extends Cubit<CreateCodeState>{
  CreateCodeBloc():super(CreateCodeCheckingState());

  void checkExistingCode()async{
    await Future.delayed(Duration(seconds: 1));
    emit(CreateCodeExistsState(TempCouple("12345", DateTime.now())));
  }
}


abstract class CreateCodeState{}

class CreateCodeCheckingState extends CreateCodeState{}

class CreateCodeExistsState extends CreateCodeState{
  final TempCouple tempCouple;
  CreateCodeExistsState(this.tempCouple);
}

class CreateCodeNotExistsState extends CreateCodeState{}