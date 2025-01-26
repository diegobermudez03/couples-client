import 'package:flutter/foundation.dart';

String getAsset(String asset){
  return kIsWeb ? asset : 'assets/$asset';
}