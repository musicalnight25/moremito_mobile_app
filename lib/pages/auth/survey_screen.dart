import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/auth/widget/survey_shimmer_tile.dart';
import 'package:more_mitro_app/utils/app_asset.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../../controller/survey_controller.dart';
import '../../utils/common_app_bar.dart';

class SurveyScreen extends StatefulWidget {
  final bool isFromOnboarding;

  const SurveyScreen({Key? key, required this.isFromOnboarding})
      : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final controller = Get.put(SurveyController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.getSurveyQuestions(widget.isFromOnboarding),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// prevent exiting while answering
        if (controller.currentQuestionIndex.value > 0) {
          var q = controller
              .surveyQuestionsList[controller.currentQuestionIndex.value];

          bool answered = controller.selectedAnswersList
              .any((item) => item['QuestionId'] == q.questionId);

          if (!answered) {
            CommonMethod.getXSnackBar(
                "Answer Required", "Please answer first.", redColor);
            return false;
          }

          controller.currentQuestionIndex.value--;
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CommonAppBar(
          visibleBackButton: true,
        ),
        body: BaseBackgroundWidget(
          child: Obx(() {
            /// SHIMMER
            if (controller.isLoading.value) {
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 16.sp),
                itemCount: 6,
                itemBuilder: (_, __) => const SurveyShimmerTile(),
              );
            }

            /// NO DATA
            if (controller.surveyQuestionsList.isEmpty) {
              return RefreshIndicator(
                onRefresh: () =>
                    controller.getSurveyQuestions(widget.isFromOnboarding),
                color: primaryColor,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 16.sp),
                  children: const [
                    SizedBox(height: 200),
                    NoDataFound(title: "Survey"),
                  ],
                ),
              );
            }

            /// MAIN SURVEY
            return RefreshIndicator(
              onRefresh: () =>
                  controller.getSurveyQuestions(widget.isFromOnboarding),
              color: primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height20,
                  Expanded(
                    child: Obx(() {
                      var q = controller.surveyQuestionsList[
                          controller.currentQuestionIndex.value];

                      /// pick correct list
                      final options = widget.isFromOnboarding
                          ? q.answers
                          : q.allAnswerOptions;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Question
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.sp),
                            child: Text(
                              q.questionText ?? "-",
                              style: AppTextStyle.normalRegular16
                                  .copyWith(color: lightBlackColor),
                            ),
                          ),
                          height20,

                          /// Answers
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16.sp),
                              itemCount: options?.length ?? 0,
                              itemBuilder: (_, index) {
                                var element = options![index];

                                return Obx(() {
                                  bool isSelect =
                                      controller.selectedAnswersList.any(
                                    (x) =>
                                        x['QuestionId'] == q.questionId &&
                                        x['AnswerId'] == element.answerId,
                                  );

                                  return GestureDetector(
                                    onTap: () => controller.selectAnswer(
                                      q.questionId!,
                                      element.answerId!,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 12.sp),
                                      child: ShadowContainerWidget(
                                        padding: 0,
                                        blurRadius: 0,
                                        borderColor:
                                            isSelect ? primaryColor : null,
                                        widget: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.sp,
                                              vertical: 18.sp),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  element.answerText!,
                                                  style:
                                                      AppTextStyle.normalBold14,
                                                ),
                                              ),
                                              isSelect
                                                  ? SvgPicture.asset(
                                                      AppAsset.selectedCheck)
                                                  : Icon(Icons.circle_outlined,
                                                      color: lightBlackColor),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                          height20,

                          /// BUTTON
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.sp),
                            child: Obx(() {
                              bool answered =
                                  controller.selectedAnswersList.any(
                                (x) => x['QuestionId'] == q.questionId,
                              );

                              return PrimaryTextButton(
                                buttonColor:
                                    answered ? null : disableButtonColor,
                                title: controller.currentQuestionIndex.value ==
                                        controller.surveyQuestionsList.length -
                                            1
                                    ? "Submit"
                                    : "Next",
                                onPressed: () async {
                                  if (!answered) {
                                    CommonMethod.getXSnackBar("Required",
                                        "Select an answer first.", redColor);
                                    return;
                                  }

                                  if (controller.currentQuestionIndex.value <
                                      controller.surveyQuestionsList.length -
                                          1) {
                                    controller.currentQuestionIndex.value++;
                                  } else {
                                    await controller.saveSurvey(context);
                                  }
                                },
                              );
                            }),
                          ),
                          customHeight(56),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
