import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/settings_page/setting_event.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/settings_page/setting_state.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/settings_page/settting_view_model.dart';
import 'package:fooddelivery_b/app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({super.key});

  @override
  State<SettingsPageView> createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool _sensorToggleLock = false;

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      if (!_sensorToggleLock && (event.x.abs() > 7 || event.y.abs() > 7)) {
        _sensorToggleLock = true;
        if (mounted) {
          final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
          final settingsViewModel = context.read<SettingsViewModel>();
          final newDarkMode = !themeProvider.isDarkMode;
          themeProvider.setTheme(newDarkMode);
          settingsViewModel.add(const ToggleDarkModeEvent());
        }
        Future.delayed(const Duration(seconds: 2), () {
          _sensorToggleLock = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return BlocProvider(
          create: (context) => SettingsViewModel(themeProvider: themeProvider),
          child: WillPopScope(
            onWillPop: () async {
              // Just allow pop, do not manually dispose Bloc
              return true;
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).appBarTheme.titleTextStyle?.color ?? Colors.white,
                  ),
                ),
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Colors.orange,
                elevation: 0,
                iconTheme: IconThemeData(color: Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white),
              ),
              body: BlocConsumer<SettingsViewModel, SettingsState>(
                listener: (context, state) {
                  if (!mounted) return;
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                  if (state.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.successMessage!),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildNotificationSettings(context, state),
                        const SizedBox(height: 20),
                        _buildAppearanceSettings(context, state),
                        const SizedBox(height: 20),
                        _buildLanguageAndCurrencySettings(context, state),
                        const SizedBox(height: 20),
                        _buildLocationSettings(context, state),
                        const SizedBox(height: 20),
                        _buildDeliverySettings(context, state),
                        const SizedBox(height: 20),
                        _buildDisplaySettings(context, state),
                        const SizedBox(height: 20),
                        _buildFeatureSettings(context, state),
                        const SizedBox(height: 20),
                        _buildDataSettings(context, state),
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.settings, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Customize your Mitho Bites experience',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, SettingsState state) {
    return _buildSettingsSection(
      title: 'Notifications',
      icon: Icons.notifications,
      color: Colors.blue,
      children: [
        _buildSwitchTile(
          title: 'Push Notifications',
          subtitle: 'Receive order updates and offers',
          icon: Icons.notifications_active,
          value: state.settings.notificationsEnabled,
          onChanged: (value) {
            context.read<SettingsViewModel>().add(
              const ToggleNotificationEvent(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSettings(BuildContext context, SettingsState state) {
    return _buildSettingsSection(
      title: 'Appearance',
      icon: Icons.palette,
      color: Colors.purple,
      children: [
        _buildSwitchTile(
          title: 'Dark Mode',
          subtitle: 'Switch to dark theme',
          icon: Icons.dark_mode,
          value: state.settings.darkModeEnabled,
          onChanged: (value) {
            context.read<SettingsViewModel>().add(const ToggleDarkModeEvent());
          },
        ),
      ],
    );
  }

  Widget _buildLanguageAndCurrencySettings(
    BuildContext context,
    SettingsState state,
  ) {
    return _buildSettingsSection(
      title: 'Language & Currency',
      icon: Icons.language,
      color: Colors.green,
      children: [
        _buildListTile(
          title: 'Language',
          subtitle: state.settings.language,
          icon: Icons.translate,
          onTap: () => _showLanguageDialog(context, state),
        ),
        _buildListTile(
          title: 'Currency',
          subtitle: state.settings.currency,
          icon: Icons.attach_money,
          onTap: () => _showCurrencyDialog(context, state),
        ),
      ],
    );
  }

  Widget _buildLocationSettings(BuildContext context, SettingsState state) {
    return _buildSettingsSection(
      title: 'Location Services',
      icon: Icons.location_on,
      color: Colors.red,
      children: [
        _buildSwitchTile(
          title: 'Location Services',
          subtitle: 'Enable location for delivery',
          icon: Icons.location_on,
          value: state.settings.locationServicesEnabled,
          onChanged: (value) {
            context.read<SettingsViewModel>().add(
              const ToggleLocationServicesEvent(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeliverySettings(BuildContext context, SettingsState state) {
    return _buildSettingsSection(
      title: 'Delivery Preferences',
      icon: Icons.delivery_dining,
      color: Colors.orange,
      children: [
        _buildListTile(
          title: 'Delivery Type',
          subtitle: state.settings.deliveryPreferences,
          icon: Icons.delivery_dining,
          onTap: () => _showDeliveryPreferencesDialog(context, state),
        ),
      ],
    );
  }

  Widget _buildDisplaySettings(BuildContext context, SettingsState state) {
    return _buildSettingsSection(
      title: 'Display Options',
      icon: Icons.visibility,
      color: Colors.indigo,
      children: [
        _buildSwitchTile(
          title: 'Show Food Ratings',
          subtitle: 'Display food products ratings',
          icon: Icons.star,
          value: state.settings.showRestaurantRatings,
          onChanged: (value) {
            // This would need to be implemented in the view model
          },
        ),
        _buildSwitchTile(
          title: 'Show Party palaces  Information',
          subtitle: 'Display party palaces content',
          icon: Icons.local_fire_department,
          value: state.settings.showCalories,
          onChanged: (value) {
            // This would need to be implemented in the view model
          },
        ),
        _buildSwitchTile(
          title: 'Show  errors  information',
          subtitle: 'Display errors & warnings',
          icon: Icons.warning,
          value: state.settings.showAllergenInfo,
          onChanged: (value) {
            // This would need to be implemented in the view model
          },
        ),
      ],
    );
  }

  Widget _buildFeatureSettings(BuildContext context, SettingsState state) {
    return _buildSettingsSection(
      title: 'Features',
      icon: Icons.featured_play_list,
      color: Colors.teal,
      children: [
        _buildSwitchTile(
          title: 'Enable Chatbot',
          subtitle: 'AI assistant for help',
          icon: Icons.smart_toy,
          value: state.settings.enableChatbot,
          onChanged: (value) {
            // This would need to be implemented in the view model
          },
        ),
        _buildSwitchTile(
          title: 'Voice Search',
          subtitle: 'Search by voice commands',
          icon: Icons.mic,
          value: state.settings.enableVoiceSearch,
          onChanged: (value) {
            // This would need to be implemented in the view model
          },
        ),
        _buildSwitchTile(
          title: 'Weather Recommendations',
          subtitle: 'Food suggestions based on weather',
          icon: Icons.wb_sunny,
          value: state.settings.enableWeatherRecommendations,
          onChanged: (value) {
            // This would need to be implemented in the view model
          },
        ),
      ],
    );
  }

  Widget _buildDataSettings(BuildContext context, SettingsState state) {
    return _buildSettingsSection(
      title: 'Data & Storage',
      icon: Icons.storage,
      color: Colors.grey,
      children: [
        _buildListTile(
          title: 'Clear Cache',
          subtitle: 'Free up storage space',
          icon: Icons.cleaning_services,
          onTap: () {
            _showClearCacheDialog(context);
          },
        ),
        _buildListTile(
          title: 'Reset Settings',
          subtitle: 'Restore default settings',
          icon: Icons.restore,
          onTap: () {
            _showResetSettingsDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade800 
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon, 
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade300 
              : Colors.grey.shade700, 
          size: 20
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14, 
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.orange,
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade800 
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon, 
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade300 
              : Colors.grey.shade700, 
          size: 20
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14, 
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios, 
        size: 16,
        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
      ),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsState state) {
    final languages = ['English', 'Nepali', 'Hindi'];

    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context),
        child: AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: state.settings.language,
                onChanged: (value) {
                  if (value != null) {
                    final viewModel = context.read<SettingsViewModel>();
                    viewModel.add(UpdateLanguageEvent(value));
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, SettingsState state) {
    final currencies = ['NPR', 'USD', 'INR', 'EUR'];

    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context),
        child: AlertDialog(
          title: const Text('Select Currency'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: currencies.map((currency) {
              return RadioListTile<String>(
                title: Text(currency),
                value: currency,
                groupValue: state.settings.currency,
                onChanged: (value) {
                  if (value != null) {
                    final viewModel = context.read<SettingsViewModel>();
                    viewModel.add(UpdateCurrencyEvent(value));
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeliveryPreferencesDialog(
    BuildContext context,
    SettingsState state,
  ) {
    final preferences = ['Standard', 'Express', 'Scheduled'];

    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context),
        child: AlertDialog(
          title: const Text('Select Delivery Preference'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: preferences.map((preference) {
              return RadioListTile<String>(
                title: Text(preference),
                value: preference,
                groupValue: state.settings.deliveryPreferences,
                onChanged: (value) {
                  if (value != null) {
                    final viewModel = context.read<SettingsViewModel>();
                    viewModel.add(UpdateDeliveryPreferencesEvent(value));
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context),
        child: AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text(
            'This will clear all cached data. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final viewModel = context.read<SettingsViewModel>();
                viewModel.add(const ClearCacheEvent());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context),
        child: AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text(
            'This will reset all settings to default. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final viewModel = context.read<SettingsViewModel>();
                viewModel.add(const ResetSettingsEvent());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
