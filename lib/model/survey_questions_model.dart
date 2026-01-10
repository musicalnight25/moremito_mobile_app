import 'dart:convert';

SurveyResponseWrapper surveyWrapperFromJson(String str) =>
    SurveyResponseWrapper.fromJson(json.decode(str));

/// Wrapper for both API responses
class SurveyResponseWrapper {
  bool? status;
  String? message;
  List<SurveyQuestion>? data;

  SurveyResponseWrapper({this.status, this.message, this.data});

  factory SurveyResponseWrapper.fromJson(Map<String, dynamic> json) =>
      SurveyResponseWrapper(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<SurveyQuestion>.from(
                json["Data"].map((x) => SurveyQuestion.fromJson(x))),
      );
}

/// Main Question Model
class SurveyQuestion {
  int? id;
  int? userId;
  int? questionId;
  String? questionText;
  int? answerId; // selected answer if exists
  String? answerText; // selected answer text
  List<AnswerOption>? answers; // onboarding
  List<AnswerOption>? allAnswerOptions; // after login

  SurveyQuestion({
    this.id,
    this.userId,
    this.questionId,
    this.questionText,
    this.answerId,
    this.answerText,
    this.answers,
    this.allAnswerOptions,
  });

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) => SurveyQuestion(
        id: json["Id"],
        userId: json["UserId"],
        questionId: json["QuestionId"],
        questionText: json["QuestionText"],
        answerId: json["AnswerId"],
        answerText: json["AnswerText"],
        answers: json["Answers"] == null
            ? []
            : List<AnswerOption>.from(
                json["Answers"].map((x) => AnswerOption.fromJson(x))),
        allAnswerOptions: json["AllAnswerOptions"] == null
            ? []
            : List<AnswerOption>.from(
                json["AllAnswerOptions"].map((x) => AnswerOption.fromJson(x))),
      );
}

/// Answer option model
class AnswerOption {
  int? questionId;
  int? answerId;
  String? answerText;

  AnswerOption({this.questionId, this.answerId, this.answerText});

  factory AnswerOption.fromJson(Map<String, dynamic> json) => AnswerOption(
        questionId: json["QuestionId"],
        answerId: json["AnswerId"],
        answerText: json["AnswerText"],
      );
}
