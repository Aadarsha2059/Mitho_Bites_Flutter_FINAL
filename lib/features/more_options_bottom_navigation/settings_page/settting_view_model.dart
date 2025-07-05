import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/settings_page/setting_event.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/settings_page/setting_state.dart';
import 'package:fooddelivery_b/app/theme/theme_provider.dart';

class SettingsViewModel extends Bloc<SettingsEvent, SettingsState> {
  final ThemeProvider? themeProvider;
  
  SettingsViewModel({this.themeProvider}) : super(SettingsState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ToggleNotificationEvent>(_onToggleNotification);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateCurrencyEvent>(_onUpdateCurrency);
    on<ToggleLocationServicesEvent>(_onToggleLocationServices);
    on<UpdateDeliveryPreferencesEvent>(_onUpdateDeliveryPreferences);
    on<ClearCacheEvent>(_onClearCache);
    on<ResetSettingsEvent>(_onResetSettings);
    
    // Load settings when initialized
    add(LoadSettingsEvent());
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final settings = SettingsData(
        notificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
        darkModeEnabled: prefs.getBool('dark_mode_enabled') ?? false,
        language: prefs.getString('language') ?? 'English',
        currency: prefs.getString('currency') ?? 'NPR',
        locationServicesEnabled: prefs.getBool('location_services_enabled') ?? true,
        deliveryPreferences: prefs.getString('delivery_preferences') ?? 'Standard',
        autoLocationEnabled: prefs.getBool('auto_location_enabled') ?? true,
        orderHistoryEnabled: prefs.getBool('order_history_enabled') ?? true,
        savePaymentMethods: prefs.getBool('save_payment_methods') ?? false,
        showRestaurantRatings: prefs.getBool('show_restaurant_ratings') ?? true,
        showCalories: prefs.getBool('show_calories') ?? false,
        showAllergenInfo: prefs.getBool('show_allergen_info') ?? true,
        enableChatbot: prefs.getBool('enable_chatbot') ?? true,
        enableVoiceSearch: prefs.getBool('enable_voice_search') ?? true,
        enableWeatherRecommendations: prefs.getBool('enable_weather_recommendations') ?? true,
      );
      
      emit(state.copyWith(
        settings: settings,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load settings: $e',
      ));
    }
  }

  Future<void> _onToggleNotification(ToggleNotificationEvent event, Emitter<SettingsState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newValue = !state.settings.notificationsEnabled;
      await prefs.setBool('notifications_enabled', newValue);
      
      emit(state.copyWith(
        settings: state.settings.copyWith(notificationsEnabled: newValue),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to update notification settings: $e',
      ));
    }
  }

  Future<void> _onToggleDarkMode(ToggleDarkModeEvent event, Emitter<SettingsState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newValue = !state.settings.darkModeEnabled;
      await prefs.setBool('dark_mode_enabled', newValue);
      
      // Notify theme provider about the change
      themeProvider?.setTheme(newValue);
      
      emit(state.copyWith(
        settings: state.settings.copyWith(darkModeEnabled: newValue),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to update dark mode settings: $e',
      ));
    }
  }

  Future<void> _onUpdateLanguage(UpdateLanguageEvent event, Emitter<SettingsState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', event.language);
      
      emit(state.copyWith(
        settings: state.settings.copyWith(language: event.language),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to update language settings: $e',
      ));
    }
  }

  Future<void> _onUpdateCurrency(UpdateCurrencyEvent event, Emitter<SettingsState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currency', event.currency);
      
      emit(state.copyWith(
        settings: state.settings.copyWith(currency: event.currency),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to update currency settings: $e',
      ));
    }
  }

  Future<void> _onToggleLocationServices(ToggleLocationServicesEvent event, Emitter<SettingsState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newValue = !state.settings.locationServicesEnabled;
      await prefs.setBool('location_services_enabled', newValue);
      
      emit(state.copyWith(
        settings: state.settings.copyWith(locationServicesEnabled: newValue),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to update location services settings: $e',
      ));
    }
  }

  Future<void> _onUpdateDeliveryPreferences(UpdateDeliveryPreferencesEvent event, Emitter<SettingsState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('delivery_preferences', event.preferences);
      
      emit(state.copyWith(
        settings: state.settings.copyWith(deliveryPreferences: event.preferences),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to update delivery preferences: $e',
      ));
    }
  }

  Future<void> _onClearCache(ClearCacheEvent event, Emitter<SettingsState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      // Simulate cache clearing
      await Future.delayed(const Duration(seconds: 2));
      
      emit(state.copyWith(
        isLoading: false,
        successMessage: 'Cache cleared successfully!',
      ));
      
      // Clear success message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        emit(state.copyWith(successMessage: null));
      });
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to clear cache: $e',
      ));
    }
  }

  Future<void> _onResetSettings(ResetSettingsEvent event, Emitter<SettingsState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      final prefs = await SharedPreferences.getInstance();
      
      // Reset all settings to default values
      await prefs.setBool('notifications_enabled', true);
      await prefs.setBool('dark_mode_enabled', false);
      await prefs.setString('language', 'English');
      await prefs.setString('currency', 'NPR');
      await prefs.setBool('location_services_enabled', true);
      await prefs.setString('delivery_preferences', 'Standard');
      await prefs.setBool('auto_location_enabled', true);
      await prefs.setBool('order_history_enabled', true);
      await prefs.setBool('save_payment_methods', false);
      await prefs.setBool('show_restaurant_ratings', true);
      await prefs.setBool('show_calories', false);
      await prefs.setBool('show_allergen_info', true);
      await prefs.setBool('enable_chatbot', true);
      await prefs.setBool('enable_voice_search', true);
      await prefs.setBool('enable_weather_recommendations', true);
      
      // Notify theme provider about the dark mode reset
      themeProvider?.setTheme(false);
      
      // Reload settings
      add(LoadSettingsEvent());
      
      emit(state.copyWith(
        isLoading: false,
        successMessage: 'Settings reset to default!',
      ));
      
      // Clear success message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        emit(state.copyWith(successMessage: null));
      });
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to reset settings: $e',
      ));
    }
  }
}

class SettingsData {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String language;
  final String currency;
  final bool locationServicesEnabled;
  final String deliveryPreferences;
  final bool autoLocationEnabled;
  final bool orderHistoryEnabled;
  final bool savePaymentMethods;
  final bool showRestaurantRatings;
  final bool showCalories;
  final bool showAllergenInfo;
  final bool enableChatbot;
  final bool enableVoiceSearch;
  final bool enableWeatherRecommendations;

  const SettingsData({
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.language,
    required this.currency,
    required this.locationServicesEnabled,
    required this.deliveryPreferences,
    required this.autoLocationEnabled,
    required this.orderHistoryEnabled,
    required this.savePaymentMethods,
    required this.showRestaurantRatings,
    required this.showCalories,
    required this.showAllergenInfo,
    required this.enableChatbot,
    required this.enableVoiceSearch,
    required this.enableWeatherRecommendations,
  });

  SettingsData copyWith({
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? language,
    String? currency,
    bool? locationServicesEnabled,
    String? deliveryPreferences,
    bool? autoLocationEnabled,
    bool? orderHistoryEnabled,
    bool? savePaymentMethods,
    bool? showRestaurantRatings,
    bool? showCalories,
    bool? showAllergenInfo,
    bool? enableChatbot,
    bool? enableVoiceSearch,
    bool? enableWeatherRecommendations,
  }) {
    return SettingsData(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      locationServicesEnabled: locationServicesEnabled ?? this.locationServicesEnabled,
      deliveryPreferences: deliveryPreferences ?? this.deliveryPreferences,
      autoLocationEnabled: autoLocationEnabled ?? this.autoLocationEnabled,
      orderHistoryEnabled: orderHistoryEnabled ?? this.orderHistoryEnabled,
      savePaymentMethods: savePaymentMethods ?? this.savePaymentMethods,
      showRestaurantRatings: showRestaurantRatings ?? this.showRestaurantRatings,
      showCalories: showCalories ?? this.showCalories,
      showAllergenInfo: showAllergenInfo ?? this.showAllergenInfo,
      enableChatbot: enableChatbot ?? this.enableChatbot,
      enableVoiceSearch: enableVoiceSearch ?? this.enableVoiceSearch,
      enableWeatherRecommendations: enableWeatherRecommendations ?? this.enableWeatherRecommendations,
    );
  }
}
