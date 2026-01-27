import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/providers/hadith/hadith_provider.dart';
import 'package:share_plus/share_plus.dart';

class HadisView extends ConsumerWidget {
  const HadisView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hadithProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Daily Hadith (Bukhari)',
          style: CustomTheme.textTheme(context).bodyLarge?.copyWith(
            fontSize: screenHeight * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: Colors.black,
            size: screenHeight * 0.03,
          ),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: state.isLoading
          ? Center(
              child: CircularProgressIndicator(color: CustomTheme.primaryColor),
            )
          : state.errorMessage != null
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: screenHeight * 0.018,
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(screenWidth * 0.05),
              itemCount: state.hadiths.length,
              itemBuilder: (context, index) {
                final hadith = state.hadiths[index];
                return Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            decoration: BoxDecoration(
                              color: CustomTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: CustomTheme.primaryColor,
                              size: screenHeight * 0.025,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: Text(
                              'Hadith #${hadith.number}',
                              style: TextStyle(
                                color: CustomTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * 0.018,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        hadith.text,
                        style: TextStyle(
                          fontSize: screenHeight * 0.018,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Divider(color: Colors.grey.shade100),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            hadith.source,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: screenHeight * 0.014,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Share.share(
                                '${hadith.text}\n\n${hadith.source} - Hadith #${hadith.number}\n\nShared via Ramadan App',
                              );
                            },
                            icon: Icon(
                              Icons.share_rounded,
                              color: Colors.grey.shade400,
                              size: screenHeight * 0.022,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
