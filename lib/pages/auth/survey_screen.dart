import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_asset.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../../controller/login_controller.dart';
import '../../utils/common_app_bar.dart';
import 'close_survey_screen.dart';

class SurveyScreen extends StatelessWidget {
  SurveyScreen({Key? key}) : super(key: key);

  var controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentQuestionIndex.value > 0) {
          var currentQuestion = controller
              .surveyQuestionsList[controller.currentQuestionIndex.value];

          // Prevent back navigation if the current question is unanswered
          bool isAnswered = controller.selectedAnswersList
              .any((item) => item['QuestionId'] == currentQuestion.questionId);

          if (!isAnswered) {
            CommonMethod.getXSnackBar("Answer Required",
                "Please answer the question before going back.", redColor);
            return false;
          }

          controller.currentQuestionIndex.value--;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: CommonAppBar(),
        body: BaseBackgroundWidget(
          child: Obx(
            () => controller.surveyQuestionsList.isEmpty &&
                    controller.isLoading.value == false
                ? NoDataFound(
                    title: "Survey",
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height20,
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 16.sp),
                      //   child: Obx(
                      //     () => Text(
                      //       "Question ${controller.currentQuestionIndex.value + 1} of the Survey",
                      //       style: AppTextStyle.normalExtraBold,
                      //     ),
                      //   ),
                      // ),
                      // height05,
                      Expanded(
                        child: Obx(() {
                          // Ensure there's data in surveyQuestionsList before accessing it
                          if (controller.surveyQuestionsList.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          }

                          var currentQuestion = controller.surveyQuestionsList[
                              controller.currentQuestionIndex.value];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.sp),
                                child: Text(
                                  currentQuestion.questionText ?? "-",
                                  style: AppTextStyle.normalRegular16
                                      .copyWith(color: lightBlackColor),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              height20,
                              Expanded(
                                child: ListView.builder(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.sp),
                                  itemCount: controller
                                      .surveyQuestionsList
                                      .value[
                                          controller.currentQuestionIndex.value]
                                      .answers!
                                      .length,
                                  itemBuilder: (context, index) {
                                    var currentQuestion = controller
                                            .surveyQuestionsList.value[
                                        controller.currentQuestionIndex.value];
                                    var element =
                                        currentQuestion.answers![index];

                                    // Use Obx to track the changes in the selected answers list
                                    return Obx(() {
                                      var isSelect = controller
                                          .selectedAnswersList
                                          .any((item) =>
                                              item['QuestionId'] ==
                                                  currentQuestion.questionId &&
                                              item['AnswerId'] ==
                                                  element.answerId);

                                      return GestureDetector(
                                        onTap: () {
                                          controller.selectAnswer(
                                              currentQuestion.questionId!,
                                              element.answerId!);
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.sp),
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
                                                      style: AppTextStyle
                                                          .normalBold14,
                                                    ),
                                                  ),
                                                  SvgPicture.asset(isSelect
                                                      ? AppAsset.selectedCheck
                                                      : AppAsset
                                                          .unselectedCheck),
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
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.sp),
                                child: Obx(
                                  () {
                                    var currentQuestion = controller
                                            .surveyQuestionsList[
                                        controller.currentQuestionIndex.value];

                                    // Check if the current question is answered
                                    bool isCurrentQuestionAnswered =
                                        controller.selectedAnswersList.any(
                                      (item) =>
                                          item['QuestionId'] ==
                                          currentQuestion.questionId,
                                    );

                                    return PrimaryTextButton(
                                        buttonColor: isCurrentQuestionAnswered
                                            ? null
                                            : disableButtonColor,
                                        title: "Next",
                                        onPressed: () async {
                                          if (isCurrentQuestionAnswered) {
                                            if (controller.currentQuestionIndex
                                                    .value <
                                                controller.surveyQuestionsList
                                                        .length -
                                                    1) {
                                              controller
                                                  .currentQuestionIndex.value++;
                                            } else {
                                              await controller
                                                  .saveSurvey(context);

                                              // Get.to(() =>
                                              //     CloseSurveyScreen()); // End of survey
                                            }
                                          } else {
                                            CommonMethod.getXSnackBar(
                                                "Selection Required",
                                                "Please select an answer before proceeding.",
                                                redColor);
                                          }
                                        });
                                  },
                                ),
                              ),
                              customHeight(56)
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
