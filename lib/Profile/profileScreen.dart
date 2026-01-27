import 'dart:developer';
import 'dart:io';
import 'package:educationapp/complete/complete.page.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Controller/userProfileController.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerStatefulWidget {
  ProfilePage({
    super.key,
  });

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? selectbgImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      setState(() {
        selectbgImage = file;
      });

      await uploadImageBackground(file);
    }
  }

  void showImagePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickAndUploadImage(ImageSource.camera);
              },
              child: const Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickAndUploadImage(ImageSource.gallery);
              },
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadImageBackground(File imageFile) async {
    final dio = createDio();
    final api = APIStateNetwork(dio);

    try {
      final response = await api.uploadBackgroundImage(imageFile);
      if (response.response.data['status'] == true) {
        log("Upload Success: $response");
        Fluttertoast.showToast(msg: response.response.data['message']);
        ref.invalidate(userProfileController);
      } else {
        Fluttertoast.showToast(msg: "Upload Error");
      }
    } catch (e) {
      log("Upload Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final userType = box.get("userType");
    final userProfileAsync = ref.watch(userProfileController);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: userProfileAsync.when(
        data: (userProfile) {
          // Safely extract profile data
          final profileData = userProfile.data;

          if (profileData == null) {
            return const Center(
              child: Text(
                'No profile data available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 15.h),
                  child: Text(
                    "Profile",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 170.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                // image: selectbgImage != null
                                //     ? DecorationImage(
                                //         image: FileImage(selectbgImage!),
                                //         fit: BoxFit.cover,
                                //       )
                                //     : const DecorationImage(
                                //         image: AssetImage(
                                //             'assets/images/student_cover.png'),
                                //         fit: BoxFit.cover,
                                //       ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: selectbgImage != null
                                      ? FileImage(selectbgImage!)
                                      : (profileData.backgroundImage != null &&
                                              profileData
                                                  .backgroundImage!.isNotEmpty)
                                          ? NetworkImage(profileData
                                              .backgroundImage
                                              .toString())
                                          : const AssetImage(
                                              'assets/images/student_cover.png',
                                            ) as ImageProvider,
                                ),
                              ),

                              /// 👇 TEXT SIRF TAB DIKHE JAB DONO IMAGE NA HO
                              child: (selectbgImage == null &&
                                      (profileData.backgroundImage == null ||
                                          profileData.backgroundImage!.isEmpty))
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.school,
                                            size: 40.sp,
                                            color: Colors.grey.shade700,
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            "Add Cover Photo",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : null,
                            ),

                            /// ✏️ Edit Button
                            Positioned(
                              right: 20,
                              top: 20,
                              child: InkWell(
                                onTap: () {
                                  showImagePicker();
                                },
                                child: Container(
                                  width: 36.w,
                                  height: 36.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.edit,
                                      color: Color(0xff9088F1),
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          color: themeMode == ThemeMode.light
                              ? Color(0xFF1B1B1B)
                              : Colors.white,
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                top: 100.h, left: 20.w, right: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileData.fullName ?? "No Name",
                                  style: GoogleFonts.roboto(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                    color: themeMode == ThemeMode.dark
                                        ? Color(0xFF1B1B1B)
                                        : Colors.white,
                                  ),
                                ),
                                if (userType != "Student") ...[
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    profileData.jobRole ?? "No Job",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xff666666)
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Text(
                                    "${profileData.jobCompanyName ?? "No company"} * ${profileData.jobLocation}",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xff666666)
                                          : Colors.white,
                                    ),
                                  ),
                                ],

                                if (userType == "Student") ...[
                                  if (profileData.highestQualification !=
                                          null &&
                                      profileData
                                          .highestQualification!.isNotEmpty)
                                    Text(
                                      profileData.highestQualification ??
                                          "No qualification",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: themeMode == ThemeMode.dark
                                            ? Color(0xff666666)
                                            : Colors.white,
                                      ),
                                    ),
                                  if (profileData.collegeOrInstituteName !=
                                          null &&
                                      profileData
                                          .collegeOrInstituteName!.isNotEmpty)
                                    Text(
                                      profileData.collegeOrInstituteName ??
                                          "No college",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: themeMode == ThemeMode.dark
                                            ? Color(0xff666666)
                                            : Colors.white,
                                      ),
                                    ),
                                ],

                                SizedBox(
                                  height: 16.h,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        minimumSize: Size(400.w, 50.h),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            color: Color(0xff9088F1))),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                ProfileCompletionWidget(true),
                                          ));
                                    },
                                    child: Text(
                                      "Upgrade Profile",
                                      style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff9088F1)),
                                    )),
                                // Wrap(
                                //   spacing: 10.w,
                                //   runSpacing: 5.h,
                                //   children: (profileData.skills ?? [])
                                //       .map<Widget>((skill) => Text(
                                //             skill.toString(),
                                //             style: GoogleFonts.roboto(
                                //               fontSize: 16.sp,
                                //               fontWeight: FontWeight.w600,
                                //               color: themeMode == ThemeMode.dark
                                //                   ? Color(0xff666666)
                                //                   : Colors.white,
                                //             ),
                                //           ))
                                //       .toList(),
                                // ),
                                SizedBox(height: 20.h),
                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1.w,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      top: 10.h,
                                      bottom: 10.h,
                                      left: 10.w,
                                      right: 10.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border:
                                          Border.all(color: Color(0xff9088F1))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "About ${profileData.fullName}",
                                        style: GoogleFonts.roboto(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      if (userType != "Student")
                                        Text(
                                          "${profileData.totalExperience} Yrs Exprience of ${profileData.jobRole}.",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xff666666)
                                                : Colors.white,
                                          ),
                                        ),
                                      SizedBox(height: 3.h),
                                      if (profileData.description != null &&
                                          profileData.description!.isNotEmpty)
                                        Text(
                                          profileData.description ??
                                              "No description",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xff666666)
                                                : Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 15.h),

                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1.w,
                                ),
                                // Educations
                                Container(
                                  margin: EdgeInsets.only(top: 10.h),
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      top: 10.h,
                                      bottom: 10.h,
                                      left: 10.w,
                                      right: 10.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border:
                                          Border.all(color: Color(0xff9088F1))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Education",
                                        style: GoogleFonts.roboto(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      if (profileData.highestQualification !=
                                              null &&
                                          profileData
                                              .highestQualification!.isNotEmpty)
                                        Text(
                                          profileData.highestQualification ??
                                              "No qualification",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xff666666)
                                                : Colors.white,
                                          ),
                                        ),
                                      if (userType == "Student") ...[
                                        SizedBox(height: 5.h),
                                        if (profileData
                                                    .collegeOrInstituteName !=
                                                null &&
                                            profileData.collegeOrInstituteName!
                                                .isNotEmpty)
                                          Text(
                                            profileData
                                                    .collegeOrInstituteName ??
                                                "No",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xff666666)
                                                  : Colors.white,
                                            ),
                                          ),
                                        SizedBox(height: 5.h),
                                        if (profileData.educationYear != null &&
                                            profileData
                                                .educationYear!.isNotEmpty)
                                          Text(
                                            profileData.educationYear ?? "No",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xff666666)
                                                  : Colors.white,
                                            ),
                                          ),
                                      ]
                                    ],
                                  ),
                                ),

                                // Experience
                                if (userType != "Student") ...[
                                  SizedBox(height: 15.h),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1.w,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.h),
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        top: 10.h,
                                        bottom: 10.h,
                                        left: 10.w,
                                        right: 10.w),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        border: Border.all(
                                            color: Color(0xff9088F1))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Experience",
                                          style: GoogleFonts.roboto(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xFF1B1B1B)
                                                : Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        if (profileData.totalExperience !=
                                                null &&
                                            profileData
                                                .totalExperience!.isNotEmpty)
                                          Text(
                                            "${profileData.totalExperience ?? "No"} Year Exprience",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xff666666)
                                                  : Colors.white,
                                            ),
                                          ),
                                        if (profileData.jobRole != null &&
                                            profileData.jobRole!.isNotEmpty)
                                          Text(
                                            "${profileData.jobRole ?? "No"}",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xff666666)
                                                  : Colors.white,
                                            ),
                                          ),
                                        if (profileData.jobCompanyName !=
                                                null &&
                                            profileData
                                                .jobCompanyName!.isNotEmpty)
                                          Text(
                                            "${profileData.jobCompanyName ?? "No"}",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xff666666)
                                                  : Colors.white,
                                            ),
                                          ),
                                        if (userType == "Student") ...[
                                          SizedBox(height: 5.h),
                                          if (profileData
                                                      .collegeOrInstituteName !=
                                                  null &&
                                              profileData
                                                  .collegeOrInstituteName!
                                                  .isNotEmpty)
                                            Text(
                                              profileData
                                                      .collegeOrInstituteName ??
                                                  "No",
                                              style: GoogleFonts.roboto(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xff666666)
                                                        : Colors.white,
                                              ),
                                            ),
                                          SizedBox(height: 5.h),
                                          if (profileData.educationYear !=
                                                  null &&
                                              profileData
                                                  .educationYear!.isNotEmpty)
                                            Text(
                                              profileData.educationYear ?? "No",
                                              style: GoogleFonts.roboto(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xff666666)
                                                        : Colors.white,
                                              ),
                                            ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ],
                                SizedBox(height: 15.h),

                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1.w,
                                ),
                                // Skills
                                Container(
                                  margin: EdgeInsets.only(top: 10.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Skills",
                                        style: GoogleFonts.roboto(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      if (profileData.skills != null &&
                                          profileData.skills!.isNotEmpty)
                                        Wrap(
                                          spacing: 10.w,
                                          runSpacing: 5.h,
                                          children: profileData.skills!
                                              .map<Widget>((skill) => Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 8.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      color: const Color(
                                                          0xffDEDDEC),
                                                    ),
                                                    child: Text(
                                                      skill.toString(),
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      else
                                        Text(
                                          'No skills listed',
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: themeMode == ThemeMode.dark
                                                ? Colors.black26
                                                : Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1.w,
                                ),

                                // Language
                                _buildLanguageSection(
                                  title: "Languages",
                                  languageString: profileData.languageKnown,
                                  themeMode: themeMode,
                                ),
                                // Divider(
                                //   color: Colors.grey.shade400,
                                //   thickness: 1.w,
                                // ),
                                // // Links
                                // _buildInfoSection(
                                //   title: "Github/Drive/Behance/LinkedIn",
                                //   value: profileData.linkedinUser ??
                                //       "Not provided",
                                //   themeMode: themeMode,
                                // ),
                                // Divider(
                                //   color: Colors.grey.shade400,
                                //   thickness: 1.w,
                                // ),
                                // // Gender
                                // _buildInfoSection(
                                //   title: "Gender",
                                //   value: profileData.gender ?? "Not specified",
                                //   themeMode: themeMode,
                                // ),
                                // Divider(
                                //   color: Colors.grey.shade400,
                                //   thickness: 1.w,
                                // ),
                                // // DOB
                                // _buildInfoSection(
                                //   title: "Date of Birth",
                                //   value: profileData.dob != null
                                //       ? DateFormat('dd/MM/yyyy')
                                //           .format(profileData.dob!)
                                //       : "Not provided",
                                //   themeMode: themeMode,
                                // ),
                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1.w,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Interest",
                                        style: GoogleFonts.roboto(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      if (profileData.interest != null &&
                                          profileData.interest!.isNotEmpty)
                                        Wrap(
                                          spacing: 10.w,
                                          runSpacing: 5.h,
                                          children: profileData.interest!
                                              .map<Widget>((intr) => Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 8.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      color: const Color(
                                                          0xffDEDDEC),
                                                    ),
                                                    child: Text(
                                                      intr.toString(),
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      else
                                        Text(
                                          'No interest listed',
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: themeMode == ThemeMode.dark
                                                ? Colors.black26
                                                : Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1.w,
                                ),
                                // // Contact
                                // Text(
                                //   "Contact",
                                //   style: GoogleFonts.roboto(
                                //     fontSize: 20.sp,
                                //     fontWeight: FontWeight.w600,
                                //     color: themeMode == ThemeMode.dark
                                //         ? Color(0xFF1B1B1B)
                                //         : Colors.white,s
                                //   ),
                                // ),
                                // SizedBox(height: 10.h),
                                // Text(
                                //   "Phone: +91 ${profileData.phoneNumber ?? 'N/A'}",
                                //   style: GoogleFonts.roboto(
                                //     fontSize: 15.sp,
                                //     fontWeight: FontWeight.w600,
                                //     color: themeMode == ThemeMode.dark
                                //         ? Color(0xff666666)
                                //         : Colors.white,
                                //   ),
                                // ),
                                // Divider(
                                //   color: Colors.grey.shade400,
                                //   thickness: 1.w,
                                // ),
                                // Certificate
                                Text(
                                  "Certificate",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: themeMode == ThemeMode.dark
                                        ? Color(0xFF1B1B1B)
                                        : Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                if (profileData.certificate != null)
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: Image.network(
                                        profileData.certificate!,
                                        fit: BoxFit.cover,
                                        width: 360.w,
                                        height: 250.h,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.upload_sharp,
                                              color: Color(0xff9088F1),
                                              size: 30.sp,
                                            ),
                                            SizedBox(height: 10.h),
                                            Text("Failed to load certificate"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Center(
                                    child: Text(
                                      "No certificate uploaded",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 40.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Profile Picture
                    Positioned(
                      left: 20.w,
                      right: 0,
                      top: 100.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.black, width: 1.2)),
                            child: ClipOval(
                              child: profileData.profilePic != null
                                  ? Image.network(
                                      profileData.profilePic!,
                                      height: 141.w,
                                      width: 141.w,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;

                                        return SizedBox(
                                          height: 100.w,
                                          width: 100.w,
                                          child: CircularProgressIndicator(
                                            color: Colors.amber,
                                            strokeWidth: 1,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.network(
                                        "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                        height: 182.w,
                                        width: 182.w,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.network(
                                      "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                      height: 141.w,
                                      width: 141.w,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          log(stack.toString());
          log(error.toString());
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                ElevatedButton(
                  onPressed: () => ref.refresh(userProfileController),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper widget to avoid repeating code
  Widget _buildInfoSection({
    required String title,
    required String value,
    required ThemeMode themeMode,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: themeMode == ThemeMode.dark
                  ? Color(0xFF1B1B1B)
                  : Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: const Color(0xffDEDDEC),
            ),
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: themeMode == ThemeMode.dark
                    ? Color(0xff666666)
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLanguageSection({
  required String title,
  required String? languageString,
  required ThemeMode themeMode,
}) {
  final languages = languageString != null && languageString.isNotEmpty
      ? languageString.split(',').map((e) => e.trim()).toList()
      : [];

  return Padding(
    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color:
                themeMode == ThemeMode.dark ? Color(0xFF1B1B1B) : Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        languages.isNotEmpty
            ? Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: languages.map((lang) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: const Color(0xffDEDDEC),
                    ),
                    child: Text(
                      lang,
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: themeMode == ThemeMode.dark
                            ? Color(0xff666666)
                            : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              )
            : Text(
                "No language specified",
                style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.black),
              ),
      ],
    ),
  );
}
