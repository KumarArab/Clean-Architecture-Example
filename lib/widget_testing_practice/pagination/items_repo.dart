import 'item.dart';
import 'page.dart';

abstract class ItemRepository {
  /// page is 1-based
  Future<Page<Item>> fetchItems(
      {required int page, required int pageSize, String? query});
}
