import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/settings_page/settting_view_model.dart';

class SettingsState extends Equatable {
  final SettingsData settings;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const SettingsState({
    required this.settings,
    required this.isLoading,
    this.errorMessage,
    this.successMessage,
  });

  const SettingsState.initial()
      : settings = const SettingsData(
          notificationsEnabled: true,
          darkModeEnabled: false,
          language: 'English',
          currency: 'NPR',
          locationServicesEnabled: true,
          deliveryPreferences: 'Standard',
          autoLocationEnabled: true,
          orderHistoryEnabled: true,
          savePaymentMethods: false,
          showRestaurantRatings: true,
          showCalories: false,
          showAllergenInfo: true,
          enableChatbot: true,
          enableVoiceSearch: true,
          enableWeatherRecommendations: true,
        ),
        isLoading = false,
        errorMessage = null,
        successMessage = null;

  SettingsState copyWith({
    SettingsData? settings,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        settings,
        isLoading,
        errorMessage,
        successMessage,
      ];
}
