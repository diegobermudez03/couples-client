import 'package:flutter_bloc/flutter_bloc.dart';

class QuizzesHomepageBloc extends Cubit<QuizHPageState>{
  QuizzesHomepageBloc():super(QuizHPageInitialState());

  void fetchInitialPage()async{

  }
}


abstract class QuizHPageState{}

class QuizHPageInitialState extends QuizHPageState{}