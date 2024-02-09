import 'package:amoremio/Screen/CreateStory/SelectVideoTypes/SelectVideoType.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../SelectVideoTypes/trimvideo.dart';
import 'PaidStory.dart';
import 'package:get/get.dart';
import 'PaidStoryDetails.dart';
import 'PaidStoryController.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:amoremio/Widgets/Text.dart';
import 'package:amoremio/Widgets/large_Button.dart';
import 'package:amoremio/Resources/colors/colors.dart';
import '../../ExplorePages/ExploreBackgroundContainer.dart';

enum MediaSource { image, video }

enum Source { camera, gallery }

class PaidStories extends StatelessWidget {
  PaidStories({super.key});

  // final PaidStoryController controller = Get.put(PaidStoryController());

  // Future<void> videoPick() async {
  //   final picker = ImagePicker();
  //   final videoFile = await picker.pickVideo(
  //     source: ImageSource.gallery,
  //     maxDuration: const Duration(seconds: 30),
  //   );
  //   if (videoFile != null) {
  //     Get.to(
  //       () => SelectVideoType(
  //         videoFile: File(videoFile.path),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExploreContainer(
        child: Column(
          children: [
            PaidStory(
              height: MediaQuery.of(context).size.height * 0.62,
              onTap: () {
                Get.to(
                  () => const PaidStoryDetails(),
                  transition: Transition.native,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
            LargeButton(
              text: "Create Story",
              onTap: () {
                _showBottomSheet();
              },
              containerColor: AppColor.whiteColor,
              gradientColor1: AppColor.whiteColor,
              gradientColor2: AppColor.whiteColor,
              borderColor: AppColor.whiteColor,
              textColor: AppColor.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    Get.bottomSheet(
      FadeIn(
        duration: const Duration(milliseconds: 600),
        animate: true,
        child: Container(
          height: Get.height * 0.25,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: ListTile(
                  title: MyText(
                    text: "Create",
                    fontSize: 18,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // controller.imagePick();
                  _showMediaSourceSelectionDialog(MediaSource.image);
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 15.0, bottom: 25, top: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: AppColor.blackColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MyText(
                        text: "Upload an Image",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.blackColor,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showMediaSourceSelectionDialog(MediaSource.video);
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: 15.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.video_settings_outlined,
                        color: AppColor.blackColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MyText(
                        text: "Upload a Video",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.blackColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showMediaSourceSelectionDialog(MediaSource mediaSource) {
    // Close the bottom sheet
    Get.back();

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(mediaSource == MediaSource.image
              ? 'Upload Image'
              : 'Upload Video'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Get.back(); // Close the dialog
                _pickMedia(mediaSource, Source.camera);
              },
              child: const Text('Use Camera'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Get.back(); // Close the dialog
                _pickMedia(mediaSource, Source.gallery);
              },
              child: const Text('Choose from Gallery'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickMedia(MediaSource mediaSource, Source source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile;

    if (mediaSource == MediaSource.image) {
      pickedFile = await _picker.pickImage(
        source:
            source == Source.camera ? ImageSource.camera : ImageSource.gallery,
      );
    } else if (mediaSource == MediaSource.video) {
      pickedFile = await _picker.pickVideo(
        source:
            source == Source.camera ? ImageSource.camera : ImageSource.gallery,
      );
    }

    if (pickedFile != null && mediaSource == MediaSource.image) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: AppColor.redColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        print("You selected a file: ${croppedFile.path}");
        Get.to(
          () => SelectVideoType(
              fileType: File(croppedFile!.path), sourceType: 'Image'),
        );
      }

      // Handle the file, upload it or use it in your app
    } else if (pickedFile != null && mediaSource == MediaSource.video) {
      print("You selected a file: ${pickedFile.path}");
      Get.to(
        () => Trimvideo(
          videoFile: File(pickedFile!.path),
        ),
      );
    } else {
      // User canceled the picker
      print("No file selected.");
    }
  }
}
