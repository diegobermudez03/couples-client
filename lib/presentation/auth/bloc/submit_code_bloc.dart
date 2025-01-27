import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitCodeBloc extends Cubit<SubmitCodeState>{
  SubmitCodeBloc(): super(SubmitCodeInitialState());

  void submitCode(String code) async{
    print("submited");
    emit(SubmitCodeLoading());
    await Future.delayed(Duration(seconds: 1));
    emit(SubmitCodeSuccess());
  }
}


abstract class SubmitCodeState{}

class SubmitCodeInitialState extends SubmitCodeState{}

class SubmitCodeSuccess extends SubmitCodeState{}

class SubmitCodeLoading extends SubmitCodeState{}

class SubmitCodeFailed extends SubmitCodeState{}

enum SubmitCodeErrorMessage{
  generalError
}