import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../utils/shared_prefs.dart';
import '../widgets/home_widgets.dart';
import '../widgets/loading_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeWidgets homeWidgets = HomeWidgets();

  // Fungsi untuk memuat ulang data
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    await SharedPrefs.getUserData();
    await SharedPrefs.getKakeiboResults();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(400),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: AppBar(
            backgroundColor: AppColors.primaryColor,
            automaticallyImplyLeading: false,
            flexibleSpace: FutureBuilder<UserModel?>(
              future: SharedPrefs.getUserData(),
              builder: (context, snapshotUser) {
                if (snapshotUser.connectionState == ConnectionState.waiting) {
                  return const LoadingOverlay(
                    isLoading: true,
                    child: SizedBox.shrink(),
                  );
                } else if (snapshotUser.hasError || !snapshotUser.hasData) {
                  return const Center(
                    child: Text(
                      "Gagal memuat data pengguna",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  );
                } else {
                  final user = snapshotUser.data!;
                  return FutureBuilder<Map<String, double>>(
                    future: SharedPrefs.getKakeiboResults(),
                    builder: (context, snapshotResults) {
                      if (snapshotResults.connectionState ==
                          ConnectionState.waiting) {
                        return const LoadingOverlay(
                          isLoading: true,
                          child: SizedBox.shrink(),
                        );
                      } else if (snapshotResults.hasError ||
                          !snapshotResults.hasData) {
                        return const Center(
                          child: Text(
                            "Gagal memuat data alokasi keuangan",
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                        );
                      } else {
                        final results = snapshotResults.data!;
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(26),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UserInfoWidget(),
                              const SizedBox(height: 10),
                              homeWidgets.buildFinancialSummary(),
                              const SizedBox(height: 10),
                              buildFinancialDetails(context),
                              const SizedBox(height: 10),
                              buildCategoryAllocations(results),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<Map<String, double>>(
          future: SharedPrefs.getKakeiboResults(),
          builder: (context, snapshotResults) {
            if (snapshotResults.connectionState == ConnectionState.waiting) {
              return const LoadingOverlay(
                isLoading: true,
                child: SizedBox.shrink(),
              );
            } else if (snapshotResults.hasError || !snapshotResults.hasData) {
              return const Center(
                child: Text(
                  "Gagal memuat data alokasi keuangan",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              );
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildActionButtons(context),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
