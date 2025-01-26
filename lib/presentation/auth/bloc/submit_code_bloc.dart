import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitCodeBloc extends Cubit<SubmitCodeState>{
  SubmitCodeBloc(): super(SubmitCodeInitialState());
}


abstract class SubmitCodeState{}

class SubmitCodeInitialState extends SubmitCodeState{}

class SubmitCodeSuccess extends SubmitCodeState{}

class SubmitCodeFailed extends SubmitCodeState{}