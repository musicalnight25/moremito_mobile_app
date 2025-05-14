// To parse this JSON data, do
//
//     final surveyQuestionsResponseModel = surveyQuestionsResponseModelFromJson(jsonString);

import 'dart:convert';

SurveyQuestionsResponseModel surveyQuestionsResponseModelFromJson(String str) =>
    SurveyQuestionsResponseModel.fromJson(json.decode(str));

String surveyQuestionsResponseModelToJson(SurveyQuestionsResponseModel data) =>
    json.encode(data.toJson());

class SurveyQuestionsResponseModel {
  bool? status;
  dynamic message;
  List<SurveyQuestionsModel>? data;

  SurveyQuestionsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory SurveyQuestionsResponseModel.fromJson(Map<String, dynamic> json) =>
      SurveyQuestionsResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<SurveyQuestionsModel>.from(
                json["Data"]!.map((x) => SurveyQuestionsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SurveyQuestionsModel {
  int? questionId;
  String? questionText;
  List<AnswerModel>? answers;

  SurveyQuestionsModel({
    this.questionId,
    this.questionText,
    this.answers,
  });

  factory SurveyQuestionsModel.fromJson(Map<String, dynamic> json) =>
      SurveyQuestionsModel(
        questionId: json["QuestionId"],
        questionText: json["QuestionText"],
        answers: json["Answers"] == null
            ? []
            : List<AnswerModel>.from(
                json["Answers"]!.map((x) => AnswerModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "QuestionId": questionId,
        "QuestionText": questionText,
        "Answers": answers == null
            ? []
            : List<dynamic>.from(answers!.map((x) => x.toJson())),
      };
}

class AnswerModel {
  int? questionId;
  int? answerId;
  String? answerText;

  AnswerModel({
    this.questionId,
    this.answerId,
    this.answerText,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
        questionId: json["QuestionId"],
        answerId: json["AnswerId"],
        answerText: json["AnswerText"],
      );

  Map<String, dynamic> toJson() => {
        "QuestionId": questionId,
        "AnswerId": answerId,
        "AnswerText": answerText,
      };
}
