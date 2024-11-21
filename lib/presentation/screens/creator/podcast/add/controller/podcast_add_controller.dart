import 'package:get/get.dart';

class PodcastAddController extends GetxController{
  // Data source for dropdowns
  final Map<String, List<String>> dropdownData = {
    'Genres Podcast': ['National Baptist Convention of America International', 'Church of God in Christ (COGIC)', 'Nondenominational'],
    'Classical Audio': ['Progressive National Baptist Convention', 'Pentecostal', 'Catholic'],
    'Millennial Podcast': ['Pop Culture Deep Dives', 'Career & Side Hustles', 'Catholic'],
  };

  var selectedCategory = Rxn<String>();
  var selectedItem = Rxn<String>();

  List<String> get items => selectedCategory.value != null ? dropdownData[selectedCategory.value] ?? [] : [];
}
