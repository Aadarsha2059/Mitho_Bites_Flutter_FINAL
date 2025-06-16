import 'package:fooddelivery_b/features/user/data/model/user_api_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'getall_user_dto.g.dart';
@JsonSerializable()
class GetAllUserDTO {
  final bool success;
  final int count;
  final List<UserApiModel> data;

  const GetAllUserDTO({
    required this.success,
    required this.count,
    required this.data,
  });
  //from json
  factory GetAllUserDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllUserDTOFromJson(json);

  // to json
  Map<String, dynamic> toJson() =>  _$GetAllUserDTOToJson(this);

}
