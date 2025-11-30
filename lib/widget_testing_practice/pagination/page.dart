class Page<T> {
  final List<T> items;
  final bool hasMore;

  Page({required this.items, required this.hasMore});
}
