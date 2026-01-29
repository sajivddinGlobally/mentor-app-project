/*
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnlineMentorPage extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> onlineMentors;
  const OnlineMentorPage({
    super.key,
    required this.onlineMentors,
  });

  @override
  ConsumerState<OnlineMentorPage> createState() => _OnlineMentorPageState();
}

class _OnlineMentorPageState extends ConsumerState<OnlineMentorPage> {
  final _searchController = TextEditingController();
  String query = "";
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final filteredMentors = widget.onlineMentors.where((mentor) {
      final name = mentor['full_name']?.toString().toLowerCase() ?? '';
      final services = mentor['service_type']?.toString().toLowerCase() ?? '';

      return name.contains(query.toLowerCase()) ||
          services.contains(query.toLowerCase());
    }).toList();
    return Scaffold(
      backgroundColor:
          // themeMode == ThemeMode.dark
          //     ? const Color(0xFF1B1B1B)
          //     :
          Color(0xff9088F1),
      appBar: AppBar(
        backgroundColor:
            // themeMode == ThemeMode.dark
            //     ? const Color(0xFF1B1B1B)
            //     :
            Color(0xff9088F1),
        title: Text(
          "Online Mentors",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(
                      left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
                  hintText: "Search mentors...",
                  hintStyle: GoogleFonts.roboto(
                      color: Colors.white70, fontSize: 18.sp),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white, size: 20),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              )),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r)),
                // color: Colors.white

                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Color(0xFF1B1B1B),
              ),
              child: filteredMentors.isEmpty
                  ? Center(
                      child: Text(
                        "No Online Mentor",
                        style: TextStyle(color: Color(0xFF1B1B1B)),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredMentors.length,
                      itemBuilder: (context, index) {
                        final item = filteredMentors[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => MentorDetailPage(
                                            id: item['id'] ?? 0,
                                          )));
                            },
                            child: UserTabs(
                              image: item['profile_pic'] ??
                                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                              id: item['id'],
                              fullname: item['full_name'] ?? "No Name",
                              dec: item['description'] ?? "N/A",
                              // servicetype: item['service_type'] == null
                              //     ? []
                              //     : item['service_type']
                              //         .toString()
                              //         .split(',')
                              //         .map((e) => e.trim())
                              //         .toList(),
                              servicetype: item['serviceType'],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}
*/

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'findmentor.page.dart';

class OnlineMentorPage extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> onlineMentors;
  const OnlineMentorPage({
    super.key,
    required this.onlineMentors,
  });

  @override
  ConsumerState<OnlineMentorPage> createState() => _OnlineMentorPageState();
}

class _OnlineMentorPageState extends ConsumerState<OnlineMentorPage> {
  final _searchController = TextEditingController();
  String query = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final filteredMentors = widget.onlineMentors.where((mentor) {
      final name = (mentor['full_name'] ?? '').toString().toLowerCase();
      final service = (mentor['service_type'] ?? '').toString().toLowerCase();
      return name.contains(query.toLowerCase()) || service.contains(query.toLowerCase());
    }).toList();

    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xffF5F5F5);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: const Color(0xff9088F1), // header / top color
      appBar: AppBar(
        backgroundColor: const Color(0xff9088F1),
        title: const Text(
          "Online Mentors",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 18.sp),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                hintText: "Search mentors...",
                hintStyle: GoogleFonts.roboto(color: Colors.white70, fontSize: 16.sp),
                filled: true,
                fillColor: Colors.white.withOpacity(0.25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Colors.white38),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 22),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              child: filteredMentors.isEmpty
                  ? Center(
                child: Text(
                  "No Online Mentors Found",
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 18.sp,
                  ),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                itemCount: filteredMentors.length,
                itemBuilder: (context, index) {
                  final mentor = filteredMentors[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => MentorDetailPage(
                              id: mentor['id'] ?? 0,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: cardColor,
                        elevation: isDark ? 2 : 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: UserTabs(
                          image: mentor['profile_pic']?.toString().isNotEmpty == true
                              ? mentor['profile_pic']
                              : "https://via.placeholder.com/150",
                          id: mentor['id'],
                          fullname: mentor['full_name']?.toString() ?? "Unknown",
                          dec: mentor['description']?.toString() ?? "No description",
                          servicetype: mentor['serviceType'] ?? mentor['service_type'],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}