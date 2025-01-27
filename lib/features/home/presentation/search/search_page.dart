import 'dart:async';

import 'package:craft_silicon/common/helpers/sizes.dart';
import 'package:craft_silicon/features/home/model/cities_models.dart';
import 'package:craft_silicon/features/home/repositories/current_location_provider.dart';
import 'package:craft_silicon/features/home/repositories/search_locations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _searchController = useTextEditingController();
    final _debouncer = useMemoized(() => Debouncer());

    final autoComplete = ref.watch(searchLocationStateProvider);

    final searchLoader = ref.watch(searchLocationLoaderProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Search Page'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[200]!, Colors.blue[700]!],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.appCustomSize(8.0),
              AppSizes.appCustomSize(120.0),
              AppSizes.appCustomSize(8.0),
              0,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _searchController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _debouncer.run(() {
                            ref
                                .read(searchLocationStateProvider.notifier)
                                .getSuggestions(text: value);
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 20),
                    searchLoader
                        ? LinearProgressIndicator()
                        : autoComplete.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: autoComplete.length,
                                itemBuilder: (context, index) {
                                  CitiesDataModel result = autoComplete[index];
                                  return ListTile(
                                    onTap: () {
                                      ref
                                          .read(currentLocationStateProvider
                                              .notifier)
                                          .updateLocationCoordinates(
                                            lat: result.lat,
                                            long: result.lon,
                                          );

                                      Navigator.pop(context);
                                    },
                                    title: Text(result.name!),
                                  );
                                },
                              )
                            : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
