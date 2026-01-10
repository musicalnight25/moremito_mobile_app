import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/main_dashboard_screen.dart';
import 'package:more_mitro_app/service/network_repository.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/preferences_util.dart';

import '../model/survey_questions_model.dart';

class SurveyController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;

  /// unified list for both responses + questions
  RxList<SurveyQuestion> surveyQuestionsList = <SurveyQuestion>[].obs;

  /// user selected answers here
  RxList<Map<String, int>> selectedAnswersList = <Map<String, int>>[].obs;

  /// Question index
  RxInt currentQuestionIndex = 0.obs;

  /// Fetch questions (decides which API to call)
  Future<void> getSurveyQuestions(bool isFromOnboarding) async {
    isLoading.value = true;
    selectedAnswersList.clear();
    currentQuestionIndex.value = 0;

    try {
      /// SELECT API BASED ON FLOW
      var response = isFromOnboarding
          ? await _repo.getSurveyQuestions(null) // first time
          : await _repo.getSurveyResponses(null); // already answered

      if (response != null) {
        final model = surveyWrapperFromJson(json.encode(response));
        surveyQuestionsList.assignAll(model.data ?? []);

        /// Prefill selected answers if NOT onboarding
        if (!isFromOnboarding) {
          for (var q in surveyQuestionsList) {
            if (q.answerId != null) {
              selectedAnswersList.add({
                "QuestionId": q.questionId!,
                "AnswerId": q.answerId!,
              });
            }
          }
        }
      } else {
        surveyQuestionsList.clear();
      }
    } catch (e) {
      surveyQuestionsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// SELECT ANSWER
  void selectAnswer(int questionId, int answerId) {
    final index =
        selectedAnswersList.indexWhere((x) => x['QuestionId'] == questionId);

    if (index >= 0) {
      selectedAnswersList[index] = {
        "QuestionId": questionId,
        "AnswerId": answerId,
      };
    } else {
      selectedAnswersList.add({
        "QuestionId": questionId,
        "AnswerId": answerId,
      });
    }
  }

  /// Submit survey
  Future<void> saveSurvey(BuildContext context) async {
    if (selectedAnswersList.length < surveyQuestionsList.length) {
      CommonMethod.getXSnackBar(
        "Incomplete Survey",
        "Please answer all questions before submitting.",
        redColor,
      );
      return;
    }

    try {
      var res = await _repo.saveSurvey(context, selectedAnswersList);

      if (res != null && res['Status'] == true) {
        await PreferencesUtil.setSurveyCompleted();

        CommonMethod.getXSnackBar(
          "Success",
          "Your survey has been submitted.",
          greenColor,
        );

        Get.offAll(() => MainHomeScreen());
      } else {
        CommonMethod.getXSnackBar(
          "Error",
          "Submission failed, try again.",
          redColor,
        );
      }
    } catch (e) {
      CommonMethod.getXSnackBar(
        "Error",
        "Unable to submit survey. Try again later.",
        redColor,
      );
    }
  }
}
