import 'package:advicer/2_application/core/services/theme_service.dart';
import 'package:advicer/2_application/pages/columnDisplay/bloc/column_display_bloc.dart';
import 'package:advicer/2_application/pages/columnDisplay/widgets/custom_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ColumnDisplayPageWrapperProvider extends StatelessWidget {
  const ColumnDisplayPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ColumnDisplayBloc();
        bloc.add(ColumnDisplayRequestEvent()); // <-- Only triggers once
        return bloc;
      },
      child: const ColumnDisplayPage(),
    );
  }
}

class ColumnDisplayPage extends StatelessWidget {
  const ColumnDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Column Display',
          style: themeData.textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          Switch(
              value: Provider.of<ThemeService>(context).isDarkModeOn,
              onChanged: (_) {
                Provider.of<ThemeService>(context, listen: false).toggleTheme();
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(child: BlocBuilder<ColumnDisplayBloc, ColumnDisplayState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case ColumnDisplayInitial:
                return const Text(
                  'Initial State',
                  style: TextStyle(fontSize: 24),
                );
              case ColumnDisplayLoading:
                return const CircularProgressIndicator();
              case ColumnDisplayLoaded:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemCount: (state as ColumnDisplayLoaded).data.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return CustomItem(
                        title: state.data[index].key,
                        isChecked: state.data[index].value,
                      );
                    },
                  ),
                );
              case ColumnDisplayError:
                return const Text(
                  'Error Loading Data',
                  style: TextStyle(fontSize: 24),
                );
              default:
                return const Text(
                  'Error Loading Data',
                  style: TextStyle(fontSize: 24),
                );
            }
          },
        )),
      ),
    );
  }
}
