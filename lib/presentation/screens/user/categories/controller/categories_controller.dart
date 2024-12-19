import 'package:get/get.dart';
import 'package:podcast/model/route/audio_player_model.dart';

class CategoriesController extends GetxController{

  final List<String> subcategories = [
    'Subcategory 1',
    'Subcategory 2',
    'Subcategory Music',
    'Subcategory 4',
    'Subcategory Naomi',
    'Subcategory 6',
    'Subcategory 7',
    'Subcategory 8',
    'Subcategory 9',
    'Subcategory 10',
    'Subcategory 65',
    'Subcategory 746',
    'Subcategory 76',
    'Subcategory 856',
    'Subcategory 67',
  ];

  var selectedCategory = Rxn<String>("Subcategory 1");
  var isExpanded = false.obs;

  List<AudioPlayerModel> newItem = [
  ];
}