import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class ToggleNotificationEvent extends SettingsEvent {
  const ToggleNotificationEvent();
}

class ToggleDarkModeEvent extends SettingsEvent {
  const ToggleDarkModeEvent();
}

class UpdateLanguageEvent extends SettingsEvent {
  final String language;

  const UpdateLanguageEvent(this.language);

  @override
  List<Object?> get props => [language];
}

class UpdateCurrencyEvent extends SettingsEvent {
  final String currency;

  const UpdateCurrencyEvent(this.currency);

  @override
  List<Object?> get props => [currency];
}

class ToggleLocationServicesEvent extends SettingsEvent {
  const ToggleLocationServicesEvent();
}

class UpdateDeliveryPreferencesEvent extends SettingsEvent {
  final String preferences;

  const UpdateDeliveryPreferencesEvent(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class ClearCacheEvent extends SettingsEvent {
  const ClearCacheEvent();
}

class ResetSettingsEvent extends SettingsEvent {
  const ResetSettingsEvent();
}
