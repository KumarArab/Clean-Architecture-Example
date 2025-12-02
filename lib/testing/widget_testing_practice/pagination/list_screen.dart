import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/list_bloc.dart';
import 'item.dart';

class ListScreen extends StatefulWidget {
  static const routeName = '/list';
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController();
    context.read<ListBloc>().add(LoadInitial());
  }

  void _onScroll() {
    final bloc = context.read<ListBloc>();
    if (_scrollController.position.extentAfter < 200 &&
        bloc.state.hasMore &&
        !bloc.state.isLoadingMore) {
      bloc.add(LoadNextPage());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildItem(Item item) {
    return ListTile(
      key: Key('item_${item.id}'),
      title: Text(item.title),
      subtitle: Text(item.subtitle),
      onTap: () =>
          Navigator.of(context).pushNamed('/detail', arguments: item.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: const Key('searchField'),
              controller: _searchController,
              decoration: const InputDecoration(hintText: 'Search'),
              onChanged: (v) => context.read<ListBloc>().add(QueryChanged(v)),
            ),
          ),
          Expanded(child: BlocBuilder<ListBloc, ListState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                    key: Key('loading'), child: CircularProgressIndicator());
              }
              if (state.errorMessage != null &&
                  (state.items == null || state.items!.isEmpty)) {
                return Center(
                  key: const Key('error'),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: ${state.errorMessage}'),
                      ElevatedButton(
                          onPressed: () =>
                              context.read<ListBloc>().add(LoadInitial()),
                          child: const Text('Retry'),
                          key: const Key('retryButton')),
                    ],
                  ),
                );
              }
              if (state.items == null || state.items!.isEmpty) {
                return const Center(key: Key('empty'), child: Text('No items'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ListBloc>().add(RefreshList());
                },
                child: ListView.builder(
                  key: const Key('listView'),
                  controller: _scrollController,
                  itemCount: state.items!.length +
                      (state.isLoadingMore || state.loadMoreError != null
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (index < state.items!.length) {
                      final item = state.items![index];
                      return _buildItem(item);
                    } else {
                      if (state.isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                              key: Key('loadingMore'),
                              child: CircularProgressIndicator()),
                        );
                      } else if (state.loadMoreError != null) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: ElevatedButton(
                              key: const Key('retryMoreButton'),
                              onPressed: () =>
                                  context.read<ListBloc>().add(LoadNextPage()),
                              child: const Text('Retry'),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }
                  },
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
