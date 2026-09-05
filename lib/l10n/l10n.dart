// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Rule`
  String get rule {
    return Intl.message('Rule', name: 'rule', desc: '', args: []);
  }

  /// `Global`
  String get global {
    return Intl.message('Global', name: 'global', desc: '', args: []);
  }

  /// `Direct`
  String get direct {
    return Intl.message('Direct', name: 'direct', desc: '', args: []);
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
  }

  /// `Proxies`
  String get proxies {
    return Intl.message('Proxies', name: 'proxies', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Profiles`
  String get profiles {
    return Intl.message('Profiles', name: 'profiles', desc: '', args: []);
  }

  /// `Tools`
  String get tools {
    return Intl.message('Tools', name: 'tools', desc: '', args: []);
  }

  /// `Logs`
  String get logs {
    return Intl.message('Logs', name: 'logs', desc: '', args: []);
  }

  /// `Log capture records`
  String get logsDesc {
    return Intl.message(
      'Log capture records',
      name: 'logsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Resources`
  String get resources {
    return Intl.message('Resources', name: 'resources', desc: '', args: []);
  }

  /// `External resource related info`
  String get resourcesDesc {
    return Intl.message(
      'External resource related info',
      name: 'resourcesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Traffic usage`
  String get trafficUsage {
    return Intl.message(
      'Traffic usage',
      name: 'trafficUsage',
      desc: '',
      args: [],
    );
  }

  /// `Core info`
  String get coreInfo {
    return Intl.message('Core info', name: 'coreInfo', desc: '', args: []);
  }

  /// `Network speed`
  String get networkSpeed {
    return Intl.message(
      'Network speed',
      name: 'networkSpeed',
      desc: '',
      args: [],
    );
  }

  /// `Outbound mode`
  String get outboundMode {
    return Intl.message(
      'Outbound mode',
      name: 'outboundMode',
      desc: '',
      args: [],
    );
  }

  /// `Network detection`
  String get networkDetection {
    return Intl.message(
      'Network detection',
      name: 'networkDetection',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message('Upload', name: 'upload', desc: '', args: []);
  }

  /// `Download`
  String get download {
    return Intl.message('Download', name: 'download', desc: '', args: []);
  }

  /// `No proxy`
  String get noProxy {
    return Intl.message('No proxy', name: 'noProxy', desc: '', args: []);
  }

  /// `Please create a profile or add a valid profile`
  String get noProxyDesc {
    return Intl.message(
      'Please create a profile or add a valid profile',
      name: 'noProxyDesc',
      desc: '',
      args: [],
    );
  }

  /// `No profile, Please add a profile`
  String get nullProfileDesc {
    return Intl.message(
      'No profile, Please add a profile',
      name: 'nullProfileDesc',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Default`
  String get defaultText {
    return Intl.message('Default', name: 'defaultText', desc: '', args: []);
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `English`
  String get en {
    return Intl.message('English', name: 'en', desc: '', args: []);
  }

  /// `Japanese`
  String get ja {
    return Intl.message('Japanese', name: 'ja', desc: '', args: []);
  }

  /// `Russian`
  String get ru {
    return Intl.message('Russian', name: 'ru', desc: '', args: []);
  }

  /// `Simplified Chinese`
  String get zh_CN {
    return Intl.message(
      'Simplified Chinese',
      name: 'zh_CN',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Set dark mode,adjust the color`
  String get themeDesc {
    return Intl.message(
      'Set dark mode,adjust the color',
      name: 'themeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Override`
  String get override {
    return Intl.message('Override', name: 'override', desc: '', args: []);
  }

  /// `Override Proxy related config`
  String get overrideDesc {
    return Intl.message(
      'Override Proxy related config',
      name: 'overrideDesc',
      desc: '',
      args: [],
    );
  }

  /// `AllowLan`
  String get allowLan {
    return Intl.message('AllowLan', name: 'allowLan', desc: '', args: []);
  }

  /// `Allow access proxy through the LAN`
  String get allowLanDesc {
    return Intl.message(
      'Allow access proxy through the LAN',
      name: 'allowLanDesc',
      desc: '',
      args: [],
    );
  }

  /// `TUN`
  String get tun {
    return Intl.message('TUN', name: 'tun', desc: '', args: []);
  }

  /// `only effective in administrator mode`
  String get tunDesc {
    return Intl.message(
      'only effective in administrator mode',
      name: 'tunDesc',
      desc: '',
      args: [],
    );
  }

  /// `Minimize on exit`
  String get minimizeOnExit {
    return Intl.message(
      'Minimize on exit',
      name: 'minimizeOnExit',
      desc: '',
      args: [],
    );
  }

  /// `Modify the default system exit event`
  String get minimizeOnExitDesc {
    return Intl.message(
      'Modify the default system exit event',
      name: 'minimizeOnExitDesc',
      desc: '',
      args: [],
    );
  }

  /// `Auto launch`
  String get autoLaunch {
    return Intl.message('Auto launch', name: 'autoLaunch', desc: '', args: []);
  }

  /// `Follow the system self startup`
  String get autoLaunchDesc {
    return Intl.message(
      'Follow the system self startup',
      name: 'autoLaunchDesc',
      desc: '',
      args: [],
    );
  }

  /// `SilentLaunch`
  String get silentLaunch {
    return Intl.message(
      'SilentLaunch',
      name: 'silentLaunch',
      desc: '',
      args: [],
    );
  }

  /// `Start in the background`
  String get silentLaunchDesc {
    return Intl.message(
      'Start in the background',
      name: 'silentLaunchDesc',
      desc: '',
      args: [],
    );
  }

  /// `AutoRun`
  String get autoRun {
    return Intl.message('AutoRun', name: 'autoRun', desc: '', args: []);
  }

  /// `Auto run when the application is opened`
  String get autoRunDesc {
    return Intl.message(
      'Auto run when the application is opened',
      name: 'autoRunDesc',
      desc: '',
      args: [],
    );
  }

  /// `Logcat`
  String get logcat {
    return Intl.message('Logcat', name: 'logcat', desc: '', args: []);
  }

  /// `Disabling will hide the log entry`
  String get logcatDesc {
    return Intl.message(
      'Disabling will hide the log entry',
      name: 'logcatDesc',
      desc: '',
      args: [],
    );
  }

  /// `Auto check updates`
  String get autoCheckUpdate {
    return Intl.message(
      'Auto check updates',
      name: 'autoCheckUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Auto check for updates when the app starts`
  String get autoCheckUpdateDesc {
    return Intl.message(
      'Auto check for updates when the app starts',
      name: 'autoCheckUpdateDesc',
      desc: '',
      args: [],
    );
  }

  /// `AccessControl`
  String get accessControl {
    return Intl.message(
      'AccessControl',
      name: 'accessControl',
      desc: '',
      args: [],
    );
  }

  /// `Configure application access proxy`
  String get accessControlDesc {
    return Intl.message(
      'Configure application access proxy',
      name: 'accessControlDesc',
      desc: '',
      args: [],
    );
  }

  /// `Application`
  String get application {
    return Intl.message('Application', name: 'application', desc: '', args: []);
  }

  /// `Modify application related settings`
  String get applicationDesc {
    return Intl.message(
      'Modify application related settings',
      name: 'applicationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Years`
  String get years {
    return Intl.message('Years', name: 'years', desc: '', args: []);
  }

  /// `Months`
  String get months {
    return Intl.message('Months', name: 'months', desc: '', args: []);
  }

  /// `Hours`
  String get hours {
    return Intl.message('Hours', name: 'hours', desc: '', args: []);
  }

  /// `Days`
  String get days {
    return Intl.message('Days', name: 'days', desc: '', args: []);
  }

  /// `Minutes`
  String get minutes {
    return Intl.message('Minutes', name: 'minutes', desc: '', args: []);
  }

  /// `Seconds`
  String get seconds {
    return Intl.message('Seconds', name: 'seconds', desc: '', args: []);
  }

  /// ` Ago`
  String get ago {
    return Intl.message(' Ago', name: 'ago', desc: '', args: []);
  }

  /// `Just`
  String get just {
    return Intl.message('Just', name: 'just', desc: '', args: []);
  }

  /// `QR code`
  String get qrcode {
    return Intl.message('QR code', name: 'qrcode', desc: '', args: []);
  }

  /// `Scan QR code to obtain profile`
  String get qrcodeDesc {
    return Intl.message(
      'Scan QR code to obtain profile',
      name: 'qrcodeDesc',
      desc: '',
      args: [],
    );
  }

  /// `URL`
  String get url {
    return Intl.message('URL', name: 'url', desc: '', args: []);
  }

  /// `Obtain profile through URL`
  String get urlDesc {
    return Intl.message(
      'Obtain profile through URL',
      name: 'urlDesc',
      desc: '',
      args: [],
    );
  }

  /// `File`
  String get file {
    return Intl.message('File', name: 'file', desc: '', args: []);
  }

  /// `Directly upload profile`
  String get fileDesc {
    return Intl.message(
      'Directly upload profile',
      name: 'fileDesc',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Please input the profile name`
  String get profileNameNullValidationDesc {
    return Intl.message(
      'Please input the profile name',
      name: 'profileNameNullValidationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please input the profile URL`
  String get profileUrlNullValidationDesc {
    return Intl.message(
      'Please input the profile URL',
      name: 'profileUrlNullValidationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please input a valid profile URL`
  String get profileUrlInvalidValidationDesc {
    return Intl.message(
      'Please input a valid profile URL',
      name: 'profileUrlInvalidValidationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Auto update`
  String get autoUpdate {
    return Intl.message('Auto update', name: 'autoUpdate', desc: '', args: []);
  }

  /// `Auto update interval (minutes)`
  String get autoUpdateInterval {
    return Intl.message(
      'Auto update interval (minutes)',
      name: 'autoUpdateInterval',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the auto update interval time`
  String get profileAutoUpdateIntervalNullValidationDesc {
    return Intl.message(
      'Please enter the auto update interval time',
      name: 'profileAutoUpdateIntervalNullValidationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please input a valid interval time format`
  String get profileAutoUpdateIntervalInvalidValidationDesc {
    return Intl.message(
      'Please input a valid interval time format',
      name: 'profileAutoUpdateIntervalInvalidValidationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Theme mode`
  String get themeMode {
    return Intl.message('Theme mode', name: 'themeMode', desc: '', args: []);
  }

  /// `Theme color`
  String get themeColor {
    return Intl.message('Theme color', name: 'themeColor', desc: '', args: []);
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `Auto`
  String get auto {
    return Intl.message('Auto', name: 'auto', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `Import from URL`
  String get importFromURL {
    return Intl.message(
      'Import from URL',
      name: 'importFromURL',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Do you want to pass`
  String get doYouWantToPass {
    return Intl.message(
      'Do you want to pass',
      name: 'doYouWantToPass',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Sort by default`
  String get defaultSort {
    return Intl.message(
      'Sort by default',
      name: 'defaultSort',
      desc: '',
      args: [],
    );
  }

  /// `Sort by delay`
  String get delaySort {
    return Intl.message('Sort by delay', name: 'delaySort', desc: '', args: []);
  }

  /// `Sort by name`
  String get nameSort {
    return Intl.message('Sort by name', name: 'nameSort', desc: '', args: []);
  }

  /// `Please upload file`
  String get pleaseUploadFile {
    return Intl.message(
      'Please upload file',
      name: 'pleaseUploadFile',
      desc: '',
      args: [],
    );
  }

  /// `Please upload a valid QR code`
  String get pleaseUploadValidQrcode {
    return Intl.message(
      'Please upload a valid QR code',
      name: 'pleaseUploadValidQrcode',
      desc: '',
      args: [],
    );
  }

  /// `Blacklist mode`
  String get blacklistMode {
    return Intl.message(
      'Blacklist mode',
      name: 'blacklistMode',
      desc: '',
      args: [],
    );
  }

  /// `Whitelist mode`
  String get whitelistMode {
    return Intl.message(
      'Whitelist mode',
      name: 'whitelistMode',
      desc: '',
      args: [],
    );
  }

  /// `Filter system app`
  String get filterSystemApp {
    return Intl.message(
      'Filter system app',
      name: 'filterSystemApp',
      desc: '',
      args: [],
    );
  }

  /// `Cancel filter system app`
  String get cancelFilterSystemApp {
    return Intl.message(
      'Cancel filter system app',
      name: 'cancelFilterSystemApp',
      desc: '',
      args: [],
    );
  }

  /// `Select all`
  String get selectAll {
    return Intl.message('Select all', name: 'selectAll', desc: '', args: []);
  }

  /// `Cancel select all`
  String get cancelSelectAll {
    return Intl.message(
      'Cancel select all',
      name: 'cancelSelectAll',
      desc: '',
      args: [],
    );
  }

  /// `App access control`
  String get appAccessControl {
    return Intl.message(
      'App access control',
      name: 'appAccessControl',
      desc: '',
      args: [],
    );
  }

  /// `Only allow selected app to enter VPN`
  String get accessControlAllowDesc {
    return Intl.message(
      'Only allow selected app to enter VPN',
      name: 'accessControlAllowDesc',
      desc: '',
      args: [],
    );
  }

  /// `The selected application will be excluded from VPN`
  String get accessControlNotAllowDesc {
    return Intl.message(
      'The selected application will be excluded from VPN',
      name: 'accessControlNotAllowDesc',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selected {
    return Intl.message('Selected', name: 'selected', desc: '', args: []);
  }

  /// `unable to update current profile`
  String get unableToUpdateCurrentProfileDesc {
    return Intl.message(
      'unable to update current profile',
      name: 'unableToUpdateCurrentProfileDesc',
      desc: '',
      args: [],
    );
  }

  /// `No more info`
  String get noMoreInfoDesc {
    return Intl.message(
      'No more info',
      name: 'noMoreInfoDesc',
      desc: '',
      args: [],
    );
  }

  /// `profile parse error`
  String get profileParseErrorDesc {
    return Intl.message(
      'profile parse error',
      name: 'profileParseErrorDesc',
      desc: '',
      args: [],
    );
  }

  /// `ProxyPort`
  String get proxyPort {
    return Intl.message('ProxyPort', name: 'proxyPort', desc: '', args: []);
  }

  /// `Set the Clash listening port`
  String get proxyPortDesc {
    return Intl.message(
      'Set the Clash listening port',
      name: 'proxyPortDesc',
      desc: '',
      args: [],
    );
  }

  /// `Port`
  String get port {
    return Intl.message('Port', name: 'port', desc: '', args: []);
  }

  /// `LogLevel`
  String get logLevel {
    return Intl.message('LogLevel', name: 'logLevel', desc: '', args: []);
  }

  /// `Show`
  String get show {
    return Intl.message('Show', name: 'show', desc: '', args: []);
  }

  /// `Exit`
  String get exit {
    return Intl.message('Exit', name: 'exit', desc: '', args: []);
  }

  /// `System proxy`
  String get systemProxy {
    return Intl.message(
      'System proxy',
      name: 'systemProxy',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get project {
    return Intl.message('Project', name: 'project', desc: '', args: []);
  }

  /// `Core`
  String get core {
    return Intl.message('Core', name: 'core', desc: '', args: []);
  }

  /// `Tab animation`
  String get tabAnimation {
    return Intl.message(
      'Tab animation',
      name: 'tabAnimation',
      desc: '',
      args: [],
    );
  }

  /// `A multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free.`
  String get desc {
    return Intl.message(
      'A multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free.',
      name: 'desc',
      desc: '',
      args: [],
    );
  }

  /// `Starting VPN...`
  String get startVpn {
    return Intl.message(
      'Starting VPN...',
      name: 'startVpn',
      desc: '',
      args: [],
    );
  }

  /// `Stopping VPN...`
  String get stopVpn {
    return Intl.message('Stopping VPN...', name: 'stopVpn', desc: '', args: []);
  }

  /// `Discovery a new version`
  String get discovery {
    return Intl.message(
      'Discovery a new version',
      name: 'discovery',
      desc: '',
      args: [],
    );
  }

  /// `Compatibility mode`
  String get compatible {
    return Intl.message(
      'Compatibility mode',
      name: 'compatible',
      desc: '',
      args: [],
    );
  }

  /// `Opening it will lose part of its application ability and gain the support of full amount of Clash.`
  String get compatibleDesc {
    return Intl.message(
      'Opening it will lose part of its application ability and gain the support of full amount of Clash.',
      name: 'compatibleDesc',
      desc: '',
      args: [],
    );
  }

  /// `The current proxy group cannot be selected.`
  String get notSelectedTip {
    return Intl.message(
      'The current proxy group cannot be selected.',
      name: 'notSelectedTip',
      desc: '',
      args: [],
    );
  }

  /// `tip`
  String get tip {
    return Intl.message('tip', name: 'tip', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Backup`
  String get backup {
    return Intl.message('Backup', name: 'backup', desc: '', args: []);
  }

  /// `Backup success`
  String get backupSuccess {
    return Intl.message(
      'Backup success',
      name: 'backupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `No info`
  String get noInfo {
    return Intl.message('No info', name: 'noInfo', desc: '', args: []);
  }

  /// `Please bind WebDAV`
  String get pleaseBindWebDAV {
    return Intl.message(
      'Please bind WebDAV',
      name: 'pleaseBindWebDAV',
      desc: '',
      args: [],
    );
  }

  /// `Bind`
  String get bind {
    return Intl.message('Bind', name: 'bind', desc: '', args: []);
  }

  /// `Connectivity：`
  String get connectivity {
    return Intl.message(
      'Connectivity：',
      name: 'connectivity',
      desc: '',
      args: [],
    );
  }

  /// `WebDAV configuration`
  String get webDAVConfiguration {
    return Intl.message(
      'WebDAV configuration',
      name: 'webDAVConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `WebDAV server address`
  String get addressHelp {
    return Intl.message(
      'WebDAV server address',
      name: 'addressHelp',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid WebDAV address`
  String get addressTip {
    return Intl.message(
      'Please enter a valid WebDAV address',
      name: 'addressTip',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Check for updates`
  String get checkUpdate {
    return Intl.message(
      'Check for updates',
      name: 'checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Discover the new version`
  String get discoverNewVersion {
    return Intl.message(
      'Discover the new version',
      name: 'discoverNewVersion',
      desc: '',
      args: [],
    );
  }

  /// `The current application is already the latest version`
  String get checkUpdateError {
    return Intl.message(
      'The current application is already the latest version',
      name: 'checkUpdateError',
      desc: '',
      args: [],
    );
  }

  /// `Go to download`
  String get goDownload {
    return Intl.message(
      'Go to download',
      name: 'goDownload',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `GeoData`
  String get geoData {
    return Intl.message('GeoData', name: 'geoData', desc: '', args: []);
  }

  /// `External resources`
  String get externalResources {
    return Intl.message(
      'External resources',
      name: 'externalResources',
      desc: '',
      args: [],
    );
  }

  /// `Checking...`
  String get checking {
    return Intl.message('Checking...', name: 'checking', desc: '', args: []);
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Check error`
  String get checkError {
    return Intl.message('Check error', name: 'checkError', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Allow applications to bypass VPN`
  String get allowBypass {
    return Intl.message(
      'Allow applications to bypass VPN',
      name: 'allowBypass',
      desc: '',
      args: [],
    );
  }

  /// `Some apps can bypass VPN when turned on`
  String get allowBypassDesc {
    return Intl.message(
      'Some apps can bypass VPN when turned on',
      name: 'allowBypassDesc',
      desc: '',
      args: [],
    );
  }

  /// `ExternalController`
  String get externalController {
    return Intl.message(
      'ExternalController',
      name: 'externalController',
      desc: '',
      args: [],
    );
  }

  /// `Once enabled, the Clash kernel can be controlled on port 9090`
  String get externalControllerDesc {
    return Intl.message(
      'Once enabled, the Clash kernel can be controlled on port 9090',
      name: 'externalControllerDesc',
      desc: '',
      args: [],
    );
  }

  /// `When turned on it will be able to receive IPv6 traffic`
  String get ipv6Desc {
    return Intl.message(
      'When turned on it will be able to receive IPv6 traffic',
      name: 'ipv6Desc',
      desc: '',
      args: [],
    );
  }

  /// `App`
  String get app {
    return Intl.message('App', name: 'app', desc: '', args: []);
  }

  /// `General`
  String get general {
    return Intl.message('General', name: 'general', desc: '', args: []);
  }

  /// `Attach HTTP proxy to VpnService`
  String get vpnSystemProxyDesc {
    return Intl.message(
      'Attach HTTP proxy to VpnService',
      name: 'vpnSystemProxyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Attach HTTP proxy to VpnService`
  String get systemProxyDesc {
    return Intl.message(
      'Attach HTTP proxy to VpnService',
      name: 'systemProxyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Unified delay`
  String get unifiedDelay {
    return Intl.message(
      'Unified delay',
      name: 'unifiedDelay',
      desc: '',
      args: [],
    );
  }

  /// `Remove extra delays such as handshaking`
  String get unifiedDelayDesc {
    return Intl.message(
      'Remove extra delays such as handshaking',
      name: 'unifiedDelayDesc',
      desc: '',
      args: [],
    );
  }

  /// `TCP concurrent`
  String get tcpConcurrent {
    return Intl.message(
      'TCP concurrent',
      name: 'tcpConcurrent',
      desc: '',
      args: [],
    );
  }

  /// `Enabling it will allow TCP concurrency`
  String get tcpConcurrentDesc {
    return Intl.message(
      'Enabling it will allow TCP concurrency',
      name: 'tcpConcurrentDesc',
      desc: '',
      args: [],
    );
  }

  /// `Geo Low Memory Mode`
  String get geodataLoader {
    return Intl.message(
      'Geo Low Memory Mode',
      name: 'geodataLoader',
      desc: '',
      args: [],
    );
  }

  /// `Enabling will use the Geo low memory loader`
  String get geodataLoaderDesc {
    return Intl.message(
      'Enabling will use the Geo low memory loader',
      name: 'geodataLoaderDesc',
      desc: '',
      args: [],
    );
  }

  /// `Requests`
  String get requests {
    return Intl.message('Requests', name: 'requests', desc: '', args: []);
  }

  /// `View recently request records`
  String get requestsDesc {
    return Intl.message(
      'View recently request records',
      name: 'requestsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Find process`
  String get findProcessMode {
    return Intl.message(
      'Find process',
      name: 'findProcessMode',
      desc: '',
      args: [],
    );
  }

  /// `Init`
  String get init {
    return Intl.message('Init', name: 'init', desc: '', args: []);
  }

  /// `Long term effective`
  String get infiniteTime {
    return Intl.message(
      'Long term effective',
      name: 'infiniteTime',
      desc: '',
      args: [],
    );
  }

  /// `Expiration time`
  String get expirationTime {
    return Intl.message(
      'Expiration time',
      name: 'expirationTime',
      desc: '',
      args: [],
    );
  }

  /// `Connections`
  String get connections {
    return Intl.message('Connections', name: 'connections', desc: '', args: []);
  }

  /// `View current connections data`
  String get connectionsDesc {
    return Intl.message(
      'View current connections data',
      name: 'connectionsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Intranet IP`
  String get intranetIP {
    return Intl.message('Intranet IP', name: 'intranetIP', desc: '', args: []);
  }

  /// `View`
  String get view {
    return Intl.message('View', name: 'view', desc: '', args: []);
  }

  /// `Cut`
  String get cut {
    return Intl.message('Cut', name: 'cut', desc: '', args: []);
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `Paste`
  String get paste {
    return Intl.message('Paste', name: 'paste', desc: '', args: []);
  }

  /// `Test url`
  String get testUrl {
    return Intl.message('Test url', name: 'testUrl', desc: '', args: []);
  }

  /// `Sync`
  String get sync {
    return Intl.message('Sync', name: 'sync', desc: '', args: []);
  }

  /// `Hidden from recent tasks`
  String get exclude {
    return Intl.message(
      'Hidden from recent tasks',
      name: 'exclude',
      desc: '',
      args: [],
    );
  }

  /// `When the app is in the background, the app is hidden from the recent task`
  String get excludeDesc {
    return Intl.message(
      'When the app is in the background, the app is hidden from the recent task',
      name: 'excludeDesc',
      desc: '',
      args: [],
    );
  }

  /// `One column`
  String get oneColumn {
    return Intl.message('One column', name: 'oneColumn', desc: '', args: []);
  }

  /// `Two columns`
  String get twoColumns {
    return Intl.message('Two columns', name: 'twoColumns', desc: '', args: []);
  }

  /// `Three columns`
  String get threeColumns {
    return Intl.message(
      'Three columns',
      name: 'threeColumns',
      desc: '',
      args: [],
    );
  }

  /// `Four columns`
  String get fourColumns {
    return Intl.message(
      'Four columns',
      name: 'fourColumns',
      desc: '',
      args: [],
    );
  }

  /// `Standard`
  String get expand {
    return Intl.message('Standard', name: 'expand', desc: '', args: []);
  }

  /// `Shrink`
  String get shrink {
    return Intl.message('Shrink', name: 'shrink', desc: '', args: []);
  }

  /// `Min`
  String get min {
    return Intl.message('Min', name: 'min', desc: '', args: []);
  }

  /// `Tab`
  String get tab {
    return Intl.message('Tab', name: 'tab', desc: '', args: []);
  }

  /// `List`
  String get list {
    return Intl.message('List', name: 'list', desc: '', args: []);
  }

  /// `Delay`
  String get delay {
    return Intl.message('Delay', name: 'delay', desc: '', args: []);
  }

  /// `Style`
  String get style {
    return Intl.message('Style', name: 'style', desc: '', args: []);
  }

  /// `Size`
  String get size {
    return Intl.message('Size', name: 'size', desc: '', args: []);
  }

  /// `Sort`
  String get sort {
    return Intl.message('Sort', name: 'sort', desc: '', args: []);
  }

  /// `Columns`
  String get columns {
    return Intl.message('Columns', name: 'columns', desc: '', args: []);
  }

  /// `Proxies setting`
  String get proxiesSetting {
    return Intl.message(
      'Proxies setting',
      name: 'proxiesSetting',
      desc: '',
      args: [],
    );
  }

  /// `Proxy group`
  String get proxyGroup {
    return Intl.message('Proxy group', name: 'proxyGroup', desc: '', args: []);
  }

  /// `Go`
  String get go {
    return Intl.message('Go', name: 'go', desc: '', args: []);
  }

  /// `External link`
  String get externalLink {
    return Intl.message(
      'External link',
      name: 'externalLink',
      desc: '',
      args: [],
    );
  }

  /// `Other contributors`
  String get otherContributors {
    return Intl.message(
      'Other contributors',
      name: 'otherContributors',
      desc: '',
      args: [],
    );
  }

  /// `Auto close connections`
  String get autoCloseConnections {
    return Intl.message(
      'Auto close connections',
      name: 'autoCloseConnections',
      desc: '',
      args: [],
    );
  }

  /// `Auto close connections after change node`
  String get autoCloseConnectionsDesc {
    return Intl.message(
      'Auto close connections after change node',
      name: 'autoCloseConnectionsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Only statistics proxy`
  String get onlyStatisticsProxy {
    return Intl.message(
      'Only statistics proxy',
      name: 'onlyStatisticsProxy',
      desc: '',
      args: [],
    );
  }

  /// `When turned on, only statistics proxy traffic`
  String get onlyStatisticsProxyDesc {
    return Intl.message(
      'When turned on, only statistics proxy traffic',
      name: 'onlyStatisticsProxyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Pure black mode`
  String get pureBlackMode {
    return Intl.message(
      'Pure black mode',
      name: 'pureBlackMode',
      desc: '',
      args: [],
    );
  }

  /// `Tcp keep alive interval`
  String get keepAliveIntervalDesc {
    return Intl.message(
      'Tcp keep alive interval',
      name: 'keepAliveIntervalDesc',
      desc: '',
      args: [],
    );
  }

  /// ` entries`
  String get entries {
    return Intl.message(' entries', name: 'entries', desc: '', args: []);
  }

  /// `Local`
  String get local {
    return Intl.message('Local', name: 'local', desc: '', args: []);
  }

  /// `Remote`
  String get remote {
    return Intl.message('Remote', name: 'remote', desc: '', args: []);
  }

  /// `Backup local data to WebDAV`
  String get remoteBackupDesc {
    return Intl.message(
      'Backup local data to WebDAV',
      name: 'remoteBackupDesc',
      desc: '',
      args: [],
    );
  }

  /// `Backup local data to local`
  String get localBackupDesc {
    return Intl.message(
      'Backup local data to local',
      name: 'localBackupDesc',
      desc: '',
      args: [],
    );
  }

  /// `Mode`
  String get mode {
    return Intl.message('Mode', name: 'mode', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Source`
  String get source {
    return Intl.message('Source', name: 'source', desc: '', args: []);
  }

  /// `All apps`
  String get allApps {
    return Intl.message('All apps', name: 'allApps', desc: '', args: []);
  }

  /// `Only third-party apps`
  String get onlyOtherApps {
    return Intl.message(
      'Only third-party apps',
      name: 'onlyOtherApps',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get action {
    return Intl.message('Action', name: 'action', desc: '', args: []);
  }

  /// `Intelligent selection`
  String get intelligentSelected {
    return Intl.message(
      'Intelligent selection',
      name: 'intelligentSelected',
      desc: '',
      args: [],
    );
  }

  /// `Clipboard import`
  String get clipboardImport {
    return Intl.message(
      'Clipboard import',
      name: 'clipboardImport',
      desc: '',
      args: [],
    );
  }

  /// `Export clipboard`
  String get clipboardExport {
    return Intl.message(
      'Export clipboard',
      name: 'clipboardExport',
      desc: '',
      args: [],
    );
  }

  /// `Layout`
  String get layout {
    return Intl.message('Layout', name: 'layout', desc: '', args: []);
  }

  /// `Tight`
  String get tight {
    return Intl.message('Tight', name: 'tight', desc: '', args: []);
  }

  /// `Standard`
  String get standard {
    return Intl.message('Standard', name: 'standard', desc: '', args: []);
  }

  /// `Loose`
  String get loose {
    return Intl.message('Loose', name: 'loose', desc: '', args: []);
  }

  /// `Profiles sort`
  String get profilesSort {
    return Intl.message(
      'Profiles sort',
      name: 'profilesSort',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Stop`
  String get stop {
    return Intl.message('Stop', name: 'stop', desc: '', args: []);
  }

  /// `Processing app related settings`
  String get appDesc {
    return Intl.message(
      'Processing app related settings',
      name: 'appDesc',
      desc: '',
      args: [],
    );
  }

  /// `Modify VPN related settings`
  String get vpnDesc {
    return Intl.message(
      'Modify VPN related settings',
      name: 'vpnDesc',
      desc: '',
      args: [],
    );
  }

  /// `Update DNS related settings`
  String get dnsDesc {
    return Intl.message(
      'Update DNS related settings',
      name: 'dnsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Key`
  String get key {
    return Intl.message('Key', name: 'key', desc: '', args: []);
  }

  /// `Value`
  String get value {
    return Intl.message('Value', name: 'value', desc: '', args: []);
  }

  /// `Add Hosts`
  String get hostsDesc {
    return Intl.message('Add Hosts', name: 'hostsDesc', desc: '', args: []);
  }

  /// `Changes take effect after restarting the VPN`
  String get vpnTip {
    return Intl.message(
      'Changes take effect after restarting the VPN',
      name: 'vpnTip',
      desc: '',
      args: [],
    );
  }

  /// `Auto routes all system traffic through VpnService`
  String get vpnEnableDesc {
    return Intl.message(
      'Auto routes all system traffic through VpnService',
      name: 'vpnEnableDesc',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message('Options', name: 'options', desc: '', args: []);
  }

  /// `Loopback unlock tool`
  String get loopback {
    return Intl.message(
      'Loopback unlock tool',
      name: 'loopback',
      desc: '',
      args: [],
    );
  }

  /// `Used for UWP loopback unlocking`
  String get loopbackDesc {
    return Intl.message(
      'Used for UWP loopback unlocking',
      name: 'loopbackDesc',
      desc: '',
      args: [],
    );
  }

  /// `Providers`
  String get providers {
    return Intl.message('Providers', name: 'providers', desc: '', args: []);
  }

  /// `Proxy providers`
  String get proxyProviders {
    return Intl.message(
      'Proxy providers',
      name: 'proxyProviders',
      desc: '',
      args: [],
    );
  }

  /// `Rule providers`
  String get ruleProviders {
    return Intl.message(
      'Rule providers',
      name: 'ruleProviders',
      desc: '',
      args: [],
    );
  }

  /// `Override Dns`
  String get overrideDns {
    return Intl.message(
      'Override Dns',
      name: 'overrideDns',
      desc: '',
      args: [],
    );
  }

  /// `Turning it on will override the DNS options in the profile`
  String get overrideDnsDesc {
    return Intl.message(
      'Turning it on will override the DNS options in the profile',
      name: 'overrideDnsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `System DNS will be used when turned off`
  String get statusDesc {
    return Intl.message(
      'System DNS will be used when turned off',
      name: 'statusDesc',
      desc: '',
      args: [],
    );
  }

  /// `Prioritize the use of DOH's http/3`
  String get preferH3Desc {
    return Intl.message(
      'Prioritize the use of DOH\'s http/3',
      name: 'preferH3Desc',
      desc: '',
      args: [],
    );
  }

  /// `Respect rules`
  String get respectRules {
    return Intl.message(
      'Respect rules',
      name: 'respectRules',
      desc: '',
      args: [],
    );
  }

  /// `DNS connection following rules, need to configure proxy-server-nameserver`
  String get respectRulesDesc {
    return Intl.message(
      'DNS connection following rules, need to configure proxy-server-nameserver',
      name: 'respectRulesDesc',
      desc: '',
      args: [],
    );
  }

  /// `DNS mode`
  String get dnsMode {
    return Intl.message('DNS mode', name: 'dnsMode', desc: '', args: []);
  }

  /// `Fakeip range`
  String get fakeipRange {
    return Intl.message(
      'Fakeip range',
      name: 'fakeipRange',
      desc: '',
      args: [],
    );
  }

  /// `Fakeip filter`
  String get fakeipFilter {
    return Intl.message(
      'Fakeip filter',
      name: 'fakeipFilter',
      desc: '',
      args: [],
    );
  }

  /// `Default nameserver`
  String get defaultNameserver {
    return Intl.message(
      'Default nameserver',
      name: 'defaultNameserver',
      desc: '',
      args: [],
    );
  }

  /// `For resolving DNS server`
  String get defaultNameserverDesc {
    return Intl.message(
      'For resolving DNS server',
      name: 'defaultNameserverDesc',
      desc: '',
      args: [],
    );
  }

  /// `Nameserver`
  String get nameserver {
    return Intl.message('Nameserver', name: 'nameserver', desc: '', args: []);
  }

  /// `For resolving domain`
  String get nameserverDesc {
    return Intl.message(
      'For resolving domain',
      name: 'nameserverDesc',
      desc: '',
      args: [],
    );
  }

  /// `Use hosts`
  String get useHosts {
    return Intl.message('Use hosts', name: 'useHosts', desc: '', args: []);
  }

  /// `Use system hosts`
  String get useSystemHosts {
    return Intl.message(
      'Use system hosts',
      name: 'useSystemHosts',
      desc: '',
      args: [],
    );
  }

  /// `Nameserver policy`
  String get nameserverPolicy {
    return Intl.message(
      'Nameserver policy',
      name: 'nameserverPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Specify the corresponding nameserver policy`
  String get nameserverPolicyDesc {
    return Intl.message(
      'Specify the corresponding nameserver policy',
      name: 'nameserverPolicyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Proxy nameserver`
  String get proxyNameserver {
    return Intl.message(
      'Proxy nameserver',
      name: 'proxyNameserver',
      desc: '',
      args: [],
    );
  }

  /// `Domain for resolving proxy nodes`
  String get proxyNameserverDesc {
    return Intl.message(
      'Domain for resolving proxy nodes',
      name: 'proxyNameserverDesc',
      desc: '',
      args: [],
    );
  }

  /// `Fallback`
  String get fallback {
    return Intl.message('Fallback', name: 'fallback', desc: '', args: []);
  }

  /// `Generally use offshore DNS`
  String get fallbackDesc {
    return Intl.message(
      'Generally use offshore DNS',
      name: 'fallbackDesc',
      desc: '',
      args: [],
    );
  }

  /// `Fallback filter`
  String get fallbackFilter {
    return Intl.message(
      'Fallback filter',
      name: 'fallbackFilter',
      desc: '',
      args: [],
    );
  }

  /// `Geoip code`
  String get geoipCode {
    return Intl.message('Geoip code', name: 'geoipCode', desc: '', args: []);
  }

  /// `Ipcidr`
  String get ipcidr {
    return Intl.message('Ipcidr', name: 'ipcidr', desc: '', args: []);
  }

  /// `Domain`
  String get domain {
    return Intl.message('Domain', name: 'domain', desc: '', args: []);
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Show/Hide`
  String get action_view {
    return Intl.message('Show/Hide', name: 'action_view', desc: '', args: []);
  }

  /// `Start/Stop`
  String get action_start {
    return Intl.message('Start/Stop', name: 'action_start', desc: '', args: []);
  }

  /// `Switch mode`
  String get action_mode {
    return Intl.message('Switch mode', name: 'action_mode', desc: '', args: []);
  }

  /// `System proxy`
  String get action_proxy {
    return Intl.message(
      'System proxy',
      name: 'action_proxy',
      desc: '',
      args: [],
    );
  }

  /// `TUN`
  String get action_tun {
    return Intl.message('TUN', name: 'action_tun', desc: '', args: []);
  }

  /// `Disclaimer`
  String get disclaimer {
    return Intl.message('Disclaimer', name: 'disclaimer', desc: '', args: []);
  }

  /// `This software is only used for non-commercial purposes such as learning exchanges and scientific research. It is strictly prohibited to use this software for commercial purposes. Any commercial activity, if any, has nothing to do with this software.`
  String get disclaimerDesc {
    return Intl.message(
      'This software is only used for non-commercial purposes such as learning exchanges and scientific research. It is strictly prohibited to use this software for commercial purposes. Any commercial activity, if any, has nothing to do with this software.',
      name: 'disclaimerDesc',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get agree {
    return Intl.message('Agree', name: 'agree', desc: '', args: []);
  }

  /// `Hotkey Management`
  String get hotkeyManagement {
    return Intl.message(
      'Hotkey Management',
      name: 'hotkeyManagement',
      desc: '',
      args: [],
    );
  }

  /// `Use keyboard to control applications`
  String get hotkeyManagementDesc {
    return Intl.message(
      'Use keyboard to control applications',
      name: 'hotkeyManagementDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please press the keyboard.`
  String get pressKeyboard {
    return Intl.message(
      'Please press the keyboard.',
      name: 'pressKeyboard',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the correct hotkey`
  String get inputCorrectHotkey {
    return Intl.message(
      'Please enter the correct hotkey',
      name: 'inputCorrectHotkey',
      desc: '',
      args: [],
    );
  }

  /// `Hotkey conflict`
  String get hotkeyConflict {
    return Intl.message(
      'Hotkey conflict',
      name: 'hotkeyConflict',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `No HotKey`
  String get noHotKey {
    return Intl.message('No HotKey', name: 'noHotKey', desc: '', args: []);
  }

  /// `No network`
  String get noNetwork {
    return Intl.message('No network', name: 'noNetwork', desc: '', args: []);
  }

  /// `Allow IPv6 inbound`
  String get ipv6InboundDesc {
    return Intl.message(
      'Allow IPv6 inbound',
      name: 'ipv6InboundDesc',
      desc: '',
      args: [],
    );
  }

  /// `Export logs`
  String get exportLogs {
    return Intl.message('Export logs', name: 'exportLogs', desc: '', args: []);
  }

  /// `Export Success`
  String get exportSuccess {
    return Intl.message(
      'Export Success',
      name: 'exportSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Icon style`
  String get iconStyle {
    return Intl.message('Icon style', name: 'iconStyle', desc: '', args: []);
  }

  /// `Icon`
  String get onlyIcon {
    return Intl.message('Icon', name: 'onlyIcon', desc: '', args: []);
  }

  /// `None`
  String get noIcon {
    return Intl.message('None', name: 'noIcon', desc: '', args: []);
  }

  /// `Stack mode`
  String get stackMode {
    return Intl.message('Stack mode', name: 'stackMode', desc: '', args: []);
  }

  /// `Network`
  String get network {
    return Intl.message('Network', name: 'network', desc: '', args: []);
  }

  /// `Modify network-related settings`
  String get networkDesc {
    return Intl.message(
      'Modify network-related settings',
      name: 'networkDesc',
      desc: '',
      args: [],
    );
  }

  /// `Bypass domain`
  String get bypassDomain {
    return Intl.message(
      'Bypass domain',
      name: 'bypassDomain',
      desc: '',
      args: [],
    );
  }

  /// `Only takes effect when the system proxy is enabled`
  String get bypassDomainDesc {
    return Intl.message(
      'Only takes effect when the system proxy is enabled',
      name: 'bypassDomainDesc',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to reset`
  String get resetTip {
    return Intl.message(
      'Make sure to reset',
      name: 'resetTip',
      desc: '',
      args: [],
    );
  }

  /// `RegExp`
  String get regExp {
    return Intl.message('RegExp', name: 'regExp', desc: '', args: []);
  }

  /// `Icon`
  String get icon {
    return Intl.message('Icon', name: 'icon', desc: '', args: []);
  }

  /// `Icon configuration`
  String get iconConfiguration {
    return Intl.message(
      'Icon configuration',
      name: 'iconConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get noData {
    return Intl.message('No data', name: 'noData', desc: '', args: []);
  }

  /// `Admin auto launch`
  String get adminAutoLaunch {
    return Intl.message(
      'Admin auto launch',
      name: 'adminAutoLaunch',
      desc: '',
      args: [],
    );
  }

  /// `Boot up by using admin mode`
  String get adminAutoLaunchDesc {
    return Intl.message(
      'Boot up by using admin mode',
      name: 'adminAutoLaunchDesc',
      desc: '',
      args: [],
    );
  }

  /// `FontFamily`
  String get fontFamily {
    return Intl.message('FontFamily', name: 'fontFamily', desc: '', args: []);
  }

  /// `System font`
  String get systemFont {
    return Intl.message('System font', name: 'systemFont', desc: '', args: []);
  }

  /// `Toggle`
  String get toggle {
    return Intl.message('Toggle', name: 'toggle', desc: '', args: []);
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Route mode`
  String get routeMode {
    return Intl.message('Route mode', name: 'routeMode', desc: '', args: []);
  }

  /// `Bypass private route address`
  String get routeMode_bypassPrivate {
    return Intl.message(
      'Bypass private route address',
      name: 'routeMode_bypassPrivate',
      desc: '',
      args: [],
    );
  }

  /// `Use config`
  String get routeMode_config {
    return Intl.message(
      'Use config',
      name: 'routeMode_config',
      desc: '',
      args: [],
    );
  }

  /// `Route address`
  String get routeAddress {
    return Intl.message(
      'Route address',
      name: 'routeAddress',
      desc: '',
      args: [],
    );
  }

  /// `Config listen route address`
  String get routeAddressDesc {
    return Intl.message(
      'Config listen route address',
      name: 'routeAddressDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the admin password`
  String get pleaseInputAdminPassword {
    return Intl.message(
      'Please enter the admin password',
      name: 'pleaseInputAdminPassword',
      desc: '',
      args: [],
    );
  }

  /// `Copying environment variables`
  String get copyEnvVar {
    return Intl.message(
      'Copying environment variables',
      name: 'copyEnvVar',
      desc: '',
      args: [],
    );
  }

  /// `Memory info`
  String get memoryInfo {
    return Intl.message('Memory info', name: 'memoryInfo', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `The file has been modified. Do you want to save the changes?`
  String get fileIsUpdate {
    return Intl.message(
      'The file has been modified. Do you want to save the changes?',
      name: 'fileIsUpdate',
      desc: '',
      args: [],
    );
  }

  /// `The profile has been modified. Do you want to disable auto update?`
  String get profileHasUpdate {
    return Intl.message(
      'The profile has been modified. Do you want to disable auto update?',
      name: 'profileHasUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to cache the changes?`
  String get hasCacheChange {
    return Intl.message(
      'Do you want to cache the changes?',
      name: 'hasCacheChange',
      desc: '',
      args: [],
    );
  }

  /// `Copy success`
  String get copySuccess {
    return Intl.message(
      'Copy success',
      name: 'copySuccess',
      desc: '',
      args: [],
    );
  }

  /// `Copy link`
  String get copyLink {
    return Intl.message('Copy link', name: 'copyLink', desc: '', args: []);
  }

  /// `Export file`
  String get exportFile {
    return Intl.message('Export file', name: 'exportFile', desc: '', args: []);
  }

  /// `The cache is corrupt. Do you want to clear it?`
  String get cacheCorrupt {
    return Intl.message(
      'The cache is corrupt. Do you want to clear it?',
      name: 'cacheCorrupt',
      desc: '',
      args: [],
    );
  }

  /// `Relying on third-party api is for reference only`
  String get detectionTip {
    return Intl.message(
      'Relying on third-party api is for reference only',
      name: 'detectionTip',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get listen {
    return Intl.message('Listen', name: 'listen', desc: '', args: []);
  }

  /// `undo`
  String get undo {
    return Intl.message('undo', name: 'undo', desc: '', args: []);
  }

  /// `redo`
  String get redo {
    return Intl.message('redo', name: 'redo', desc: '', args: []);
  }

  /// `none`
  String get none {
    return Intl.message('none', name: 'none', desc: '', args: []);
  }

  /// `Basic configuration`
  String get basicConfig {
    return Intl.message(
      'Basic configuration',
      name: 'basicConfig',
      desc: '',
      args: [],
    );
  }

  /// `Modify the basic configuration globally`
  String get basicConfigDesc {
    return Intl.message(
      'Modify the basic configuration globally',
      name: 'basicConfigDesc',
      desc: '',
      args: [],
    );
  }

  /// `Advanced configuration`
  String get advancedConfig {
    return Intl.message(
      'Advanced configuration',
      name: 'advancedConfig',
      desc: '',
      args: [],
    );
  }

  /// `Provide diverse configuration options`
  String get advancedConfigDesc {
    return Intl.message(
      'Provide diverse configuration options',
      name: 'advancedConfigDesc',
      desc: '',
      args: [],
    );
  }

  /// `{count} items have been selected`
  String selectedCountTitle(Object count) {
    return Intl.message(
      '$count items have been selected',
      name: 'selectedCountTitle',
      desc: '',
      args: [count],
    );
  }

  /// `Add rule`
  String get addRule {
    return Intl.message('Add rule', name: 'addRule', desc: '', args: []);
  }

  /// `Rule name`
  String get ruleName {
    return Intl.message('Rule name', name: 'ruleName', desc: '', args: []);
  }

  /// `Content`
  String get content {
    return Intl.message('Content', name: 'content', desc: '', args: []);
  }

  /// `Sub rule`
  String get subRule {
    return Intl.message('Sub rule', name: 'subRule', desc: '', args: []);
  }

  /// `Rule target`
  String get ruleTarget {
    return Intl.message('Rule target', name: 'ruleTarget', desc: '', args: []);
  }

  /// `Source IP`
  String get sourceIp {
    return Intl.message('Source IP', name: 'sourceIp', desc: '', args: []);
  }

  /// `No resolve IP`
  String get noResolve {
    return Intl.message('No resolve IP', name: 'noResolve', desc: '', args: []);
  }

  /// `Get original rules`
  String get getOriginRules {
    return Intl.message(
      'Get original rules',
      name: 'getOriginRules',
      desc: '',
      args: [],
    );
  }

  /// `Override the original rule`
  String get overrideOriginRules {
    return Intl.message(
      'Override the original rule',
      name: 'overrideOriginRules',
      desc: '',
      args: [],
    );
  }

  /// `Attach on the original rules`
  String get addedOriginRules {
    return Intl.message(
      'Attach on the original rules',
      name: 'addedOriginRules',
      desc: '',
      args: [],
    );
  }

  /// `Enable override`
  String get enableOverride {
    return Intl.message(
      'Enable override',
      name: 'enableOverride',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to save the changes?`
  String get saveChanges {
    return Intl.message(
      'Do you want to save the changes?',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Modify general settings`
  String get generalDesc {
    return Intl.message(
      'Modify general settings',
      name: 'generalDesc',
      desc: '',
      args: [],
    );
  }

  /// `There is a certain performance loss after opening`
  String get findProcessModeDesc {
    return Intl.message(
      'There is a certain performance loss after opening',
      name: 'findProcessModeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Effective only in mobile view`
  String get tabAnimationDesc {
    return Intl.message(
      'Effective only in mobile view',
      name: 'tabAnimationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to save?`
  String get saveTip {
    return Intl.message(
      'Are you sure you want to save?',
      name: 'saveTip',
      desc: '',
      args: [],
    );
  }

  /// `Color schemes`
  String get colorSchemes {
    return Intl.message(
      'Color schemes',
      name: 'colorSchemes',
      desc: '',
      args: [],
    );
  }

  /// `Palette`
  String get palette {
    return Intl.message('Palette', name: 'palette', desc: '', args: []);
  }

  /// `TonalSpot`
  String get tonalSpotScheme {
    return Intl.message(
      'TonalSpot',
      name: 'tonalSpotScheme',
      desc: '',
      args: [],
    );
  }

  /// `Fidelity`
  String get fidelityScheme {
    return Intl.message('Fidelity', name: 'fidelityScheme', desc: '', args: []);
  }

  /// `Monochrome`
  String get monochromeScheme {
    return Intl.message(
      'Monochrome',
      name: 'monochromeScheme',
      desc: '',
      args: [],
    );
  }

  /// `Neutral`
  String get neutralScheme {
    return Intl.message('Neutral', name: 'neutralScheme', desc: '', args: []);
  }

  /// `Vibrant`
  String get vibrantScheme {
    return Intl.message('Vibrant', name: 'vibrantScheme', desc: '', args: []);
  }

  /// `Expressive`
  String get expressiveScheme {
    return Intl.message(
      'Expressive',
      name: 'expressiveScheme',
      desc: '',
      args: [],
    );
  }

  /// `Content`
  String get contentScheme {
    return Intl.message('Content', name: 'contentScheme', desc: '', args: []);
  }

  /// `Rainbow`
  String get rainbowScheme {
    return Intl.message('Rainbow', name: 'rainbowScheme', desc: '', args: []);
  }

  /// `FruitSalad`
  String get fruitSaladScheme {
    return Intl.message(
      'FruitSalad',
      name: 'fruitSaladScheme',
      desc: '',
      args: [],
    );
  }

  /// `Developer mode`
  String get developerMode {
    return Intl.message(
      'Developer mode',
      name: 'developerMode',
      desc: '',
      args: [],
    );
  }

  /// `Developer mode is enabled.`
  String get developerModeEnableTip {
    return Intl.message(
      'Developer mode is enabled.',
      name: 'developerModeEnableTip',
      desc: '',
      args: [],
    );
  }

  /// `Message test`
  String get messageTest {
    return Intl.message(
      'Message test',
      name: 'messageTest',
      desc: '',
      args: [],
    );
  }

  /// `This is a message.`
  String get messageTestTip {
    return Intl.message(
      'This is a message.',
      name: 'messageTestTip',
      desc: '',
      args: [],
    );
  }

  /// `Crash test`
  String get crashTest {
    return Intl.message('Crash test', name: 'crashTest', desc: '', args: []);
  }

  /// `Clear Data`
  String get clearData {
    return Intl.message('Clear Data', name: 'clearData', desc: '', args: []);
  }

  /// `Text Scaling`
  String get textScale {
    return Intl.message('Text Scaling', name: 'textScale', desc: '', args: []);
  }

  /// `Internet`
  String get internet {
    return Intl.message('Internet', name: 'internet', desc: '', args: []);
  }

  /// `System APP`
  String get systemApp {
    return Intl.message('System APP', name: 'systemApp', desc: '', args: []);
  }

  /// `No network APP`
  String get noNetworkApp {
    return Intl.message(
      'No network APP',
      name: 'noNetworkApp',
      desc: '',
      args: [],
    );
  }

  /// `Contact me`
  String get contactMe {
    return Intl.message('Contact me', name: 'contactMe', desc: '', args: []);
  }

  /// `Restore strategy`
  String get restoreStrategy {
    return Intl.message(
      'Restore strategy',
      name: 'restoreStrategy',
      desc: '',
      args: [],
    );
  }

  /// `Override`
  String get restoreStrategy_override {
    return Intl.message(
      'Override',
      name: 'restoreStrategy_override',
      desc: '',
      args: [],
    );
  }

  /// `Compatible`
  String get restoreStrategy_compatible {
    return Intl.message(
      'Compatible',
      name: 'restoreStrategy_compatible',
      desc: '',
      args: [],
    );
  }

  /// `Logs test`
  String get logsTest {
    return Intl.message('Logs test', name: 'logsTest', desc: '', args: []);
  }

  /// `{label} cannot be empty`
  String emptyTip(Object label) {
    return Intl.message(
      '$label cannot be empty',
      name: 'emptyTip',
      desc: '',
      args: [label],
    );
  }

  /// `{label} must be a url`
  String urlTip(Object label) {
    return Intl.message(
      '$label must be a url',
      name: 'urlTip',
      desc: '',
      args: [label],
    );
  }

  /// `{label} must be a number`
  String numberTip(Object label) {
    return Intl.message(
      '$label must be a number',
      name: 'numberTip',
      desc: '',
      args: [label],
    );
  }

  /// `Interval`
  String get interval {
    return Intl.message('Interval', name: 'interval', desc: '', args: []);
  }

  /// `Current {label} already exists`
  String existsTip(Object label) {
    return Intl.message(
      'Current $label already exists',
      name: 'existsTip',
      desc: '',
      args: [label],
    );
  }

  /// `Are you sure you want to delete the current {label}?`
  String deleteTip(Object label) {
    return Intl.message(
      'Are you sure you want to delete the current $label?',
      name: 'deleteTip',
      desc: '',
      args: [label],
    );
  }

  /// `Are you sure you want to delete the selected {label}?`
  String deleteMultipTip(Object label) {
    return Intl.message(
      'Are you sure you want to delete the selected $label?',
      name: 'deleteMultipTip',
      desc: '',
      args: [label],
    );
  }

  /// `No {label} yet`
  String nullTip(Object label) {
    return Intl.message(
      'No $label yet',
      name: 'nullTip',
      desc: '',
      args: [label],
    );
  }

  /// `Script`
  String get script {
    return Intl.message('Script', name: 'script', desc: '', args: []);
  }

  /// `Color`
  String get color {
    return Intl.message('Color', name: 'color', desc: '', args: []);
  }

  /// `Rename`
  String get rename {
    return Intl.message('Rename', name: 'rename', desc: '', args: []);
  }

  /// `Unnamed`
  String get unnamed {
    return Intl.message('Unnamed', name: 'unnamed', desc: '', args: []);
  }

  /// `Please enter a script name`
  String get pleaseEnterScriptName {
    return Intl.message(
      'Please enter a script name',
      name: 'pleaseEnterScriptName',
      desc: '',
      args: [],
    );
  }

  /// `Does not take effect in script mode`
  String get overrideInvalidTip {
    return Intl.message(
      'Does not take effect in script mode',
      name: 'overrideInvalidTip',
      desc: '',
      args: [],
    );
  }

  /// `Mixed Port`
  String get mixedPort {
    return Intl.message('Mixed Port', name: 'mixedPort', desc: '', args: []);
  }

  /// `Socks Port`
  String get socksPort {
    return Intl.message('Socks Port', name: 'socksPort', desc: '', args: []);
  }

  /// `Redir Port`
  String get redirPort {
    return Intl.message('Redir Port', name: 'redirPort', desc: '', args: []);
  }

  /// `Tproxy Port`
  String get tproxyPort {
    return Intl.message('Tproxy Port', name: 'tproxyPort', desc: '', args: []);
  }

  /// `{label} must be between 1024 and 49151`
  String portTip(Object label) {
    return Intl.message(
      '$label must be between 1024 and 49151',
      name: 'portTip',
      desc: '',
      args: [label],
    );
  }

  /// `Please enter a different port`
  String get portConflictTip {
    return Intl.message(
      'Please enter a different port',
      name: 'portConflictTip',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get import {
    return Intl.message('Import', name: 'import', desc: '', args: []);
  }

  /// `Import from file`
  String get importFile {
    return Intl.message(
      'Import from file',
      name: 'importFile',
      desc: '',
      args: [],
    );
  }

  /// `Import from URL`
  String get importUrl {
    return Intl.message(
      'Import from URL',
      name: 'importUrl',
      desc: '',
      args: [],
    );
  }

  /// `Auto set system DNS`
  String get autoSetSystemDns {
    return Intl.message(
      'Auto set system DNS',
      name: 'autoSetSystemDns',
      desc: '',
      args: [],
    );
  }

  /// `{label} details`
  String details(Object label) {
    return Intl.message(
      '$label details',
      name: 'details',
      desc: '',
      args: [label],
    );
  }

  /// `Creation time`
  String get creationTime {
    return Intl.message(
      'Creation time',
      name: 'creationTime',
      desc: '',
      args: [],
    );
  }

  /// `Process`
  String get process {
    return Intl.message('Process', name: 'process', desc: '', args: []);
  }

  /// `Host`
  String get host {
    return Intl.message('Host', name: 'host', desc: '', args: []);
  }

  /// `Destination`
  String get destination {
    return Intl.message('Destination', name: 'destination', desc: '', args: []);
  }

  /// `Destination GeoIP`
  String get destinationGeoIP {
    return Intl.message(
      'Destination GeoIP',
      name: 'destinationGeoIP',
      desc: '',
      args: [],
    );
  }

  /// `Destination IPASN`
  String get destinationIPASN {
    return Intl.message(
      'Destination IPASN',
      name: 'destinationIPASN',
      desc: '',
      args: [],
    );
  }

  /// `Special proxy`
  String get specialProxy {
    return Intl.message(
      'Special proxy',
      name: 'specialProxy',
      desc: '',
      args: [],
    );
  }

  /// `special rules`
  String get specialRules {
    return Intl.message(
      'special rules',
      name: 'specialRules',
      desc: '',
      args: [],
    );
  }

  /// `Remote destination`
  String get remoteDestination {
    return Intl.message(
      'Remote destination',
      name: 'remoteDestination',
      desc: '',
      args: [],
    );
  }

  /// `Network type`
  String get networkType {
    return Intl.message(
      'Network type',
      name: 'networkType',
      desc: '',
      args: [],
    );
  }

  /// `Proxy chains`
  String get proxyChains {
    return Intl.message(
      'Proxy chains',
      name: 'proxyChains',
      desc: '',
      args: [],
    );
  }

  /// `Log`
  String get log {
    return Intl.message('Log', name: 'log', desc: '', args: []);
  }

  /// `Connection`
  String get connection {
    return Intl.message('Connection', name: 'connection', desc: '', args: []);
  }

  /// `Request`
  String get request {
    return Intl.message('Request', name: 'request', desc: '', args: []);
  }

  /// `Connected`
  String get connected {
    return Intl.message('Connected', name: 'connected', desc: '', args: []);
  }

  /// `Disconnected`
  String get disconnected {
    return Intl.message(
      'Disconnected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `Connecting...`
  String get connecting {
    return Intl.message(
      'Connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to restart the core?`
  String get restartCoreTip {
    return Intl.message(
      'Are you sure you want to restart the core?',
      name: 'restartCoreTip',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to force restart the core?`
  String get forceRestartCoreTip {
    return Intl.message(
      'Are you sure you want to force restart the core?',
      name: 'forceRestartCoreTip',
      desc: '',
      args: [],
    );
  }

  /// `DNS hijacking`
  String get dnsHijacking {
    return Intl.message(
      'DNS hijacking',
      name: 'dnsHijacking',
      desc: '',
      args: [],
    );
  }

  /// `Core status`
  String get coreStatus {
    return Intl.message('Core status', name: 'coreStatus', desc: '', args: []);
  }

  /// `Crash Analysis`
  String get crashlytics {
    return Intl.message(
      'Crash Analysis',
      name: 'crashlytics',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, automatically uploads crash logs without sensitive information when the app crashes`
  String get crashlyticsTip {
    return Intl.message(
      'When enabled, automatically uploads crash logs without sensitive information when the app crashes',
      name: 'crashlyticsTip',
      desc: '',
      args: [],
    );
  }

  /// `Append System DNS`
  String get appendSystemDns {
    return Intl.message(
      'Append System DNS',
      name: 'appendSystemDns',
      desc: '',
      args: [],
    );
  }

  /// `Forcefully append system DNS to the configuration`
  String get appendSystemDnsTip {
    return Intl.message(
      'Forcefully append system DNS to the configuration',
      name: 'appendSystemDnsTip',
      desc: '',
      args: [],
    );
  }

  /// `Edit rule`
  String get editRule {
    return Intl.message('Edit rule', name: 'editRule', desc: '', args: []);
  }

  /// `Override mode`
  String get overrideMode {
    return Intl.message(
      'Override mode',
      name: 'overrideMode',
      desc: '',
      args: [],
    );
  }

  /// `Standard mode, override basic configuration, provide simple rule addition capability`
  String get standardModeDesc {
    return Intl.message(
      'Standard mode, override basic configuration, provide simple rule addition capability',
      name: 'standardModeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Script mode, use external extension scripts, provide one-click override configuration capability`
  String get scriptModeDesc {
    return Intl.message(
      'Script mode, use external extension scripts, provide one-click override configuration capability',
      name: 'scriptModeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Added rules`
  String get addedRules {
    return Intl.message('Added rules', name: 'addedRules', desc: '', args: []);
  }

  /// `Control global added rules`
  String get controlGlobalAddedRules {
    return Intl.message(
      'Control global added rules',
      name: 'controlGlobalAddedRules',
      desc: '',
      args: [],
    );
  }

  /// `Override script`
  String get overrideScript {
    return Intl.message(
      'Override script',
      name: 'overrideScript',
      desc: '',
      args: [],
    );
  }

  /// `Go to configure script`
  String get goToConfigureScript {
    return Intl.message(
      'Go to configure script',
      name: 'goToConfigureScript',
      desc: '',
      args: [],
    );
  }

  /// `Edit global rules`
  String get editGlobalRules {
    return Intl.message(
      'Edit global rules',
      name: 'editGlobalRules',
      desc: '',
      args: [],
    );
  }

  /// `External fetch`
  String get externalFetch {
    return Intl.message(
      'External fetch',
      name: 'externalFetch',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to force crash the core?`
  String get confirmForceCrashCore {
    return Intl.message(
      'Are you sure you want to force crash the core?',
      name: 'confirmForceCrashCore',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear all data?`
  String get confirmClearAllData {
    return Intl.message(
      'Are you sure you want to clear all data?',
      name: 'confirmClearAllData',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Load test`
  String get loadTest {
    return Intl.message('Load test', name: 'loadTest', desc: '', args: []);
  }

  /// `{count, plural, =1{1 year ago} other{{count} years ago}}`
  String yearsAgo(num count) {
    return Intl.plural(
      count,
      one: '1 year ago',
      other: '$count years ago',
      name: 'yearsAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 month ago} other{{count} months ago}}`
  String monthsAgo(num count) {
    return Intl.plural(
      count,
      one: '1 month ago',
      other: '$count months ago',
      name: 'monthsAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 day ago} other{{count} days ago}}`
  String daysAgo(num count) {
    return Intl.plural(
      count,
      one: '1 day ago',
      other: '$count days ago',
      name: 'daysAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 hour ago} other{{count} hours ago}}`
  String hoursAgo(num count) {
    return Intl.plural(
      count,
      one: '1 hour ago',
      other: '$count hours ago',
      name: 'hoursAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 minute ago} other{{count} minutes ago}}`
  String minutesAgo(num count) {
    return Intl.plural(
      count,
      one: '1 minute ago',
      other: '$count minutes ago',
      name: 'minutesAgo',
      desc: '',
      args: [count],
    );
  }

  /// `Just now`
  String get justNow {
    return Intl.message('Just now', name: 'justNow', desc: '', args: []);
  }

  /// `Don't remind again`
  String get noLongerRemind {
    return Intl.message(
      'Don\'t remind again',
      name: 'noLongerRemind',
      desc: '',
      args: [],
    );
  }

  /// `Access Control Settings`
  String get accessControlSettings {
    return Intl.message(
      'Access Control Settings',
      name: 'accessControlSettings',
      desc: '',
      args: [],
    );
  }

  /// `Turn On`
  String get turnOn {
    return Intl.message('Turn On', name: 'turnOn', desc: '', args: []);
  }

  /// `Turn Off`
  String get turnOff {
    return Intl.message('Turn Off', name: 'turnOff', desc: '', args: []);
  }

  /// `Core configuration change detected`
  String get coreConfigChangeDetected {
    return Intl.message(
      'Core configuration change detected',
      name: 'coreConfigChangeDetected',
      desc: '',
      args: [],
    );
  }

  /// `Reload`
  String get reload {
    return Intl.message('Reload', name: 'reload', desc: '', args: []);
  }

  /// `VPN configuration change detected`
  String get vpnConfigChangeDetected {
    return Intl.message(
      'VPN configuration change detected',
      name: 'vpnConfigChangeDetected',
      desc: '',
      args: [],
    );
  }

  /// `Restart`
  String get restart {
    return Intl.message('Restart', name: 'restart', desc: '', args: []);
  }

  /// `Speed statistics`
  String get speedStatistics {
    return Intl.message(
      'Speed statistics',
      name: 'speedStatistics',
      desc: '',
      args: [],
    );
  }

  /// `The current page has changes. Are you sure you want to reset?`
  String get resetPageChangesTip {
    return Intl.message(
      'The current page has changes. Are you sure you want to reset?',
      name: 'resetPageChangesTip',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get overwriteTypeCustom {
    return Intl.message(
      'Custom',
      name: 'overwriteTypeCustom',
      desc: '',
      args: [],
    );
  }

  /// `Custom mode, fully customize proxy groups and rules`
  String get overwriteTypeCustomDesc {
    return Intl.message(
      'Custom mode, fully customize proxy groups and rules',
      name: 'overwriteTypeCustomDesc',
      desc: '',
      args: [],
    );
  }

  /// `Unknown network error`
  String get unknownNetworkError {
    return Intl.message(
      'Unknown network error',
      name: 'unknownNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `Network request exception, please try again later.`
  String get networkRequestException {
    return Intl.message(
      'Network request exception, please try again later.',
      name: 'networkRequestException',
      desc: '',
      args: [],
    );
  }

  /// `Recovery exception`
  String get restoreException {
    return Intl.message(
      'Recovery exception',
      name: 'restoreException',
      desc: '',
      args: [],
    );
  }

  /// `Network exception, please check your connection and try again`
  String get networkException {
    return Intl.message(
      'Network exception, please check your connection and try again',
      name: 'networkException',
      desc: '',
      args: [],
    );
  }

  /// `Invalid backup file`
  String get invalidBackupFile {
    return Intl.message(
      'Invalid backup file',
      name: 'invalidBackupFile',
      desc: '',
      args: [],
    );
  }

  /// `Prune cache`
  String get pruneCache {
    return Intl.message('Prune cache', name: 'pruneCache', desc: '', args: []);
  }

  /// `Backup and Restore`
  String get backupAndRestore {
    return Intl.message(
      'Backup and Restore',
      name: 'backupAndRestore',
      desc: '',
      args: [],
    );
  }

  /// `Sync data via WebDAV or files`
  String get backupAndRestoreDesc {
    return Intl.message(
      'Sync data via WebDAV or files',
      name: 'backupAndRestoreDesc',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get restore {
    return Intl.message('Restore', name: 'restore', desc: '', args: []);
  }

  /// `Restore success`
  String get restoreSuccess {
    return Intl.message(
      'Restore success',
      name: 'restoreSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Restore data via WebDAV`
  String get restoreFromWebDAVDesc {
    return Intl.message(
      'Restore data via WebDAV',
      name: 'restoreFromWebDAVDesc',
      desc: '',
      args: [],
    );
  }

  /// `Restore data via file`
  String get restoreFromFileDesc {
    return Intl.message(
      'Restore data via file',
      name: 'restoreFromFileDesc',
      desc: '',
      args: [],
    );
  }

  /// `Restore configuration files only`
  String get restoreOnlyConfig {
    return Intl.message(
      'Restore configuration files only',
      name: 'restoreOnlyConfig',
      desc: '',
      args: [],
    );
  }

  /// `Restore all data`
  String get restoreAllData {
    return Intl.message(
      'Restore all data',
      name: 'restoreAllData',
      desc: '',
      args: [],
    );
  }

  /// `Add Profile`
  String get addProfile {
    return Intl.message('Add Profile', name: 'addProfile', desc: '', args: []);
  }

  /// `Delay Test`
  String get delayTest {
    return Intl.message('Delay Test', name: 'delayTest', desc: '', args: []);
  }

  /// `Cannot open: {url}`
  String vAboutCannotOpen(Object url) {
    return Intl.message(
      'Cannot open: $url',
      name: 'vAboutCannotOpen',
      desc: '',
      args: [url],
    );
  }

  /// `Checking…`
  String get vAboutChecking {
    return Intl.message(
      'Checking…',
      name: 'vAboutChecking',
      desc: '',
      args: [],
    );
  }

  /// `Contact & Support`
  String get vAboutContactSection {
    return Intl.message(
      'Contact & Support',
      name: 'vAboutContactSection',
      desc: '',
      args: [],
    );
  }

  /// `Thanks to FlClash (chen08209), the Mihomo (Clash.Meta) team, the sing-box team, and the wider open-source networking community. Verstro's networking capabilities are built on these projects.`
  String get vAboutCreditsBody {
    return Intl.message(
      'Thanks to FlClash (chen08209), the Mihomo (Clash.Meta) team, the sing-box team, and the wider open-source networking community. Verstro\'s networking capabilities are built on these projects.',
      name: 'vAboutCreditsBody',
      desc: '',
      args: [],
    );
  }

  /// `Acknowledgements`
  String get vAboutCreditsSection {
    return Intl.message(
      'Acknowledgements',
      name: 'vAboutCreditsSection',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get vAboutEmail {
    return Intl.message('Email', name: 'vAboutEmail', desc: '', args: []);
  }

  /// `The Verstro client is derived from the open-source project FlClash (GPLv3), with Mihomo / sing-box cores (both GPLv3). In accordance with GPLv3, the complete source code of this client is publicly available.`
  String get vAboutOssBody {
    return Intl.message(
      'The Verstro client is derived from the open-source project FlClash (GPLv3), with Mihomo / sing-box cores (both GPLv3). In accordance with GPLv3, the complete source code of this client is publicly available.',
      name: 'vAboutOssBody',
      desc: '',
      args: [],
    );
  }

  /// `Open Source & Licenses`
  String get vAboutOssSection {
    return Intl.message(
      'Open Source & Licenses',
      name: 'vAboutOssSection',
      desc: '',
      args: [],
    );
  }

  /// `• Your email is used only for payment notices and password recovery — no marketing emails\n• We do not collect device IDs, location, or contacts\n• Traffic stats record usage volume only, never content\n• Payments are received on-chain via our own infrastructure, with no third-party custody`
  String get vAboutPrivacyBody {
    return Intl.message(
      '• Your email is used only for payment notices and password recovery — no marketing emails\n• We do not collect device IDs, location, or contacts\n• Traffic stats record usage volume only, never content\n• Payments are received on-chain via our own infrastructure, with no third-party custody',
      name: 'vAboutPrivacyBody',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Commitment`
  String get vAboutPrivacySection {
    return Intl.message(
      'Privacy Commitment',
      name: 'vAboutPrivacySection',
      desc: '',
      args: [],
    );
  }

  /// `Privacy-first global network`
  String get vAboutSlogan {
    return Intl.message(
      'Privacy-first global network',
      name: 'vAboutSlogan',
      desc: '',
      args: [],
    );
  }

  /// `Source Code & License`
  String get vAboutSourceCode {
    return Intl.message(
      'Source Code & License',
      name: 'vAboutSourceCode',
      desc: '',
      args: [],
    );
  }

  /// `Telegram Community`
  String get vAboutTelegramGroup {
    return Intl.message(
      'Telegram Community',
      name: 'vAboutTelegramGroup',
      desc: '',
      args: [],
    );
  }

  /// `About Verstro`
  String get vAboutTitle {
    return Intl.message(
      'About Verstro',
      name: 'vAboutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Visit Website`
  String get vAboutVisitWebsite {
    return Intl.message(
      'Visit Website',
      name: 'vAboutVisitWebsite',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get vAboutWebsiteSection {
    return Intl.message(
      'Website',
      name: 'vAboutWebsiteSection',
      desc: '',
      args: [],
    );
  }

  /// `Active {days} day(s) ago`
  String vAcctActiveDaysAgo(Object days) {
    return Intl.message(
      'Active $days day(s) ago',
      name: 'vAcctActiveDaysAgo',
      desc: '',
      args: [days],
    );
  }

  /// `Active {hours} hour(s) ago`
  String vAcctActiveHoursAgo(Object hours) {
    return Intl.message(
      'Active $hours hour(s) ago',
      name: 'vAcctActiveHoursAgo',
      desc: '',
      args: [hours],
    );
  }

  /// `Active just now`
  String get vAcctActiveJustNow {
    return Intl.message(
      'Active just now',
      name: 'vAcctActiveJustNow',
      desc: '',
      args: [],
    );
  }

  /// `Active {minutes} minute(s) ago`
  String vAcctActiveMinutesAgo(Object minutes) {
    return Intl.message(
      'Active $minutes minute(s) ago',
      name: 'vAcctActiveMinutesAgo',
      desc: '',
      args: [minutes],
    );
  }

  /// `Referral Center`
  String get vAcctAgentCenter {
    return Intl.message(
      'Referral Center',
      name: 'vAcctAgentCenter',
      desc: '',
      args: [],
    );
  }

  /// `Invite friends to earn 30% commission · {count} invited`
  String vAcctAgentEntrySubtitle(Object count) {
    return Intl.message(
      'Invite friends to earn 30% commission · $count invited',
      name: 'vAcctAgentEntrySubtitle',
      desc: '',
      args: [count],
    );
  }

  /// `Certified reseller`
  String get vAcctAgentTierAgent {
    return Intl.message(
      'Certified reseller',
      name: 'vAcctAgentTierAgent',
      desc: '',
      args: [],
    );
  }

  /// `Strategic distributor`
  String get vAcctAgentTierMaster {
    return Intl.message(
      'Strategic distributor',
      name: 'vAcctAgentTierMaster',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawable {amount}`
  String vAcctAgentWithdrawable(Object amount) {
    return Intl.message(
      'Withdrawable $amount',
      name: 'vAcctAgentWithdrawable',
      desc: '',
      args: [amount],
    );
  }

  /// `Automatically applied at checkout · pending order funds are not available balance`
  String get vPayLocalExpiryTitle => Intl.message('Payment window ended', name: 'vPayLocalExpiryTitle', desc: '', args: []);

  String get vPayLocalExpiryDesc => Intl.message('Do not send more funds. Server confirmation is still pending. If you have already paid, submit the transaction ID for verification.', name: 'vPayLocalExpiryDesc', desc: '', args: []);

  String get vAcctPendingTitle => Intl.message('Received for pending orders', name: 'vAcctPendingTitle', desc: '', args: []);

  String get vAcctPendingSubtitle => Intl.message('These funds are reserved for their orders, not available for other purchases.', name: 'vAcctPendingSubtitle', desc: '', args: []);

  String get vAcctPendingReceived => Intl.message('Received', name: 'vAcctPendingReceived', desc: '', args: []);

  String get vAcctPendingRemaining => Intl.message('Remaining', name: 'vAcctPendingRemaining', desc: '', args: []);

  String get vAcctPendingTransfer => Intl.message('Awaiting transfer to balance', name: 'vAcctPendingTransfer', desc: '', args: []);

  String get vAcctPendingContinue => Intl.message('Continue payment', name: 'vAcctPendingContinue', desc: '', args: []);

  String get vAcctCreditError => Intl.message('Unable to load funds. Please retry', name: 'vAcctCreditError', desc: '', args: []);

  String get vAcctBalanceSubtitle {
    return Intl.message(
      'Automatically applied at checkout · pending order funds are not available balance',
      name: 'vAcctBalanceSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Available balance: {amount}`
  String vAcctBalanceTitle(Object amount) {
    return Intl.message(
      'Available balance: $amount',
      name: 'vAcctBalanceTitle',
      desc: '',
      args: [amount],
    );
  }

  /// `Startup failed`
  String get vAcctBootFailed {
    return Intl.message(
      'Startup failed',
      name: 'vAcctBootFailed',
      desc: '',
      args: [],
    );
  }

  /// `Startup failed: {error}`
  String vAcctBootFailedWithError(Object error) {
    return Intl.message(
      'Startup failed: $error',
      name: 'vAcctBootFailedWithError',
      desc: '',
      args: [error],
    );
  }

  /// `Buy a plan`
  String get vAcctBuyPlan {
    return Intl.message('Buy a plan', name: 'vAcctBuyPlan', desc: '', args: []);
  }

  /// `Checking subscription status...`
  String get vAcctCheckingSubscription {
    return Intl.message(
      'Checking subscription status...',
      name: 'vAcctCheckingSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Copy subscription link`
  String get vAcctCopySubscriptionUrl {
    return Intl.message(
      'Copy subscription link',
      name: 'vAcctCopySubscriptionUrl',
      desc: '',
      args: [],
    );
  }

  /// `in {days} day(s)`
  String vAcctDaysLater(Object days) {
    return Intl.message(
      'in $days day(s)',
      name: 'vAcctDaysLater',
      desc: '',
      args: [days],
    );
  }

  /// `Manage signed-in devices`
  String get vAcctDevicesEntrySubtitle {
    return Intl.message(
      'Manage signed-in devices',
      name: 'vAcctDevicesEntrySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `When the device limit is reached, signing in on a new device automatically signs out the least recently active one`
  String get vAcctDevicesLimitHint {
    return Intl.message(
      'When the device limit is reached, signing in on a new device automatically signs out the least recently active one',
      name: 'vAcctDevicesLimitHint',
      desc: '',
      args: [],
    );
  }

  /// `{count} / {max} device(s) registered`
  String vAcctDevicesRegistered(Object count, Object max) {
    return Intl.message(
      '$count / $max device(s) registered',
      name: 'vAcctDevicesRegistered',
      desc: '',
      args: [count, max],
    );
  }

  /// `{count} device(s) registered`
  String vAcctDevicesRegisteredNoMax(Object count) {
    return Intl.message(
      '$count device(s) registered',
      name: 'vAcctDevicesRegisteredNoMax',
      desc: '',
      args: [count],
    );
  }

  /// `Device list temporarily unavailable`
  String get vAcctDevicesUnavailable {
    return Intl.message(
      'Device list temporarily unavailable',
      name: 'vAcctDevicesUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Email not verified (needed for password recovery)`
  String get vAcctEmailUnverified {
    return Intl.message(
      'Email not verified (needed for password recovery)',
      name: 'vAcctEmailUnverified',
      desc: '',
      args: [],
    );
  }

  /// `Email verified`
  String get vAcctEmailVerified {
    return Intl.message(
      'Email verified',
      name: 'vAcctEmailVerified',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get vAcctExpired {
    return Intl.message('Expired', name: 'vAcctExpired', desc: '', args: []);
  }

  /// `Expires {date}`
  String vAcctExpiresOn(Object date) {
    return Intl.message(
      'Expires $date',
      name: 'vAcctExpiresOn',
      desc: '',
      args: [date],
    );
  }

  /// `Active`
  String get vAcctGrantActive {
    return Intl.message('Active', name: 'vAcctGrantActive', desc: '', args: []);
  }

  /// `Used up`
  String get vAcctGrantExhausted {
    return Intl.message(
      'Used up',
      name: 'vAcctGrantExhausted',
      desc: '',
      args: [],
    );
  }

  /// `in {hours} hour(s)`
  String vAcctHoursLater(Object hours) {
    return Intl.message(
      'in $hours hour(s)',
      name: 'vAcctHoursLater',
      desc: '',
      args: [hours],
    );
  }

  /// `Sign out`
  String get vAcctLogout {
    return Intl.message('Sign out', name: 'vAcctLogout', desc: '', args: []);
  }

  /// `Sign out this device`
  String get vAcctLogoutDevice {
    return Intl.message(
      'Sign out this device',
      name: 'vAcctLogoutDevice',
      desc: '',
      args: [],
    );
  }

  /// `"{name}" will be removed and will need to sign in again to keep using Verstro.`
  String vAcctLogoutDeviceContent(Object name) {
    return Intl.message(
      '"$name" will be removed and will need to sign in again to keep using Verstro.',
      name: 'vAcctLogoutDeviceContent',
      desc: '',
      args: [name],
    );
  }

  /// `Sign out this device?`
  String get vAcctLogoutDeviceTitle {
    return Intl.message(
      'Sign out this device?',
      name: 'vAcctLogoutDeviceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign out failed: {error}`
  String vAcctLogoutFailed(Object error) {
    return Intl.message(
      'Sign out failed: $error',
      name: 'vAcctLogoutFailed',
      desc: '',
      args: [error],
    );
  }

  /// `in {minutes} minute(s)`
  String vAcctMinutesLater(Object minutes) {
    return Intl.message(
      'in $minutes minute(s)',
      name: 'vAcctMinutesLater',
      desc: '',
      args: [minutes],
    );
  }

  /// `Multi-plan`
  String get vAcctMultiPlanBadge {
    return Intl.message(
      'Multi-plan',
      name: 'vAcctMultiPlanBadge',
      desc: '',
      args: [],
    );
  }

  /// `My devices`
  String get vAcctMyDevices {
    return Intl.message(
      'My devices',
      name: 'vAcctMyDevices',
      desc: '',
      args: [],
    );
  }

  /// `No registered devices`
  String get vAcctNoDevices {
    return Intl.message(
      'No registered devices',
      name: 'vAcctNoDevices',
      desc: '',
      args: [],
    );
  }

  /// `No orders yet`
  String get vAcctNoOrders {
    return Intl.message(
      'No orders yet',
      name: 'vAcctNoOrders',
      desc: '',
      args: [],
    );
  }

  /// `No subscription`
  String get vAcctNoSubscription {
    return Intl.message(
      'No subscription',
      name: 'vAcctNoSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Purchase a plan to start using Verstro VPN.`
  String get vAcctNoSubscriptionDesc {
    return Intl.message(
      'Purchase a plan to start using Verstro VPN.',
      name: 'vAcctNoSubscriptionDesc',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get vAcctOrderFailed {
    return Intl.message('Failed', name: 'vAcctOrderFailed', desc: '', args: []);
  }

  /// `Order history`
  String get vAcctOrderHistory {
    return Intl.message(
      'Order history',
      name: 'vAcctOrderHistory',
      desc: '',
      args: [],
    );
  }

  /// `View past orders and payment records`
  String get vAcctOrderHistorySubtitle {
    return Intl.message(
      'View past orders and payment records',
      name: 'vAcctOrderHistorySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get vAcctOrderPaid {
    return Intl.message('Paid', name: 'vAcctOrderPaid', desc: '', args: []);
  }

  /// `Awaiting payment`
  String get vAcctOrderWaiting {
    return Intl.message(
      'Awaiting payment',
      name: 'vAcctOrderWaiting',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load orders: {error}`
  String vAcctOrdersQueryFailed(Object error) {
    return Intl.message(
      'Failed to load orders: $error',
      name: 'vAcctOrdersQueryFailed',
      desc: '',
      args: [error],
    );
  }

  /// `My Account`
  String get vAcctPageTitle {
    return Intl.message(
      'My Account',
      name: 'vAcctPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Plan details`
  String get vAcctPlanDetails {
    return Intl.message(
      'Plan details',
      name: 'vAcctPlanDetails',
      desc: '',
      args: [],
    );
  }

  /// `Plan`
  String get vAcctPlanLabel {
    return Intl.message('Plan', name: 'vAcctPlanLabel', desc: '', args: []);
  }

  /// `Pro · Monthly`
  String get vAcctPlanPremiumMonthly {
    return Intl.message(
      'Pro · Monthly',
      name: 'vAcctPlanPremiumMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Pro · Quarterly`
  String get vAcctPlanPremiumQuarterly {
    return Intl.message(
      'Pro · Quarterly',
      name: 'vAcctPlanPremiumQuarterly',
      desc: '',
      args: [],
    );
  }

  /// `Pro · Yearly`
  String get vAcctPlanPremiumYearly {
    return Intl.message(
      'Pro · Yearly',
      name: 'vAcctPlanPremiumYearly',
      desc: '',
      args: [],
    );
  }

  /// `Standard · Monthly`
  String get vAcctPlanStandardMonthly {
    return Intl.message(
      'Standard · Monthly',
      name: 'vAcctPlanStandardMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Standard · Quarterly`
  String get vAcctPlanStandardQuarterly {
    return Intl.message(
      'Standard · Quarterly',
      name: 'vAcctPlanStandardQuarterly',
      desc: '',
      args: [],
    );
  }

  /// `Standard · Yearly`
  String get vAcctPlanStandardYearly {
    return Intl.message(
      'Standard · Yearly',
      name: 'vAcctPlanStandardYearly',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get vAcctRefresh {
    return Intl.message('Refresh', name: 'vAcctRefresh', desc: '', args: []);
  }

  /// `{amount} left`
  String vAcctRemainingBytes(Object amount) {
    return Intl.message(
      '$amount left',
      name: 'vAcctRemainingBytes',
      desc: '',
      args: [amount],
    );
  }

  /// `Remaining`
  String get vAcctRemainingLabel {
    return Intl.message(
      'Remaining',
      name: 'vAcctRemainingLabel',
      desc: '',
      args: [],
    );
  }

  /// `Renew / upgrade plan`
  String get vAcctRenewUpgrade {
    return Intl.message(
      'Renew / upgrade plan',
      name: 'vAcctRenewUpgrade',
      desc: '',
      args: [],
    );
  }

  /// `Buy again`
  String get vAcctRepurchase {
    return Intl.message(
      'Buy again',
      name: 'vAcctRepurchase',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get vAcctRetry {
    return Intl.message('Retry', name: 'vAcctRetry', desc: '', args: []);
  }

  /// `Active`
  String get vAcctSubActive {
    return Intl.message('Active', name: 'vAcctSubActive', desc: '', args: []);
  }

  /// `Expired`
  String get vAcctSubExpired {
    return Intl.message('Expired', name: 'vAcctSubExpired', desc: '', args: []);
  }

  /// `Failed to check subscription status`
  String get vAcctSubQueryFailed {
    return Intl.message(
      'Failed to check subscription status',
      name: 'vAcctSubQueryFailed',
      desc: '',
      args: [],
    );
  }

  /// `Subscription check failed`
  String get vAcctSubQueryFailedTitle {
    return Intl.message(
      'Subscription check failed',
      name: 'vAcctSubQueryFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Subscription link copied`
  String get vAcctSubscriptionUrlCopied {
    return Intl.message(
      'Subscription link copied',
      name: 'vAcctSubscriptionUrlCopied',
      desc: '',
      args: [],
    );
  }

  /// `Can be copied into third-party clients such as Shadowrocket (e.g. on iOS devices).`
  String get vAcctSubscriptionUrlDesc {
    return Intl.message(
      'Can be copied into third-party clients such as Shadowrocket (e.g. on iOS devices).',
      name: 'vAcctSubscriptionUrlDesc',
      desc: '',
      args: [],
    );
  }

  /// `Subscription link`
  String get vAcctSubscriptionUrlLabel {
    return Intl.message(
      'Subscription link',
      name: 'vAcctSubscriptionUrlLabel',
      desc: '',
      args: [],
    );
  }

  /// `Tap to continue payment`
  String get vAcctTapToContinuePayment {
    return Intl.message(
      'Tap to continue payment',
      name: 'vAcctTapToContinuePayment',
      desc: '',
      args: [],
    );
  }

  /// `Tap to order again`
  String get vAcctTapToReorder {
    return Intl.message(
      'Tap to order again',
      name: 'vAcctTapToReorder',
      desc: '',
      args: [],
    );
  }

  /// `This device`
  String get vAcctThisDevice {
    return Intl.message(
      'This device',
      name: 'vAcctThisDevice',
      desc: '',
      args: [],
    );
  }

  /// `Total remaining`
  String get vAcctTotalRemainingLabel {
    return Intl.message(
      'Total remaining',
      name: 'vAcctTotalRemainingLabel',
      desc: '',
      args: [],
    );
  }

  /// `Data limit`
  String get vAcctTrafficLimitLabel {
    return Intl.message(
      'Data limit',
      name: 'vAcctTrafficLimitLabel',
      desc: '',
      args: [],
    );
  }

  /// `Data almost used up — consider upgrading your plan`
  String get vAcctTrafficNearLimit {
    return Intl.message(
      'Data almost used up — consider upgrading your plan',
      name: 'vAcctTrafficNearLimit',
      desc: '',
      args: [],
    );
  }

  /// `Data usage`
  String get vAcctTrafficUsage {
    return Intl.message(
      'Data usage',
      name: 'vAcctTrafficUsage',
      desc: '',
      args: [],
    );
  }

  /// `Please try again later`
  String get vAcctTryLater {
    return Intl.message(
      'Please try again later',
      name: 'vAcctTryLater',
      desc: '',
      args: [],
    );
  }

  /// `Unknown device`
  String get vAcctUnknownDevice {
    return Intl.message(
      'Unknown device',
      name: 'vAcctUnknownDevice',
      desc: '',
      args: [],
    );
  }

  /// `A verification code has been sent to {email} (check your spam folder too). Enter the 6-digit code to complete verification.`
  String vAcctVerifyCodeSentDesc(Object email) {
    return Intl.message(
      'A verification code has been sent to $email (check your spam folder too). Enter the 6-digit code to complete verification.',
      name: 'vAcctVerifyCodeSentDesc',
      desc: '',
      args: [email],
    );
  }

  /// `Verify email`
  String get vAcctVerifyEmailTitle {
    return Intl.message(
      'Verify email',
      name: 'vAcctVerifyEmailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Available {amount}`
  String vAgentAvailable(Object amount) {
    return Intl.message(
      'Available $amount',
      name: 'vAgentAvailable',
      desc: '',
      args: [amount],
    );
  }

  /// `Edit price`
  String get vAgentChangePrice {
    return Intl.message(
      'Edit price',
      name: 'vAgentChangePrice',
      desc: '',
      args: [],
    );
  }

  /// `Copy invite code`
  String get vAgentCopyInviteCode {
    return Intl.message(
      'Copy invite code',
      name: 'vAgentCopyInviteCode',
      desc: '',
      args: [],
    );
  }

  /// `Copy share text`
  String get vAgentCopyShareText {
    return Intl.message(
      'Copy share text',
      name: 'vAgentCopyShareText',
      desc: '',
      args: [],
    );
  }

  /// `Copy txid`
  String get vAgentCopyTxid {
    return Intl.message(
      'Copy txid',
      name: 'vAgentCopyTxid',
      desc: '',
      args: [],
    );
  }

  /// `Destination {dest}`
  String vAgentDestLine(Object dest) {
    return Intl.message(
      'Destination $dest',
      name: 'vAgentDestLine',
      desc: '',
      args: [dest],
    );
  }

  /// `Invite code`
  String get vAgentInviteCode {
    return Intl.message(
      'Invite code',
      name: 'vAgentInviteCode',
      desc: '',
      args: [],
    );
  }

  /// `Invite code copied`
  String get vAgentInviteCodeCopied {
    return Intl.message(
      'Invite code copied',
      name: 'vAgentInviteCodeCopied',
      desc: '',
      args: [],
    );
  }

  /// `Invited: {count}`
  String vAgentInvitedCount(Object count) {
    return Intl.message(
      'Invited: $count',
      name: 'vAgentInvitedCount',
      desc: '',
      args: [count],
    );
  }

  /// `Failed to load`
  String get vAgentLoadFailed {
    return Intl.message(
      'Failed to load',
      name: 'vAgentLoadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get vAgentNextStep {
    return Intl.message('Next', name: 'vAgentNextStep', desc: '', args: []);
  }

  /// `Couldn't open the browser. Please look up this transaction on tronscan.org manually.`
  String get vAgentOpenBrowserFailed {
    return Intl.message(
      'Couldn\'t open the browser. Please look up this transaction on tronscan.org manually.',
      name: 'vAgentOpenBrowserFailed',
      desc: '',
      args: [],
    );
  }

  /// `Paid out {amount}`
  String vAgentPaid(Object amount) {
    return Intl.message(
      'Paid out $amount',
      name: 'vAgentPaid',
      desc: '',
      args: [amount],
    );
  }

  /// `Referral Center`
  String get vAgentPanelTitle {
    return Intl.message(
      'Referral Center',
      name: 'vAgentPanelTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid TRC20 address`
  String get vAgentPayoutAddrInvalid {
    return Intl.message(
      'Please enter a valid TRC20 address',
      name: 'vAgentPayoutAddrInvalid',
      desc: '',
      args: [],
    );
  }

  /// `TRC20 address (starts with T, 34 chars)`
  String get vAgentPayoutAddrLabel {
    return Intl.message(
      'TRC20 address (starts with T, 34 chars)',
      name: 'vAgentPayoutAddrLabel',
      desc: '',
      args: [],
    );
  }

  /// `Available balance is too low. Minimum payout is {min}.`
  String vAgentPayoutBelowMin(Object min) {
    return Intl.message(
      'Available balance is too low. Minimum payout is $min.',
      name: 'vAgentPayoutBelowMin',
      desc: '',
      args: [min],
    );
  }

  /// `Withdraw to TRC20`
  String get vAgentPayoutButton {
    return Intl.message(
      'Withdraw to TRC20',
      name: 'vAgentPayoutButton',
      desc: '',
      args: [],
    );
  }

  /// `Confirm payout`
  String get vAgentPayoutConfirm {
    return Intl.message(
      'Confirm payout',
      name: 'vAgentPayoutConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Payout amount: {amount}\nDestination address (TRC20):\n{dest}\n\nPayouts are processed manually — usually within 24 hours, and no later than 3 business days. On-chain fees are covered by the platform, so you receive exactly the amount requested.\n\nPlease double-check the address: it cannot be changed after submission, and funds sent to a wrong address cannot be recovered.`
  String vAgentPayoutConfirmContent(Object amount, Object dest) {
    return Intl.message(
      'Payout amount: $amount\nDestination address (TRC20):\n$dest\n\nPayouts are processed manually — usually within 24 hours, and no later than 3 business days. On-chain fees are covered by the platform, so you receive exactly the amount requested.\n\nPlease double-check the address: it cannot be changed after submission, and funds sent to a wrong address cannot be recovered.',
      name: 'vAgentPayoutConfirmContent',
      desc: '',
      args: [amount, dest],
    );
  }

  /// `Withdraw to a TRC20 address`
  String get vAgentPayoutDialogTitle {
    return Intl.message(
      'Withdraw to a TRC20 address',
      name: 'vAgentPayoutDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Payout failed. Please try again.`
  String get vAgentPayoutFailed {
    return Intl.message(
      'Payout failed. Please try again.',
      name: 'vAgentPayoutFailed',
      desc: '',
      args: [],
    );
  }

  /// `A payout is being processed. You can request another once it completes.`
  String get vAgentPayoutGuardProcessing {
    return Intl.message(
      'A payout is being processed. You can request another once it completes.',
      name: 'vAgentPayoutGuardProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Payout history`
  String get vAgentPayoutHistory {
    return Intl.message(
      'Payout history',
      name: 'vAgentPayoutHistory',
      desc: '',
      args: [],
    );
  }

  /// `A payout is already in progress. You can request a new one after it completes.`
  String get vAgentPayoutInProgress {
    return Intl.message(
      'A payout is already in progress. You can request a new one after it completes.',
      name: 'vAgentPayoutInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Invalid destination address. Please check the TRC20 address.`
  String get vAgentPayoutInvalidDest {
    return Intl.message(
      'Invalid destination address. Please check the TRC20 address.',
      name: 'vAgentPayoutInvalidDest',
      desc: '',
      args: [],
    );
  }

  /// `The transfer didn't go through; the amount has been returned to your available balance.`
  String get vAgentPayoutRefundedDesc {
    return Intl.message(
      'The transfer didn\'t go through; the amount has been returned to your available balance.',
      name: 'vAgentPayoutRefundedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Payout request submitted. Awaiting manual transfer (usually within 24 hours).`
  String get vAgentPayoutSubmitted {
    return Intl.message(
      'Payout request submitted. Awaiting manual transfer (usually within 24 hours).',
      name: 'vAgentPayoutSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Not now`
  String get vAgentPayoutThinkAgain {
    return Intl.message(
      'Not now',
      name: 'vAgentPayoutThinkAgain',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawals available from {min} (current: {current})`
  String vAgentPayoutThreshold(Object min, Object current) {
    return Intl.message(
      'Withdrawals available from $min (current: $current)',
      name: 'vAgentPayoutThreshold',
      desc: '',
      args: [min, current],
    );
  }

  /// `Maturing {amount} (14-day maturation period)`
  String vAgentPending(Object amount) {
    return Intl.message(
      'Maturing $amount (14-day maturation period)',
      name: 'vAgentPending',
      desc: '',
      args: [amount],
    );
  }

  /// `Plan pricing`
  String get vAgentPlanPricing {
    return Intl.message(
      'Plan pricing',
      name: 'vAgentPlanPricing',
      desc: '',
      args: [],
    );
  }

  /// `Plan {planId}`
  String vAgentPlanTitle(Object planId) {
    return Intl.message(
      'Plan $planId',
      name: 'vAgentPlanTitle',
      desc: '',
      args: [planId],
    );
  }

  /// `List price {list} · your cost {floor}`
  String vAgentPlatformFloorLine(Object list, Object floor) {
    return Intl.message(
      'List price $list · your cost $floor',
      name: 'vAgentPlatformFloorLine',
      desc: '',
      args: [list, floor],
    );
  }

  /// `Minimum sale price {price}`
  String vAgentMinimumSaleLine(Object price) {
    return Intl.message(
      'Minimum sale price $price',
      name: 'vAgentMinimumSaleLine',
      desc: '',
      args: [price],
    );
  }

  /// `Price (USD)`
  String get vAgentPriceLabel {
    return Intl.message(
      'Price (USD)',
      name: 'vAgentPriceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a number`
  String get vAgentPriceNotNumber {
    return Intl.message(
      'Please enter a number',
      name: 'vAgentPriceNotNumber',
      desc: '',
      args: [],
    );
  }

  /// `Must be between {floor} and {list}`
  String vAgentPriceOutOfRange(Object floor, Object list) {
    return Intl.message(
      'Must be between $floor and $list',
      name: 'vAgentPriceOutOfRange',
      desc: '',
      args: [floor, list],
    );
  }

  /// `Allowed range {floor} ~ {list} (discounts only)`
  String vAgentPriceRangeHint(Object floor, Object list) {
    return Intl.message(
      'Allowed range $floor ~ $list (discounts only)',
      name: 'vAgentPriceRangeHint',
      desc: '',
      args: [floor, list],
    );
  }

  /// `Failed to set the price. Please try again.`
  String get vAgentPriceSetFailed {
    return Intl.message(
      'Failed to set the price. Please try again.',
      name: 'vAgentPriceSetFailed',
      desc: '',
      args: [],
    );
  }

  /// `Price for {planId} set to {price}`
  String vAgentPriceSetSuccess(Object planId, Object price) {
    return Intl.message(
      'Price for $planId set to $price',
      name: 'vAgentPriceSetSuccess',
      desc: '',
      args: [planId, price],
    );
  }

  /// `Not set (charged at list price {list})`
  String vAgentPriceUnset(Object list) {
    return Intl.message(
      'Not set (charged at list price $list)',
      name: 'vAgentPriceUnset',
      desc: '',
      args: [list],
    );
  }

  /// `Processing {amount} (manual payout in progress)`
  String vAgentProcessing(Object amount) {
    return Intl.message(
      'Processing $amount (manual payout in progress)',
      name: 'vAgentProcessing',
      desc: '',
      args: [amount],
    );
  }

  /// `Retry`
  String get vAgentRetry {
    return Intl.message('Retry', name: 'vAgentRetry', desc: '', args: []);
  }

  /// `Set price for {planId}`
  String vAgentSetPriceTitle(Object planId) {
    return Intl.message(
      'Set price for $planId',
      name: 'vAgentSetPriceTitle',
      desc: '',
      args: [planId],
    );
  }

  /// `Share poster`
  String get vAgentSharePoster {
    return Intl.message(
      'Share poster',
      name: 'vAgentSharePoster',
      desc: '',
      args: [],
    );
  }

  /// `Sign up for Verstro with my invite code {code} — you'll get a reward on your first purchase too! Download: {url}`
  String vAgentShareText(Object code, Object url) {
    return Intl.message(
      'Sign up for Verstro with my invite code $code — you\'ll get a reward on your first purchase too! Download: $url',
      name: 'vAgentShareText',
      desc: '',
      args: [code, url],
    );
  }

  /// `Share text copied`
  String get vAgentShareTextCopied {
    return Intl.message(
      'Share text copied',
      name: 'vAgentShareTextCopied',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get vAgentStatusProcessing {
    return Intl.message(
      'Processing',
      name: 'vAgentStatusProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Returned`
  String get vAgentStatusRefunded {
    return Intl.message(
      'Returned',
      name: 'vAgentStatusRefunded',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get vAgentStatusSent {
    return Intl.message('Paid', name: 'vAgentStatusSent', desc: '', args: []);
  }

  /// `Sub-agents: {count} · override available {amount}`
  String vAgentSubAgentLine(Object count, Object amount) {
    return Intl.message(
      'Sub-agents: $count · override available $amount',
      name: 'vAgentSubAgentLine',
      desc: '',
      args: [count, amount],
    );
  }

  /// `Strategic distributor`
  String get vAgentTierMaster {
    return Intl.message(
      'Strategic distributor',
      name: 'vAgentTierMaster',
      desc: '',
      args: [],
    );
  }

  /// `Promoter`
  String get vAgentTierPromoter {
    return Intl.message(
      'Promoter',
      name: 'vAgentTierPromoter',
      desc: '',
      args: [],
    );
  }

  /// `Certified reseller`
  String get vAgentTierReseller {
    return Intl.message(
      'Certified reseller',
      name: 'vAgentTierReseller',
      desc: '',
      args: [],
    );
  }

  /// `Certified affiliate`
  String get vPartnerCertifiedAffiliate {
    return Intl.message(
      'Certified affiliate',
      name: 'vPartnerCertifiedAffiliate',
      desc: '',
      args: [],
    );
  }

  /// `Certified reseller`
  String get vPartnerCertifiedReseller {
    return Intl.message(
      'Certified reseller',
      name: 'vPartnerCertifiedReseller',
      desc: '',
      args: [],
    );
  }

  /// `Strategic distributor`
  String get vPartnerStrategicDistributor {
    return Intl.message(
      'Strategic distributor',
      name: 'vPartnerStrategicDistributor',
      desc: '',
      args: [],
    );
  }

  /// `Verified by Verstro`
  String get vPartnerVerified {
    return Intl.message(
      'Verified by Verstro',
      name: 'vPartnerVerified',
      desc: '',
      args: [],
    );
  }

  /// `Authorization {code}`
  String vPartnerAuthorizationCode(Object code) {
    return Intl.message(
      'Authorization $code',
      name: 'vPartnerAuthorizationCode',
      desc: '',
      args: [code],
    );
  }

  /// `Standard partnerships are non-exclusive`
  String get vPartnerNonExclusive {
    return Intl.message(
      'Standard partnerships are non-exclusive',
      name: 'vPartnerNonExclusive',
      desc: '',
      args: [],
    );
  }

  /// `txid copied`
  String get vAgentTxidCopied {
    return Intl.message(
      'txid copied',
      name: 'vAgentTxidCopied',
      desc: '',
      args: [],
    );
  }

  /// `View on TronScan`
  String get vAgentViewOnTronScan {
    return Intl.message(
      'View on TronScan',
      name: 'vAgentViewOnTronScan',
      desc: '',
      args: [],
    );
  }

  /// `Commission wallet`
  String get vAgentWalletTitle {
    return Intl.message(
      'Commission wallet',
      name: 'vAgentWalletTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your price {price} · you earn {earn} per order`
  String vAgentYourPriceLine(Object price, Object earn) {
    return Intl.message(
      'Your price $price · you earn $earn per order',
      name: 'vAgentYourPriceLine',
      desc: '',
      args: [price, earn],
    );
  }

  /// `Invalid request parameters`
  String get vApiBadRequest {
    return Intl.message(
      'Invalid request parameters',
      name: 'vApiBadRequest',
      desc: '',
      args: [],
    );
  }

  /// `Operation conflict`
  String get vApiConflict {
    return Intl.message(
      'Operation conflict',
      name: 'vApiConflict',
      desc: '',
      args: [],
    );
  }

  /// `Could not connect to the server: {detail}`
  String vApiConnectFailed(Object detail) {
    return Intl.message(
      'Could not connect to the server: $detail',
      name: 'vApiConnectFailed',
      desc: '',
      args: [detail],
    );
  }

  /// `This email is already registered`
  String get vApiEmailTaken {
    return Intl.message(
      'This email is already registered',
      name: 'vApiEmailTaken',
      desc: '',
      args: [],
    );
  }

  /// `Permission denied`
  String get vApiForbidden {
    return Intl.message(
      'Permission denied',
      name: 'vApiForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect email or password`
  String get vApiInvalidCredentials {
    return Intl.message(
      'Incorrect email or password',
      name: 'vApiInvalidCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Could not connect to any backup domain. Check your network.`
  String get vApiNoActiveBackend {
    return Intl.message(
      'Could not connect to any backup domain. Check your network.',
      name: 'vApiNoActiveBackend',
      desc: '',
      args: [],
    );
  }

  /// `Resource not found`
  String get vApiNotFound {
    return Intl.message(
      'Resource not found',
      name: 'vApiNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Not signed in or session expired`
  String get vApiNotLoggedIn {
    return Intl.message(
      'Not signed in or session expired',
      name: 'vApiNotLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Request cancelled`
  String get vApiRequestCancelled {
    return Intl.message(
      'Request cancelled',
      name: 'vApiRequestCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Request timed out. Check your network or VPN.`
  String get vApiRequestTimeout {
    return Intl.message(
      'Request timed out. Check your network or VPN.',
      name: 'vApiRequestTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Server error. Please try again later.`
  String get vApiServerError {
    return Intl.message(
      'Server error. Please try again later.',
      name: 'vApiServerError',
      desc: '',
      args: [],
    );
  }

  /// `Server error ({status})`
  String vApiServerErrorStatus(Object status) {
    return Intl.message(
      'Server error ($status)',
      name: 'vApiServerErrorStatus',
      desc: '',
      args: [status],
    );
  }

  /// `TLS certificate error: {detail}`
  String vApiTlsCertError(Object detail) {
    return Intl.message(
      'TLS certificate error: $detail',
      name: 'vApiTlsCertError',
      desc: '',
      args: [detail],
    );
  }

  /// `Your session has expired. Please sign in again.`
  String get vApiTokenExpired {
    return Intl.message(
      'Your session has expired. Please sign in again.',
      name: 'vApiTokenExpired',
      desc: '',
      args: [],
    );
  }

  /// `Invalid sign-in credentials`
  String get vApiTokenInvalid {
    return Intl.message(
      'Invalid sign-in credentials',
      name: 'vApiTokenInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized`
  String get vApiUnauthorized {
    return Intl.message(
      'Unauthorized',
      name: 'vApiUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected response type: {type}`
  String vApiUnexpectedResponseType(Object type) {
    return Intl.message(
      'Unexpected response type: $type',
      name: 'vApiUnexpectedResponseType',
      desc: '',
      args: [type],
    );
  }

  /// `Unexpected status code {status}`
  String vApiUnexpectedStatus(Object status) {
    return Intl.message(
      'Unexpected status code $status',
      name: 'vApiUnexpectedStatus',
      desc: '',
      args: [status],
    );
  }

  /// `Australia`
  String get vAppCountryAu {
    return Intl.message('Australia', name: 'vAppCountryAu', desc: '', args: []);
  }

  /// `Canada`
  String get vAppCountryCa {
    return Intl.message('Canada', name: 'vAppCountryCa', desc: '', args: []);
  }

  /// `China`
  String get vAppCountryCn {
    return Intl.message('China', name: 'vAppCountryCn', desc: '', args: []);
  }

  /// `Germany`
  String get vAppCountryDe {
    return Intl.message('Germany', name: 'vAppCountryDe', desc: '', args: []);
  }

  /// `France`
  String get vAppCountryFr {
    return Intl.message('France', name: 'vAppCountryFr', desc: '', args: []);
  }

  /// `United Kingdom`
  String get vAppCountryGb {
    return Intl.message(
      'United Kingdom',
      name: 'vAppCountryGb',
      desc: '',
      args: [],
    );
  }

  /// `Hong Kong`
  String get vAppCountryHk {
    return Intl.message('Hong Kong', name: 'vAppCountryHk', desc: '', args: []);
  }

  /// `Indonesia`
  String get vAppCountryId {
    return Intl.message('Indonesia', name: 'vAppCountryId', desc: '', args: []);
  }

  /// `India`
  String get vAppCountryIn {
    return Intl.message('India', name: 'vAppCountryIn', desc: '', args: []);
  }

  /// `Japan`
  String get vAppCountryJp {
    return Intl.message('Japan', name: 'vAppCountryJp', desc: '', args: []);
  }

  /// `South Korea`
  String get vAppCountryKr {
    return Intl.message(
      'South Korea',
      name: 'vAppCountryKr',
      desc: '',
      args: [],
    );
  }

  /// `Macao`
  String get vAppCountryMo {
    return Intl.message('Macao', name: 'vAppCountryMo', desc: '', args: []);
  }

  /// `Malaysia`
  String get vAppCountryMy {
    return Intl.message('Malaysia', name: 'vAppCountryMy', desc: '', args: []);
  }

  /// `Netherlands`
  String get vAppCountryNl {
    return Intl.message(
      'Netherlands',
      name: 'vAppCountryNl',
      desc: '',
      args: [],
    );
  }

  /// `Philippines`
  String get vAppCountryPh {
    return Intl.message(
      'Philippines',
      name: 'vAppCountryPh',
      desc: '',
      args: [],
    );
  }

  /// `Russia`
  String get vAppCountryRu {
    return Intl.message('Russia', name: 'vAppCountryRu', desc: '', args: []);
  }

  /// `Singapore`
  String get vAppCountrySg {
    return Intl.message('Singapore', name: 'vAppCountrySg', desc: '', args: []);
  }

  /// `Thailand`
  String get vAppCountryTh {
    return Intl.message('Thailand', name: 'vAppCountryTh', desc: '', args: []);
  }

  /// `Türkiye`
  String get vAppCountryTr {
    return Intl.message('Türkiye', name: 'vAppCountryTr', desc: '', args: []);
  }

  /// `Taiwan`
  String get vAppCountryTw {
    return Intl.message('Taiwan', name: 'vAppCountryTw', desc: '', args: []);
  }

  /// `United States`
  String get vAppCountryUs {
    return Intl.message(
      'United States',
      name: 'vAppCountryUs',
      desc: '',
      args: [],
    );
  }

  /// `Vietnam`
  String get vAppCountryVn {
    return Intl.message('Vietnam', name: 'vAppCountryVn', desc: '', args: []);
  }

  /// `Log Out`
  String get vAppLogout {
    return Intl.message('Log Out', name: 'vAppLogout', desc: '', args: []);
  }

  /// `Are you sure you want to log out of this account?`
  String get vAppLogoutConfirm {
    return Intl.message(
      'Are you sure you want to log out of this account?',
      name: 'vAppLogoutConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Global`
  String get vAppModeGlobal {
    return Intl.message('Global', name: 'vAppModeGlobal', desc: '', args: []);
  }

  /// `Smart`
  String get vAppModeRule {
    return Intl.message('Smart', name: 'vAppModeRule', desc: '', args: []);
  }

  /// `Syncing subscription… If this stays empty, pull to refresh on the Account page or sign in again.`
  String get vAppProfilesSyncingTip {
    return Intl.message(
      'Syncing subscription… If this stays empty, pull to refresh on the Account page or sign in again.',
      name: 'vAppProfilesSyncingTip',
      desc: '',
      args: [],
    );
  }

  /// `Invite friends and you both get rewards`
  String get vAppShareSubtitle {
    return Intl.message(
      'Invite friends and you both get rewards',
      name: 'vAppShareSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Share Verstro`
  String get vAppShareTitle {
    return Intl.message(
      'Share Verstro',
      name: 'vAppShareTitle',
      desc: '',
      args: [],
    );
  }

  /// `Back to sign in`
  String get vAuthBackToLogin {
    return Intl.message(
      'Back to sign in',
      name: 'vAuthBackToLogin',
      desc: '',
      args: [],
    );
  }

  /// `6 digits`
  String get vAuthCodeHint {
    return Intl.message('6 digits', name: 'vAuthCodeHint', desc: '', args: []);
  }

  /// `Verification code`
  String get vAuthCodeLabel {
    return Intl.message(
      'Verification code',
      name: 'vAuthCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code`
  String get vAuthCodeRequired {
    return Intl.message(
      'Please enter the verification code',
      name: 'vAuthCodeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Verification code resent. Please check your inbox`
  String get vAuthCodeResent {
    return Intl.message(
      'Verification code resent. Please check your inbox',
      name: 'vAuthCodeResent',
      desc: '',
      args: [],
    );
  }

  /// `Verification code sent. Please check your inbox`
  String get vAuthCodeSent {
    return Intl.message(
      'Verification code sent. Please check your inbox',
      name: 'vAuthCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get vAuthConfirmNewPasswordLabel {
    return Intl.message(
      'Confirm new password',
      name: 'vAuthConfirmNewPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please re-enter the new password`
  String get vAuthConfirmNewPasswordRequired {
    return Intl.message(
      'Please re-enter the new password',
      name: 'vAuthConfirmNewPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get vAuthConfirmPasswordLabel {
    return Intl.message(
      'Confirm password',
      name: 'vAuthConfirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please re-enter your password`
  String get vAuthConfirmPasswordRequired {
    return Intl.message(
      'Please re-enter your password',
      name: 'vAuthConfirmPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get vAuthEmailInvalid {
    return Intl.message(
      'Invalid email format',
      name: 'vAuthEmailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get vAuthEmailLabel {
    return Intl.message('Email', name: 'vAuthEmailLabel', desc: '', args: []);
  }

  /// `Please enter your email`
  String get vAuthEmailRequired {
    return Intl.message(
      'Please enter your email',
      name: 'vAuthEmailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email verified ✓`
  String get vAuthEmailVerified {
    return Intl.message(
      'Email verified ✓',
      name: 'vAuthEmailVerified',
      desc: '',
      args: [],
    );
  }

  /// `Enter your registered email and we'll send a 6-digit verification code (valid for 10 minutes).`
  String get vAuthForgotIntro {
    return Intl.message(
      'Enter your registered email and we\'ll send a 6-digit verification code (valid for 10 minutes).',
      name: 'vAuthForgotIntro',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get vAuthForgotPasswordLink {
    return Intl.message(
      'Forgot password?',
      name: 'vAuthForgotPasswordLink',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get vAuthForgotPasswordTitle {
    return Intl.message(
      'Forgot password',
      name: 'vAuthForgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? Sign in`
  String get vAuthGoToLogin {
    return Intl.message(
      'Already have an account? Sign in',
      name: 'vAuthGoToLogin',
      desc: '',
      args: [],
    );
  }

  /// `No account? Sign up now`
  String get vAuthGoToRegister {
    return Intl.message(
      'No account? Sign up now',
      name: 'vAuthGoToRegister',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get vAuthLoginButton {
    return Intl.message(
      'Sign in',
      name: 'vAuthLoginButton',
      desc: '',
      args: [],
    );
  }

  /// `Sign-in failed: {error}`
  String vAuthLoginFailed(Object error) {
    return Intl.message(
      'Sign-in failed: $error',
      name: 'vAuthLoginFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Sign in to Verstro`
  String get vAuthLoginTitle {
    return Intl.message(
      'Sign in to Verstro',
      name: 'vAuthLoginTitle',
      desc: '',
      args: [],
    );
  }

  /// `New password (min 8 characters)`
  String get vAuthNewPasswordLabelMin8 {
    return Intl.message(
      'New password (min 8 characters)',
      name: 'vAuthNewPasswordLabelMin8',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new password`
  String get vAuthNewPasswordRequired {
    return Intl.message(
      'Please enter a new password',
      name: 'vAuthNewPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password (min 6 characters)`
  String get vAuthPasswordLabelMin6 {
    return Intl.message(
      'Password (min 6 characters)',
      name: 'vAuthPasswordLabelMin6',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get vAuthPasswordMin6 {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'vAuthPasswordMin6',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get vAuthPasswordMin8 {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'vAuthPasswordMin8',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get vAuthPasswordMismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'vAuthPasswordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get vAuthPasswordRequired {
    return Intl.message(
      'Please enter your password',
      name: 'vAuthPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password has been reset`
  String get vAuthPasswordResetDone {
    return Intl.message(
      'Password has been reset',
      name: 'vAuthPasswordResetDone',
      desc: '',
      args: [],
    );
  }

  /// `Referral code (optional)`
  String get vAuthReferralCodeLabel {
    return Intl.message(
      'Referral code (optional)',
      name: 'vAuthReferralCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get vAuthRegisterButton {
    return Intl.message(
      'Sign up',
      name: 'vAuthRegisterButton',
      desc: '',
      args: [],
    );
  }

  /// `Sign-up failed: {error}`
  String vAuthRegisterFailed(Object error) {
    return Intl.message(
      'Sign-up failed: $error',
      name: 'vAuthRegisterFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Free to sign up. Your email is only used for password recovery and payment notifications; verification is optional.`
  String get vAuthRegisterIntro {
    return Intl.message(
      'Free to sign up. Your email is only used for password recovery and payment notifications; verification is optional.',
      name: 'vAuthRegisterIntro',
      desc: '',
      args: [],
    );
  }

  /// `Sign up for Verstro`
  String get vAuthRegisterTitle {
    return Intl.message(
      'Sign up for Verstro',
      name: 'vAuthRegisterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Resend code`
  String get vAuthResendCodeButton {
    return Intl.message(
      'Resend code',
      name: 'vAuthResendCodeButton',
      desc: '',
      args: [],
    );
  }

  /// `Didn't get it? Resend code`
  String get vAuthResendCodeLink {
    return Intl.message(
      'Didn\'t get it? Resend code',
      name: 'vAuthResendCodeLink',
      desc: '',
      args: [],
    );
  }

  /// `Resend ({seconds}s)`
  String vAuthResendCooldown(Object seconds) {
    return Intl.message(
      'Resend (${seconds}s)',
      name: 'vAuthResendCooldown',
      desc: '',
      args: [seconds],
    );
  }

  /// `Reset failed. Check your network and try again`
  String get vAuthResetFailedNetwork {
    return Intl.message(
      'Reset failed. Check your network and try again',
      name: 'vAuthResetFailedNetwork',
      desc: '',
      args: [],
    );
  }

  /// `A verification code has been sent to {email} (check spam too).\nEnter the 6-digit code and set a new password.`
  String vAuthResetIntro(Object email) {
    return Intl.message(
      'A verification code has been sent to $email (check spam too).\nEnter the 6-digit code and set a new password.',
      name: 'vAuthResetIntro',
      desc: '',
      args: [email],
    );
  }

  /// `Reset password`
  String get vAuthResetPasswordTitle {
    return Intl.message(
      'Reset password',
      name: 'vAuthResetPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Redirecting to sign-in. Please sign in with your new password.`
  String get vAuthResetSuccessDesc {
    return Intl.message(
      'Redirecting to sign-in. Please sign in with your new password.',
      name: 'vAuthResetSuccessDesc',
      desc: '',
      args: [],
    );
  }

  /// `Reset successful`
  String get vAuthResetSuccessTitle {
    return Intl.message(
      'Reset successful',
      name: 'vAuthResetSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Send code`
  String get vAuthSendCodeButton {
    return Intl.message(
      'Send code',
      name: 'vAuthSendCodeButton',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send. Check your network or try again later`
  String get vAuthSendFailedNetwork {
    return Intl.message(
      'Failed to send. Check your network or try again later',
      name: 'vAuthSendFailedNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send. Please try again later`
  String get vAuthSendFailedRetry {
    return Intl.message(
      'Failed to send. Please try again later',
      name: 'vAuthSendFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get vAuthVerifyButton {
    return Intl.message(
      'Verify',
      name: 'vAuthVerifyButton',
      desc: '',
      args: [],
    );
  }

  /// `Verification failed. Check your network and try again`
  String get vAuthVerifyFailedNetwork {
    return Intl.message(
      'Verification failed. Check your network and try again',
      name: 'vAuthVerifyFailedNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed — your subscription is now active.`
  String get vClaimActivated {
    return Intl.message(
      'Confirmed — your subscription is now active.',
      name: 'vClaimActivated',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed — your subscription is active. The {amount} overpayment was added to your account balance and applies automatically next time.`
  String vClaimActivatedOverpay(Object amount) {
    return Intl.message(
      'Confirmed — your subscription is active. The $amount overpayment was added to your account balance and applies automatically next time.',
      name: 'vClaimActivatedOverpay',
      desc: '',
      args: [amount],
    );
  }

  /// `This transaction was already processed and cannot be reused. For review, send the order number and TXID privately to feedback@verstro.com; never send passwords, verification codes, private keys, or recovery phrases.`
  String get vClaimAlreadyProcessed {
    return Intl.message(
      'This transaction was already processed and cannot be reused. For review, send the order number and TXID privately to feedback@verstro.com; never send passwords, verification codes, private keys, or recovery phrases.',
      name: 'vClaimAlreadyProcessed',
      desc: '',
      args: [],
    );
  }

  /// `This order had expired, but we received your transfer. {amount} was credited to your account balance. Order again — your balance applies automatically and activates immediately if it covers the total.`
  String vClaimCreditedExpired(Object amount) {
    return Intl.message(
      'This order had expired, but we received your transfer. $amount was credited to your account balance. Order again — your balance applies automatically and activates immediately if it covers the total.',
      name: 'vClaimCreditedExpired',
      desc: '',
      args: [amount],
    );
  }

  /// `{amount} was credited to your account balance. Order again — your balance applies automatically.`
  String vClaimCreditedNoShortfall(Object amount) {
    return Intl.message(
      '$amount was credited to your account balance. Order again — your balance applies automatically.',
      name: 'vClaimCreditedNoShortfall',
      desc: '',
      args: [amount],
    );
  }

  /// `The amount received was less than due. {amount} was credited to your account balance and the original order was voided. Order again — your balance applies automatically; you only need to cover the {shortfall} difference.`
  String vClaimCreditedUnderpay(Object amount, Object shortfall) {
    return Intl.message(
      'The amount received was less than due. $amount was credited to your account balance and the original order was voided. Order again — your balance applies automatically; you only need to cover the $shortfall difference.',
      name: 'vClaimCreditedUnderpay',
      desc: '',
      args: [amount, shortfall],
    );
  }

  /// `This transaction matched another order. If you have no other order, send the order number and TXID privately to feedback@verstro.com; never send passwords, verification codes, private keys, or recovery phrases.`
  String get vClaimMatchedOtherOrder {
    return Intl.message(
      'This transaction matched another order. If you have no other order, send the order number and TXID privately to feedback@verstro.com; never send passwords, verification codes, private keys, or recovery phrases.',
      name: 'vClaimMatchedOtherOrder',
      desc: '',
      args: [],
    );
  }

  /// `This transaction needs manual review. Send the order number, registration email, and TXID privately to feedback@verstro.com; never send passwords, verification codes, private keys, or recovery phrases.`
  String get vClaimRejectedManual {
    return Intl.message(
      'This transaction needs manual review. Send the order number, registration email, and TXID privately to feedback@verstro.com; never send passwords, verification codes, private keys, or recovery phrases.',
      name: 'vClaimRejectedManual',
      desc: '',
      args: [],
    );
  }

  /// `This transaction could not be verified yet. Try again later; do not pay again. If it persists, share only your platform, version, error text, and when it happened in the public @verstro_chat group.`
  String get vClaimVerifyFailed {
    return Intl.message(
      'This transaction could not be verified yet. Try again later; do not pay again. If it persists, share only your platform, version, error text, and when it happened in the public @verstro_chat group.',
      name: 'vClaimVerifyFailed',
      desc: '',
      args: [],
    );
  }

  /// `The transaction is not visible on-chain yet. Check the TXID and network, then retry; do not pay again.`
  String get vClaimNotFound {
    return Intl.message(
      'The transaction is not visible on-chain yet. Check the TXID and network, then retry; do not pay again.',
      name: 'vClaimNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Received {amount} across {count} payment(s); {remaining} remains. Send the difference to this order address and submit the next TXID.`
  String vClaimPartiallyPaid(Object amount, Object count, Object remaining) {
    return Intl.message(
      'Received $amount across $count payment(s); $remaining remains. Send the difference to this order address and submit the next TXID.',
      name: 'vClaimPartiallyPaid',
      desc: '',
      args: [amount, count, remaining],
    );
  }

  /// `The transaction is awaiting on-chain confirmation. Wait for confirmation and retry; do not pay again.`
  String get vClaimPendingConfirmation {
    return Intl.message(
      'The transaction is awaiting on-chain confirmation. Wait for confirmation and retry; do not pay again.',
      name: 'vClaimPendingConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `The on-chain query service is temporarily unavailable. Try again later; do not pay again.`
  String get vClaimProviderUnavailable {
    return Intl.message(
      'The on-chain query service is temporarily unavailable. Try again later; do not pay again.',
      name: 'vClaimProviderUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Payment completed across {count} transactions. Your subscription is active.`
  String vClaimSplitPaymentCompleted(Object count) {
    return Intl.message(
      'Payment completed across $count transactions. Your subscription is active.',
      name: 'vClaimSplitPaymentCompleted',
      desc: '',
      args: [count],
    );
  }

  /// `The {amount} excess was added to your account balance and applies automatically next time.`
  String vClaimSplitPaymentCredit(Object amount) {
    return Intl.message(
      'The $amount excess was added to your account balance and applies automatically next time.',
      name: 'vClaimSplitPaymentCredit',
      desc: '',
      args: [amount],
    );
  }

  /// `This is not a recognized USDT TRC20 transfer and cannot be applied to this order.`
  String get vClaimUnsupportedTransfer {
    return Intl.message(
      'This is not a recognized USDT TRC20 transfer and cannot be applied to this order.',
      name: 'vClaimUnsupportedTransfer',
      desc: '',
      args: [],
    );
  }

  /// `The actual recipient was {recipient}, which does not match this order. Check the transfer record and do not pay again.`
  String vClaimWrongRecipient(Object recipient) {
    return Intl.message(
      'The actual recipient was $recipient, which does not match this order. Check the transfer record and do not pay again.',
      name: 'vClaimWrongRecipient',
      desc: '',
      args: [recipient],
    );
  }

  /// `Deposit address copied`
  String get vPayAddressCopied {
    return Intl.message(
      'Deposit address copied',
      name: 'vPayAddressCopied',
      desc: '',
      args: [],
    );
  }

  /// `Amount copied (keep all decimal places)`
  String get vPayAmountCopied {
    return Intl.message(
      'Amount copied (keep all decimal places)',
      name: 'vPayAmountCopied',
      desc: '',
      args: [],
    );
  }

  /// `Even 0.01 more or less cannot be matched automatically. Make sure the "amount" field in your wallet matches to 2 decimal places.`
  String get vPayAmountMismatchNote {
    return Intl.message(
      'Even 0.01 more or less cannot be matched automatically. Make sure the "amount" field in your wallet matches to 2 decimal places.',
      name: 'vPayAmountMismatchNote',
      desc: '',
      args: [],
    );
  }

  /// `Plan base price ${basePrice} + unique cents suffix. Even 0.01 more or less cannot be matched automatically. Make sure the "amount" field in your wallet matches to 2 decimal places.`
  String vPayAmountMismatchNoteWithBase(Object basePrice) {
    return Intl.message(
      'Plan base price \$$basePrice + unique cents suffix. Even 0.01 more or less cannot be matched automatically. Make sure the "amount" field in your wallet matches to 2 decimal places.',
      name: 'vPayAmountMismatchNoteWithBase',
      desc: '',
      args: [basePrice],
    );
  }

  /// `Matching cents`
  String get vPayAntiCollisionSuffixLabel {
    return Intl.message(
      'Matching cents',
      name: 'vPayAntiCollisionSuffixLabel',
      desc: '',
      args: [],
    );
  }

  /// `Back to home`
  String get vPayBackToHome {
    return Intl.message(
      'Back to home',
      name: 'vPayBackToHome',
      desc: '',
      args: [],
    );
  }

  /// `Back to reorder`
  String get vPayBackToReorder {
    return Intl.message(
      'Back to reorder',
      name: 'vPayBackToReorder',
      desc: '',
      args: [],
    );
  }

  /// `Original price`
  String get vPayBasePriceLabel {
    return Intl.message(
      'Original price',
      name: 'vPayBasePriceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Copy the tx hash of your transfer from your wallet (imToken / TronLink, etc.) and paste it below:`
  String get vPayClaimInstruction {
    return Intl.message(
      'Copy the tx hash of your transfer from your wallet (imToken / TronLink, etc.) and paste it below:',
      name: 'vPayClaimInstruction',
      desc: '',
      args: [],
    );
  }

  /// `After submission, the app follows structured on-chain results: wait for the stated confirmation delay, continue with another TXID after a partial payment, and refresh the order and subscription when complete.`
  String get vPayClaimNote {
    return Intl.message(
      'After submission, the app follows structured on-chain results: wait for the stated confirmation delay, continue with another TXID after a partial payment, and refresh the order and subscription when complete.',
      name: 'vPayClaimNote',
      desc: '',
      args: [],
    );
  }

  /// `Community group (public)`
  String get vPayContactSupport {
    return Intl.message(
      'Community group (public)',
      name: 'vPayContactSupport',
      desc: '',
      args: [],
    );
  }

  /// `Submit another payment TXID`
  String get vPayContinuePaymentWithHash {
    return Intl.message(
      'Submit another payment TXID',
      name: 'vPayContinuePaymentWithHash',
      desc: '',
      args: [],
    );
  }

  /// `Retry in {seconds}s`
  String vPayRetryInSeconds(Object seconds) {
    return Intl.message(
      'Retry in ${seconds}s',
      name: 'vPayRetryInSeconds',
      desc: '',
      args: [seconds],
    );
  }

  /// `Copy address`
  String get vPayCopyAddress {
    return Intl.message(
      'Copy address',
      name: 'vPayCopyAddress',
      desc: '',
      args: [],
    );
  }

  /// `Copy amount`
  String get vPayCopyAmount {
    return Intl.message(
      'Copy amount',
      name: 'vPayCopyAmount',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get vPayCountdownExpired {
    return Intl.message(
      'Expired',
      name: 'vPayCountdownExpired',
      desc: '',
      args: [],
    );
  }

  /// `Coupon`
  String get vPayCouponDiscountLabel {
    return Intl.message(
      'Coupon',
      name: 'vPayCouponDiscountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Balance applied`
  String get vPayCreditAppliedLabel {
    return Intl.message(
      'Balance applied',
      name: 'vPayCreditAppliedLabel',
      desc: '',
      args: [],
    );
  }

  /// `Transfer exactly this amount`
  String get vPayExactAmountWarning {
    return Intl.message(
      'Transfer exactly this amount',
      name: 'vPayExactAmountWarning',
      desc: '',
      args: [],
    );
  }

  /// `Transferred but not credited? Submit your transaction hash and the received amount will be added to your account balance automatically.`
  String get vPayExpiredClaimHint {
    return Intl.message(
      'Transferred but not credited? Submit your transaction hash and the received amount will be added to your account balance automatically.',
      name: 'vPayExpiredClaimHint',
      desc: '',
      args: [],
    );
  }

  /// `Exchanges deduct a network fee from the withdrawal amount (typically ~1 USDT on TRC20), so the amount received will be less than what you entered and the payment cannot be matched automatically. We recommend transferring directly from your own wallet (imToken / TronLink). If you must use an exchange, set withdrawal amount = amount due + fee, so the received amount exactly equals the amount due. For an incorrect amount, submit the TXID: an overpayment activates the subscription and credits the excess; an underpayment is credited in full and applied automatically when you reorder.`
  String get vPayFeeWarningBody {
    return Intl.message(
      'Exchanges deduct a network fee from the withdrawal amount (typically ~1 USDT on TRC20), so the amount received will be less than what you entered and the payment cannot be matched automatically. We recommend transferring directly from your own wallet (imToken / TronLink). If you must use an exchange, set withdrawal amount = amount due + fee, so the received amount exactly equals the amount due. For an incorrect amount, submit the TXID: an overpayment activates the subscription and credits the excess; an underpayment is credited in full and applied automatically when you reorder.',
      name: 'vPayFeeWarningBody',
      desc: '',
      args: [],
    );
  }

  /// `Paying by exchange withdrawal? Mind the fee`
  String get vPayFeeWarningTitle {
    return Intl.message(
      'Paying by exchange withdrawal? Mind the fee',
      name: 'vPayFeeWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `I've paid`
  String get vPayIHavePaid {
    return Intl.message(
      'I\'ve paid',
      name: 'vPayIHavePaid',
      desc: '',
      args: [],
    );
  }

  /// `I've paid (submit tx hash)`
  String get vPayIHavePaidSubmitTx {
    return Intl.message(
      'I\'ve paid (submit tx hash)',
      name: 'vPayIHavePaidSubmitTx',
      desc: '',
      args: [],
    );
  }

  /// `I've paid (enter tx hash to verify now)`
  String get vPayIHavePaidWithHash {
    return Intl.message(
      'I\'ve paid (enter tx hash to verify now)',
      name: 'vPayIHavePaidWithHash',
      desc: '',
      args: [],
    );
  }

  /// `Order #{id} received no payment within 24 hours and has been voided automatically.`
  String vPayOrderExpiredDesc(Object id) {
    return Intl.message(
      'Order #$id received no payment within 24 hours and has been voided automatically.',
      name: 'vPayOrderExpiredDesc',
      desc: '',
      args: [id],
    );
  }

  /// `Order expired`
  String get vPayOrderExpiredTitle {
    return Intl.message(
      'Order expired',
      name: 'vPayOrderExpiredTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unpaid orders are voided automatically after 24h. Once you pay within 24h, the backend matches the payment within 30s; tap "I've paid" to trigger matching immediately.`
  String get vPayOrderFooterNote {
    return Intl.message(
      'Unpaid orders are voided automatically after 24h. Once you pay within 24h, the backend matches the payment within 30s; tap "I\'ve paid" to trigger matching immediately.',
      name: 'vPayOrderFooterNote',
      desc: '',
      args: [],
    );
  }

  /// `Order #{id}`
  String vPayOrderNumber(Object id) {
    return Intl.message(
      'Order #$id',
      name: 'vPayOrderNumber',
      desc: '',
      args: [id],
    );
  }

  /// `{plan} order #{id}`
  String vPayOrderTitle(Object plan, Object id) {
    return Intl.message(
      '$plan order #$id',
      name: 'vPayOrderTitle',
      desc: '',
      args: [plan, id],
    );
  }

  /// `Payment confirmed`
  String get vPayPaymentConfirmed {
    return Intl.message(
      'Payment confirmed',
      name: 'vPayPaymentConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get vPayPlanMonthly {
    return Intl.message('Monthly', name: 'vPayPlanMonthly', desc: '', args: []);
  }

  /// `Quarterly`
  String get vPayPlanQuarterly {
    return Intl.message(
      'Quarterly',
      name: 'vPayPlanQuarterly',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get vPayPlanYearly {
    return Intl.message('Yearly', name: 'vPayPlanYearly', desc: '', args: []);
  }

  /// `Place a new order (balance applied automatically)`
  String get vPayReorderWithCredit {
    return Intl.message(
      'Place a new order (balance applied automatically)',
      name: 'vPayReorderWithCredit',
      desc: '',
      args: [],
    );
  }

  /// `Checking order status...`
  String get vPayStatusChecking {
    return Intl.message(
      'Checking order status...',
      name: 'vPayStatusChecking',
      desc: '',
      args: [],
    );
  }

  /// `Query failed, retrying...`
  String get vPayStatusQueryFailed {
    return Intl.message(
      'Query failed, retrying...',
      name: 'vPayStatusQueryFailed',
      desc: '',
      args: [],
    );
  }

  /// `⏳ Awaiting payment... (auto-refresh every 5s)`
  String get vPayStatusWaiting {
    return Intl.message(
      '⏳ Awaiting payment... (auto-refresh every 5s)',
      name: 'vPayStatusWaiting',
      desc: '',
      args: [],
    );
  }

  /// `Submission failed: {error}`
  String vPaySubmitFailed(Object error) {
    return Intl.message(
      'Submission failed: $error',
      name: 'vPaySubmitFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Submit for verification`
  String get vPaySubmitVerify {
    return Intl.message(
      'Submit for verification',
      name: 'vPaySubmitVerify',
      desc: '',
      args: [],
    );
  }

  /// `Subscription activated`
  String get vPaySubscriptionActivated {
    return Intl.message(
      'Subscription activated',
      name: 'vPaySubscriptionActivated',
      desc: '',
      args: [],
    );
  }

  /// `Could not open Telegram. Community group: @verstro_chat`
  String get vPayTelegramNotInstalled {
    return Intl.message(
      'Could not open Telegram. Community group: @verstro_chat',
      name: 'vPayTelegramNotInstalled',
      desc: '',
      args: [],
    );
  }

  /// `Tron USDT address`
  String get vPayTronAddressTitle {
    return Intl.message(
      'Tron USDT address',
      name: 'vPayTronAddressTitle',
      desc: '',
      args: [],
    );
  }

  /// `64-char hex, e.g. abc1234...`
  String get vPayTxHashHint {
    return Intl.message(
      '64-char hex, e.g. abc1234...',
      name: 'vPayTxHashHint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid tx hash length (should be 64 characters)`
  String get vPayTxHashLengthError {
    return Intl.message(
      'Invalid tx hash length (should be 64 characters)',
      name: 'vPayTxHashLengthError',
      desc: '',
      args: [],
    );
  }

  /// `Account: {email}`
  String vPlanAccountEmail(Object email) {
    return Intl.message(
      'Account: $email',
      name: 'vPlanAccountEmail',
      desc: '',
      args: [email],
    );
  }

  /// `Best value`
  String get vPlanBadgeBestValue {
    return Intl.message(
      'Best value',
      name: 'vPlanBadgeBestValue',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get vPlanBadgeRecommended {
    return Intl.message(
      'Recommended',
      name: 'vPlanBadgeRecommended',
      desc: '',
      args: [],
    );
  }

  /// `Coupon code (optional)`
  String get vPlanCouponLabel {
    return Intl.message(
      'Coupon code (optional)',
      name: 'vPlanCouponLabel',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create order: {error}`
  String vPlanCreateOrderFailed(Object error) {
    return Intl.message(
      'Failed to create order: $error',
      name: 'vPlanCreateOrderFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Valid for {days} days`
  String vPlanDurationDays(Object days) {
    return Intl.message(
      'Valid for $days days',
      name: 'vPlanDurationDays',
      desc: '',
      args: [days],
    );
  }

  /// `Auto-selects the fastest node`
  String get vPlanFeatureAutoNode {
    return Intl.message(
      'Auto-selects the fastest node',
      name: 'vPlanFeatureAutoNode',
      desc: '',
      args: [],
    );
  }

  /// `Manually pick country / node · accelerated nodes included`
  String get vPlanFeaturePremiumNodes {
    return Intl.message(
      'Manually pick country / node · accelerated nodes included',
      name: 'vPlanFeaturePremiumNodes',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load plans: {error}`
  String vPlanLoadFailed(Object error) {
    return Intl.message(
      'Failed to load plans: $error',
      name: 'vPlanLoadFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Sign out`
  String get vPlanLogout {
    return Intl.message('Sign out', name: 'vPlanLogout', desc: '', args: []);
  }

  /// `{count} device(s) online at the same time`
  String vPlanMaxDevices(Object count) {
    return Intl.message(
      '$count device(s) online at the same time',
      name: 'vPlanMaxDevices',
      desc: '',
      args: [count],
    );
  }

  /// `Use on multiple devices at once`
  String get vPlanMultiDevices {
    return Intl.message(
      'Use on multiple devices at once',
      name: 'vPlanMultiDevices',
      desc: '',
      args: [],
    );
  }

  /// `Trial`
  String get vPlanNameTrial {
    return Intl.message('Trial', name: 'vPlanNameTrial', desc: '', args: []);
  }

  /// `Payment method: USDT-TRC20\nPayments go directly to Verstro's own on-chain address — no third-party custody`
  String get vPlanPaymentMethodNote {
    return Intl.message(
      'Payment method: USDT-TRC20\nPayments go directly to Verstro\'s own on-chain address — no third-party custody',
      name: 'vPlanPaymentMethodNote',
      desc: '',
      args: [],
    );
  }

  /// `≈ ${price} / mo`
  String vPlanPerMonthHint(Object price) {
    return Intl.message(
      '≈ \$$price / mo',
      name: 'vPlanPerMonthHint',
      desc: '',
      args: [price],
    );
  }

  /// `Partner price`
  String get vPlanPartnerPriceLabel {
    return Intl.message(
      'Partner price',
      name: 'vPlanPartnerPriceLabel',
      desc: '',
      args: [],
    );
  }

  /// `The plan price changed. Review the new price and confirm again.`
  String get vPlanPriceChanged {
    return Intl.message(
      'The plan price changed. Review the new price and confirm again.',
      name: 'vPlanPriceChanged',
      desc: '',
      args: [],
    );
  }

  /// `Choose this plan`
  String get vPlanPickThis {
    return Intl.message(
      'Choose this plan',
      name: 'vPlanPickThis',
      desc: '',
      args: [],
    );
  }

  /// `Choose a plan`
  String get vPlanPickTitle {
    return Intl.message(
      'Choose a plan',
      name: 'vPlanPickTitle',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get vPlanRetry {
    return Intl.message('Retry', name: 'vPlanRetry', desc: '', args: []);
  }

  /// `Telegram community support`
  String get vPlanTelegramSupport {
    return Intl.message(
      'Telegram community support',
      name: 'vPlanTelegramSupport',
      desc: '',
      args: [],
    );
  }

  /// `Pro plans`
  String get vPlanTierPremium {
    return Intl.message(
      'Pro plans',
      name: 'vPlanTierPremium',
      desc: '',
      args: [],
    );
  }

  /// `Manually pick country / node · low-latency accelerated nodes · more devices`
  String get vPlanTierPremiumDesc {
    return Intl.message(
      'Manually pick country / node · low-latency accelerated nodes · more devices',
      name: 'vPlanTierPremiumDesc',
      desc: '',
      args: [],
    );
  }

  /// `Standard plans`
  String get vPlanTierStandard {
    return Intl.message(
      'Standard plans',
      name: 'vPlanTierStandard',
      desc: '',
      args: [],
    );
  }

  /// `Auto-selects the fastest node · fast and sufficient`
  String get vPlanTierStandardDesc {
    return Intl.message(
      'Auto-selects the fastest node · fast and sufficient',
      name: 'vPlanTierStandardDesc',
      desc: '',
      args: [],
    );
  }

  /// `{amount} of data`
  String vPlanTraffic(Object amount) {
    return Intl.message(
      '$amount of data',
      name: 'vPlanTraffic',
      desc: '',
      args: [amount],
    );
  }

  /// `Failed to load invite code`
  String get vShareCodeLoadFailed {
    return Intl.message(
      'Failed to load invite code',
      name: 'vShareCodeLoadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Verstro is a privacy-first cross-platform network tool. Verstro clients are available on Android and desktop; iOS can import a subscription into supported third-party clients. {trial}{invite}{url}`
  String vShareCopyBrief(Object trial, Object invite, Object url) {
    return Intl.message(
      'Verstro is a privacy-first cross-platform network tool. Verstro clients are available on Android and desktop; iOS can import a subscription into supported third-party clients. $trial$invite$url',
      name: 'vShareCopyBrief',
      desc: '',
      args: [trial, invite, url],
    );
  }

  /// `Copy text`
  String get vShareCopyButton {
    return Intl.message(
      'Copy text',
      name: 'vShareCopyButton',
      desc: '',
      args: [],
    );
  }

  /// `Terminal, Docker, or Git ignoring your system proxy? Desktop TUN can cover more apps at the OS network layer, subject to the OS, app, active rules, and network environment. The Verstro client is open source under GPLv3. {trial}{invite}{url}`
  String vShareCopyDev(Object trial, Object invite, Object url) {
    return Intl.message(
      'Terminal, Docker, or Git ignoring your system proxy? Desktop TUN can cover more apps at the OS network layer, subject to the OS, app, active rules, and network environment. The Verstro client is open source under GPLv3. $trial$invite$url',
      name: 'vShareCopyDev',
      desc: '',
      args: [trial, invite, url],
    );
  }

  /// `I use Verstro, a privacy-first cross-platform network tool. Verstro clients are available on Android and desktop; iOS can use supported third-party clients. Experience depends on the OS and network environment. The client is open source under GPLv3. {trial}{invite}Download: {url}`
  String vShareCopyGeneral(Object trial, Object invite, Object url) {
    return Intl.message(
      'I use Verstro, a privacy-first cross-platform network tool. Verstro clients are available on Android and desktop; iOS can use supported third-party clients. Experience depends on the OS and network environment. The client is open source under GPLv3. $trial${invite}Download: $url',
      name: 'vShareCopyGeneral',
      desc: '',
      args: [trial, invite, url],
    );
  }

  /// `Share text`
  String get vShareCopyTitle {
    return Intl.message(
      'Share text',
      name: 'vShareCopyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Generating…`
  String get vShareGenerating {
    return Intl.message(
      'Generating…',
      name: 'vShareGenerating',
      desc: '',
      args: [],
    );
  }

  /// `{prefix} — after your first purchase we each get {amount} in credit. `
  String vShareInviteBoth(Object prefix, Object amount) {
    return Intl.message(
      '$prefix — after your first purchase we each get $amount in credit. ',
      name: 'vShareInviteBoth',
      desc: '',
      args: [prefix, amount],
    );
  }

  /// `{prefix}. `
  String vShareInvitePlain(Object prefix) {
    return Intl.message(
      '$prefix. ',
      name: 'vShareInvitePlain',
      desc: '',
      args: [prefix],
    );
  }

  /// `Enter my invite code {code} when signing up`
  String vShareInvitePrefix(Object code) {
    return Intl.message(
      'Enter my invite code $code when signing up',
      name: 'vShareInvitePrefix',
      desc: '',
      args: [code],
    );
  }

  /// `Sign up with invite code {code}`
  String vShareInvitePrefixBrief(Object code) {
    return Intl.message(
      'Sign up with invite code $code',
      name: 'vShareInvitePrefixBrief',
      desc: '',
      args: [code],
    );
  }

  /// `{prefix} — you'll get {amount} in credit after your first purchase. `
  String vShareInviteReferee(Object prefix, Object amount) {
    return Intl.message(
      '$prefix — you\'ll get $amount in credit after your first purchase. ',
      name: 'vShareInviteReferee',
      desc: '',
      args: [prefix, amount],
    );
  }

  /// `Share Verstro`
  String get vSharePageTitle {
    return Intl.message(
      'Share Verstro',
      name: 'vSharePageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Covers more apps beyond a system proxy`
  String get vSharePosterFeat1Desc {
    return Intl.message(
      'Covers more apps beyond a system proxy',
      name: 'vSharePosterFeat1Desc',
      desc: '',
      args: [],
    );
  }

  /// `System-level TUN`
  String get vSharePosterFeat1Label {
    return Intl.message(
      'System-level TUN',
      name: 'vSharePosterFeat1Label',
      desc: '',
      args: [],
    );
  }

  /// `Automatic selection; network-dependent`
  String get vSharePosterFeat2Desc {
    return Intl.message(
      'Automatic selection; network-dependent',
      name: 'vSharePosterFeat2Desc',
      desc: '',
      args: [],
    );
  }

  /// `Multi-region nodes`
  String get vSharePosterFeat2Label {
    return Intl.message(
      'Multi-region nodes',
      name: 'vSharePosterFeat2Label',
      desc: '',
      args: [],
    );
  }

  /// `No connection-content or destination logs`
  String get vSharePosterFeat3Desc {
    return Intl.message(
      'No connection-content or destination logs',
      name: 'vSharePosterFeat3Desc',
      desc: '',
      args: [],
    );
  }

  /// `Privacy first`
  String get vSharePosterFeat3Label {
    return Intl.message(
      'Privacy first',
      name: 'vSharePosterFeat3Label',
      desc: '',
      args: [],
    );
  }

  /// `Multi-platform`
  String get vSharePosterFeat4Label {
    return Intl.message(
      'Multi-platform',
      name: 'vSharePosterFeat4Label',
      desc: '',
      args: [],
    );
  }

  /// `Verstro-invite-poster.png`
  String get vSharePosterFileName {
    return Intl.message(
      'Verstro-invite-poster.png',
      name: 'vSharePosterFileName',
      desc: '',
      args: [],
    );
  }

  /// `GPLv3 open-source client · auditable behavior`
  String get vSharePosterFooter {
    return Intl.message(
      'GPLv3 open-source client · auditable behavior',
      name: 'vSharePosterFooter',
      desc: '',
      args: [],
    );
  }

  /// `Failed to generate the image. Please try again.`
  String get vSharePosterGenFailed {
    return Intl.message(
      'Failed to generate the image. Please try again.',
      name: 'vSharePosterGenFailed',
      desc: '',
      args: [],
    );
  }

  /// `Get Verstro`
  String get vSharePosterGetVerstro {
    return Intl.message(
      'Get Verstro',
      name: 'vSharePosterGetVerstro',
      desc: '',
      args: [],
    );
  }

  /// `Network beyond the browser`
  String get vSharePosterHeadline {
    return Intl.message(
      'Network beyond the browser',
      name: 'vSharePosterHeadline',
      desc: '',
      args: [],
    );
  }

  /// `The poster isn't ready yet. Please try again shortly.`
  String get vSharePosterNotReady {
    return Intl.message(
      'The poster isn\'t ready yet. Please try again shortly.',
      name: 'vSharePosterNotReady',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with this code · we each get {amount} after your first purchase`
  String vSharePosterRewardBoth(Object amount) {
    return Intl.message(
      'Sign up with this code · we each get $amount after your first purchase',
      name: 'vSharePosterRewardBoth',
      desc: '',
      args: [amount],
    );
  }

  /// `Enter this invite code when signing up`
  String get vSharePosterRewardNone {
    return Intl.message(
      'Enter this invite code when signing up',
      name: 'vSharePosterRewardNone',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with this code · get {amount} credit on your first purchase`
  String vSharePosterRewardReferee(Object amount) {
    return Intl.message(
      'Sign up with this code · get $amount credit on your first purchase',
      name: 'vSharePosterRewardReferee',
      desc: '',
      args: [amount],
    );
  }

  /// `Poster saved`
  String get vSharePosterSaved {
    return Intl.message(
      'Poster saved',
      name: 'vSharePosterSaved',
      desc: '',
      args: [],
    );
  }

  /// `Scan to download`
  String get vSharePosterScanHint {
    return Intl.message(
      'Scan to download',
      name: 'vSharePosterScanHint',
      desc: '',
      args: [],
    );
  }

  /// `Scan to visit the site and download the client`
  String get vSharePosterScanSite {
    return Intl.message(
      'Scan to visit the site and download the client',
      name: 'vSharePosterScanSite',
      desc: '',
      args: [],
    );
  }

  /// `System-level TUN · coverage varies by environment`
  String get vSharePosterSubline {
    return Intl.message(
      'System-level TUN · coverage varies by environment',
      name: 'vSharePosterSubline',
      desc: '',
      args: [],
    );
  }

  /// `Privacy-first global network`
  String get vSharePosterTagline {
    return Intl.message(
      'Privacy-first global network',
      name: 'vSharePosterTagline',
      desc: '',
      args: [],
    );
  }

  /// `free {days}-day trial`
  String vSharePosterTrialDays(Object days) {
    return Intl.message(
      'free $days-day trial',
      name: 'vSharePosterTrialDays',
      desc: '',
      args: [days],
    );
  }

  /// `free trial available`
  String get vSharePosterTrialGeneric {
    return Intl.message(
      'free trial available',
      name: 'vSharePosterTrialGeneric',
      desc: '',
      args: [],
    );
  }

  /// `New users: {trial}{gb}`
  String vSharePosterTrialLine(Object trial, Object gb) {
    return Intl.message(
      'New users: $trial$gb',
      name: 'vSharePosterTrialLine',
      desc: '',
      args: [trial, gb],
    );
  }

  /// `Save canceled`
  String get vShareSaveCanceled {
    return Intl.message(
      'Save canceled',
      name: 'vShareSaveCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Save failed. Please try again.`
  String get vShareSaveFailed {
    return Intl.message(
      'Save failed. Please try again.',
      name: 'vShareSaveFailed',
      desc: '',
      args: [],
    );
  }

  /// `Save image`
  String get vShareSaveImage {
    return Intl.message(
      'Save image',
      name: 'vShareSaveImage',
      desc: '',
      args: [],
    );
  }

  /// `Brief`
  String get vShareStyleBrief {
    return Intl.message('Brief', name: 'vShareStyleBrief', desc: '', args: []);
  }

  /// `For developers`
  String get vShareStyleDeveloper {
    return Intl.message(
      'For developers',
      name: 'vShareStyleDeveloper',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get vShareStyleGeneral {
    return Intl.message(
      'General',
      name: 'vShareStyleGeneral',
      desc: '',
      args: [],
    );
  }

  /// `New users can try it for free. `
  String get vShareTrialGeneral {
    return Intl.message(
      'New users can try it for free. ',
      name: 'vShareTrialGeneral',
      desc: '',
      args: [],
    );
  }

  /// `New users get a free {days}-day trial. `
  String vShareTrialGeneralDays(Object days) {
    return Intl.message(
      'New users get a free $days-day trial. ',
      name: 'vShareTrialGeneralDays',
      desc: '',
      args: [days],
    );
  }

  /// `Free trial available. `
  String get vShareTrialShort {
    return Intl.message(
      'Free trial available. ',
      name: 'vShareTrialShort',
      desc: '',
      args: [],
    );
  }

  /// `Trial activated!`
  String get vTrialActivated {
    return Intl.message(
      'Trial activated!',
      name: 'vTrialActivated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to claim, please try again`
  String get vTrialClaimFailed {
    return Intl.message(
      'Failed to claim, please try again',
      name: 'vTrialClaimFailed',
      desc: '',
      args: [],
    );
  }

  /// `Claim now`
  String get vTrialClaimNow {
    return Intl.message(
      'Claim now',
      name: 'vTrialClaimNow',
      desc: '',
      args: [],
    );
  }

  /// `{days} days · {gb} GB of data`
  String vTrialSpec(Object days, Object gb) {
    return Intl.message(
      '$days days · $gb GB of data',
      name: 'vTrialSpec',
      desc: '',
      args: [days, gb],
    );
  }

  /// `Free trial`
  String get vTrialTitle {
    return Intl.message('Free trial', name: 'vTrialTitle', desc: '', args: []);
  }

  /// `Verify your email to claim a {days}-day free trial (enter the 6-digit code from the email)`
  String vTrialVerifyEmailHint(Object days) {
    return Intl.message(
      'Verify your email to claim a $days-day free trial (enter the 6-digit code from the email)',
      name: 'vTrialVerifyEmailHint',
      desc: '',
      args: [days],
    );
  }

  /// `You're on the latest version`
  String get vUpdAlreadyLatest {
    return Intl.message(
      'You\'re on the latest version',
      name: 'vUpdAlreadyLatest',
      desc: '',
      args: [],
    );
  }

  /// `Integrity check failed (sha256 mismatch); the download was discarded`
  String get vUpdChecksumFailed {
    return Intl.message(
      'Integrity check failed (sha256 mismatch); the download was discarded',
      name: 'vUpdChecksumFailed',
      desc: '',
      args: [],
    );
  }

  /// `Download failed: {error}`
  String vUpdDownloadFailed(Object error) {
    return Intl.message(
      'Download failed: $error',
      name: 'vUpdDownloadFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Downloading {percent}%`
  String vUpdDownloadingProgress(Object percent) {
    return Intl.message(
      'Downloading $percent%',
      name: 'vUpdDownloadingProgress',
      desc: '',
      args: [percent],
    );
  }

  /// `Exit App`
  String get vUpdExitApp {
    return Intl.message('Exit App', name: 'vUpdExitApp', desc: '', args: []);
  }

  /// `This version is no longer supported. Please update to continue.`
  String get vUpdForceDesc {
    return Intl.message(
      'This version is no longer supported. Please update to continue.',
      name: 'vUpdForceDesc',
      desc: '',
      args: [],
    );
  }

  /// `Update to v{version} Required`
  String vUpdForceTitle(Object version) {
    return Intl.message(
      'Update to v$version Required',
      name: 'vUpdForceTitle',
      desc: '',
      args: [version],
    );
  }

  /// `Skip This Version`
  String get vUpdIgnoreThisVersion {
    return Intl.message(
      'Skip This Version',
      name: 'vUpdIgnoreThisVersion',
      desc: '',
      args: [],
    );
  }

  /// `Failed to launch installer: {error}`
  String vUpdInstallLaunchFailed(Object error) {
    return Intl.message(
      'Failed to launch installer: $error',
      name: 'vUpdInstallLaunchFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Later`
  String get vUpdLater {
    return Intl.message('Later', name: 'vUpdLater', desc: '', args: []);
  }

  /// `New Version v{version} Available`
  String vUpdNewVersionTitle(Object version) {
    return Intl.message(
      'New Version v$version Available',
      name: 'vUpdNewVersionTitle',
      desc: '',
      args: [version],
    );
  }

  /// `No installer package found for this device`
  String get vUpdNoMatchingPackage {
    return Intl.message(
      'No installer package found for this device',
      name: 'vUpdNoMatchingPackage',
      desc: '',
      args: [],
    );
  }

  /// `Update failed: {error}`
  String vUpdUpdateFailed(Object error) {
    return Intl.message(
      'Update failed: $error',
      name: 'vUpdUpdateFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Update Now`
  String get vUpdUpdateNow {
    return Intl.message(
      'Update Now',
      name: 'vUpdUpdateNow',
      desc: '',
      args: [],
    );
  }

  /// `Verification code expired — request a new one`
  String get vErrCodeExpired {
    return Intl.message(
      'Verification code expired — request a new one',
      name: 'vErrCodeExpired',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts — request a new code`
  String get vErrCodeLocked {
    return Intl.message(
      'Too many attempts — request a new code',
      name: 'vErrCodeLocked',
      desc: '',
      args: [],
    );
  }

  /// `This coupon code already exists`
  String get vErrDuplicateCode {
    return Intl.message(
      'This coupon code already exists',
      name: 'vErrDuplicateCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify your email before claiming the trial`
  String get vErrEmailUnverified {
    return Intl.message(
      'Verify your email before claiming the trial',
      name: 'vErrEmailUnverified',
      desc: '',
      args: [],
    );
  }

  /// `Your subscription has expired`
  String get vErrSubExpired {
    return Intl.message(
      'Your subscription has expired',
      name: 'vErrSubExpired',
      desc: '',
      args: [],
    );
  }

  /// `You already have a subscription — no trial needed`
  String get vErrHasSubscription {
    return Intl.message(
      'You already have a subscription — no trial needed',
      name: 'vErrHasSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect or expired verification code`
  String get vErrInvalidCode {
    return Intl.message(
      'Incorrect or expired verification code',
      name: 'vErrInvalidCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid TRC20 address`
  String get vErrInvalidDest {
    return Intl.message(
      'Enter a valid TRC20 address',
      name: 'vErrInvalidDest',
      desc: '',
      args: [],
    );
  }

  /// `This plan doesn't exist`
  String get vErrInvalidPlan {
    return Intl.message(
      'This plan doesn\'t exist',
      name: 'vErrInvalidPlan',
      desc: '',
      args: [],
    );
  }

  /// `Invalid referral code. Check it and try again.`
  String get vErrInvalidReferralCode {
    return Intl.message(
      'Invalid referral code. Check it and try again.',
      name: 'vErrInvalidReferralCode',
      desc: '',
      args: [],
    );
  }

  /// `Transaction ID looks invalid`
  String get vErrInvalidTxHash {
    return Intl.message(
      'Transaction ID looks invalid',
      name: 'vErrInvalidTxHash',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code`
  String get vErrMissingCode {
    return Intl.message(
      'Enter the verification code',
      name: 'vErrMissingCode',
      desc: '',
      args: [],
    );
  }

  /// `No subscription`
  String get vErrNoSubscription {
    return Intl.message(
      'No subscription',
      name: 'vErrNoSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't start the trial — try again`
  String get vErrProvisionFailed {
    return Intl.message(
      'Couldn\'t start the trial — try again',
      name: 'vErrProvisionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Subscription proxy is off — no link to reset`
  String get vErrSubProxyDisabled {
    return Intl.message(
      'Subscription proxy is off — no link to reset',
      name: 'vErrSubProxyDisabled',
      desc: '',
      args: [],
    );
  }

  /// `This link has already been used`
  String get vErrTokenUsed {
    return Intl.message(
      'This link has already been used',
      name: 'vErrTokenUsed',
      desc: '',
      args: [],
    );
  }

  /// `You've already claimed the trial`
  String get vErrTrialClaimed {
    return Intl.message(
      'You\'ve already claimed the trial',
      name: 'vErrTrialClaimed',
      desc: '',
      args: [],
    );
  }

  /// `The trial isn't available right now`
  String get vErrTrialDisabled {
    return Intl.message(
      'The trial isn\'t available right now',
      name: 'vErrTrialDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Invalid coupon code`
  String get vErrCouponInvalid {
    return Intl.message(
      'Invalid coupon code',
      name: 'vErrCouponInvalid',
      desc: '',
      args: [],
    );
  }

  /// `This coupon has been disabled`
  String get vErrCouponDisabled {
    return Intl.message(
      'This coupon has been disabled',
      name: 'vErrCouponDisabled',
      desc: '',
      args: [],
    );
  }

  /// `This coupon isn't active yet or has expired`
  String get vErrCouponInactive {
    return Intl.message(
      'This coupon isn\'t active yet or has expired',
      name: 'vErrCouponInactive',
      desc: '',
      args: [],
    );
  }

  /// `This coupon doesn't apply to this plan`
  String get vErrCouponPlanMismatch {
    return Intl.message(
      'This coupon doesn\'t apply to this plan',
      name: 'vErrCouponPlanMismatch',
      desc: '',
      args: [],
    );
  }

  /// `New users only`
  String get vErrCouponNewUsersOnly {
    return Intl.message(
      'New users only',
      name: 'vErrCouponNewUsersOnly',
      desc: '',
      args: [],
    );
  }

  /// `You've reached the usage limit for this coupon`
  String get vErrCouponLimitReached {
    return Intl.message(
      'You\'ve reached the usage limit for this coupon',
      name: 'vErrCouponLimitReached',
      desc: '',
      args: [],
    );
  }

  /// `This coupon is fully claimed`
  String get vErrCouponSoldOut {
    return Intl.message(
      'This coupon is fully claimed',
      name: 'vErrCouponSoldOut',
      desc: '',
      args: [],
    );
  }

  /// `Partner prices can't be combined with platform coupons`
  String get vErrCouponPartnerPriceConflict {
    return Intl.message(
      'Partner prices can\'t be combined with platform coupons',
      name: 'vErrCouponPartnerPriceConflict',
      desc: '',
      args: [],
    );
  }

  /// `New purchases of this plan are temporarily unavailable through this partner. Existing orders and benefits are unaffected.`
  String get vPlanPartnerSalesPaused {
    return Intl.message(
      'New purchases of this plan are temporarily unavailable through this partner. Existing orders and benefits are unaffected.',
      name: 'vPlanPartnerSalesPaused',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get vPlanUnavailable {
    return Intl.message(
      'Unavailable',
      name: 'vPlanUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Membership card center`
  String get vCardTitle {
    return Intl.message(
      'Membership card center',
      name: 'vCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Membership cards and activation codes`
  String get vCardEntryTitle {
    return Intl.message(
      'Membership cards and activation codes',
      name: 'vCardEntryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Buy, distribute, reveal, or redeem membership cards`
  String get vCardEntrySubtitle {
    return Intl.message(
      'Buy, distribute, reveal, or redeem membership cards',
      name: 'vCardEntrySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get vCardMarketTab {
    return Intl.message('Buy', name: 'vCardMarketTab', desc: '', args: []);
  }

  /// `Inventory`
  String get vCardInventoryTab {
    return Intl.message(
      'Inventory',
      name: 'vCardInventoryTab',
      desc: '',
      args: [],
    );
  }

  /// `Redeem`
  String get vCardRedeemTab {
    return Intl.message('Redeem', name: 'vCardRedeemTab', desc: '', args: []);
  }

  /// `Timeline`
  String get vCardTimelineTab {
    return Intl.message(
      'Timeline',
      name: 'vCardTimelineTab',
      desc: '',
      args: [],
    );
  }

  /// `Mix multiple plans in one cart. Regular users pay list price for 1–9 cards and 70% from 10 cards; authorized agents use their existing cost tier with no extra bulk discount. The server quote is authoritative.`
  String get vCardMarketDescription {
    return Intl.message(
      'Mix multiple plans in one cart. Regular users pay list price for 1–9 cards and 70% from 10 cards; authorized agents use their existing cost tier with no extra bulk discount. The server quote is authoritative.',
      name: 'vCardMarketDescription',
      desc: '',
      args: [],
    );
  }

  /// `{days} days · {traffic}`
  String vCardPlanMeta(Object days, Object traffic) {
    return Intl.message(
      '$days days · $traffic',
      name: 'vCardPlanMeta',
      desc: '',
      args: [days, traffic],
    );
  }

  /// `Quantity`
  String get vCardQuantity {
    return Intl.message('Quantity', name: 'vCardQuantity', desc: '', args: []);
  }

  /// `Decrease quantity`
  String get vCardDecrease {
    return Intl.message(
      'Decrease quantity',
      name: 'vCardDecrease',
      desc: '',
      args: [],
    );
  }

  /// `Increase quantity`
  String get vCardIncrease {
    return Intl.message(
      'Increase quantity',
      name: 'vCardIncrease',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one membership card.`
  String get vCardNeedQuantity {
    return Intl.message(
      'Select at least one membership card.',
      name: 'vCardNeedQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Use refundable cash-backed credit`
  String get vCardUseCashBacked {
    return Intl.message(
      'Use refundable cash-backed credit',
      name: 'vCardUseCashBacked',
      desc: '',
      args: [],
    );
  }

  /// `Get quote`
  String get vCardGetQuote {
    return Intl.message('Get quote', name: 'vCardGetQuote', desc: '', args: []);
  }

  /// `Getting quote…`
  String get vCardQuoting {
    return Intl.message(
      'Getting quote…',
      name: 'vCardQuoting',
      desc: '',
      args: [],
    );
  }

  /// `Server quote`
  String get vCardServerQuote {
    return Intl.message(
      'Server quote',
      name: 'vCardServerQuote',
      desc: '',
      args: [],
    );
  }

  /// `Regular retail gift cards: {count} cards at list price.`
  String vCardPriceRetail(Object count) {
    return Intl.message(
      'Regular retail gift cards: $count cards at list price.',
      name: 'vCardPriceRetail',
      desc: '',
      args: [count],
    );
  }

  /// `Regular-user bulk price: {count} cards at the server-confirmed 70% tier.`
  String vCardPriceBulkRetail(Object count) {
    return Intl.message(
      'Regular-user bulk price: $count cards at the server-confirmed 70% tier.',
      name: 'vCardPriceBulkRetail',
      desc: '',
      args: [count],
    );
  }

  /// `Promoter cost tier: server cost ratio {cost}/10000, with no additional bulk discount.`
  String vCardPricePromoter(Object cost) {
    return Intl.message(
      'Promoter cost tier: server cost ratio $cost/10000, with no additional bulk discount.',
      name: 'vCardPricePromoter',
      desc: '',
      args: [cost],
    );
  }

  /// `Reseller cost tier: server cost ratio {cost}/10000, with no additional bulk discount.`
  String vCardPriceReseller(Object cost) {
    return Intl.message(
      'Reseller cost tier: server cost ratio $cost/10000, with no additional bulk discount.',
      name: 'vCardPriceReseller',
      desc: '',
      args: [cost],
    );
  }

  /// `Master cost tier: server cost ratio {cost}/10000, with no additional bulk discount.`
  String vCardPriceMaster(Object cost) {
    return Intl.message(
      'Master cost tier: server cost ratio $cost/10000, with no additional bulk discount.',
      name: 'vCardPriceMaster',
      desc: '',
      args: [cost],
    );
  }

  /// `List total`
  String get vCardListTotal {
    return Intl.message(
      'List total',
      name: 'vCardListTotal',
      desc: '',
      args: [],
    );
  }

  /// `Card price`
  String get vCardGoodsTotal {
    return Intl.message(
      'Card price',
      name: 'vCardGoodsTotal',
      desc: '',
      args: [],
    );
  }

  /// `Cash-backed credit`
  String get vCardCashBackedApplied {
    return Intl.message(
      'Cash-backed credit',
      name: 'vCardCashBackedApplied',
      desc: '',
      args: [],
    );
  }

  /// `Amount due`
  String get vCardCashDue {
    return Intl.message('Amount due', name: 'vCardCashDue', desc: '', args: []);
  }

  /// `Confirm and create order`
  String get vCardCreateOrder {
    return Intl.message(
      'Confirm and create order',
      name: 'vCardCreateOrder',
      desc: '',
      args: [],
    );
  }

  /// `This is wholesale inventory. The purchaser cannot redeem these cards. Eligible redeemers are attributed to the purchaser while commissions remain governed by existing agent rules.`
  String get vCardWarningWholesaleSelf {
    return Intl.message(
      'This is wholesale inventory. The purchaser cannot redeem these cards. Eligible redeemers are attributed to the purchaser while commissions remain governed by existing agent rules.',
      name: 'vCardWarningWholesaleSelf',
      desc: '',
      args: [],
    );
  }

  /// `Confirm wholesale inventory rules`
  String get vCardWholesaleConfirmTitle {
    return Intl.message(
      'Confirm wholesale inventory rules',
      name: 'vCardWholesaleConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Only masked codes are shown by default. Full codes exist briefly in app memory and are cleared when you leave or background the app.`
  String get vCardInventoryDescription {
    return Intl.message(
      'Only masked codes are shown by default. Full codes exist briefly in app memory and are cleared when you leave or background the app.',
      name: 'vCardInventoryDescription',
      desc: '',
      args: [],
    );
  }

  /// `No cards in inventory yet. Cards appear here after payment and successful issuance.`
  String get vCardInventoryEmpty {
    return Intl.message(
      'No cards in inventory yet. Cards appear here after payment and successful issuance.',
      name: 'vCardInventoryEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Reveal full activation code`
  String get vCardRevealTitle {
    return Intl.message(
      'Reveal full activation code',
      name: 'vCardRevealTitle',
      desc: '',
      args: [],
    );
  }

  /// `Once a full activation code is revealed, it is considered delivered and is no longer refundable. Continue only when ready to store or distribute it securely.`
  String get vCardRevealIrreversible {
    return Intl.message(
      'Once a full activation code is revealed, it is considered delivered and is no longer refundable. Continue only when ready to store or distribute it securely.',
      name: 'vCardRevealIrreversible',
      desc: '',
      args: [],
    );
  }

  /// `Understand and continue`
  String get vCardRevealContinue {
    return Intl.message(
      'Understand and continue',
      name: 'vCardRevealContinue',
      desc: '',
      args: [],
    );
  }

  /// `Verify email to reveal`
  String get vCardRevealVerifyTitle {
    return Intl.message(
      'Verify email to reveal',
      name: 'vCardRevealVerifyTitle',
      desc: '',
      args: [],
    );
  }

  /// `A 6-digit code was sent to your verified email`
  String get vCardRevealVerifyHint {
    return Intl.message(
      'A 6-digit code was sent to your verified email',
      name: 'vCardRevealVerifyHint',
      desc: '',
      args: [],
    );
  }

  /// `Email verification code`
  String get vCardEmailCode {
    return Intl.message(
      'Email verification code',
      name: 'vCardEmailCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get vCardVerify {
    return Intl.message('Verify', name: 'vCardVerify', desc: '', args: []);
  }

  /// `Reveal full code`
  String get vCardRevealAction {
    return Intl.message(
      'Reveal full code',
      name: 'vCardRevealAction',
      desc: '',
      args: [],
    );
  }

  /// `Share explicitly`
  String get vCardShareExplicit {
    return Intl.message(
      'Share explicitly',
      name: 'vCardShareExplicit',
      desc: '',
      args: [],
    );
  }

  /// `Full activation code copied. Distribute it only through a trusted channel.`
  String get vCardShareExplicitDone {
    return Intl.message(
      'Full activation code copied. Distribute it only through a trusted channel.',
      name: 'vCardShareExplicitDone',
      desc: '',
      args: [],
    );
  }

  /// `Preview the plan and activation time before confirming. Confirmation never uploads the full code again.`
  String get vCardRedeemDescription {
    return Intl.message(
      'Preview the plan and activation time before confirming. Confirmation never uploads the full code again.',
      name: 'vCardRedeemDescription',
      desc: '',
      args: [],
    );
  }

  /// `Activation code`
  String get vCardActivationCode {
    return Intl.message(
      'Activation code',
      name: 'vCardActivationCode',
      desc: '',
      args: [],
    );
  }

  /// `Preview redemption`
  String get vCardPreviewRedeem {
    return Intl.message(
      'Preview redemption',
      name: 'vCardPreviewRedeem',
      desc: '',
      args: [],
    );
  }

  /// `This entitlement is scheduled to start on {date}.`
  String vCardRedeemScheduled(Object date) {
    return Intl.message(
      'This entitlement is scheduled to start on $date.',
      name: 'vCardRedeemScheduled',
      desc: '',
      args: [date],
    );
  }

  /// `This entitlement starts immediately after confirmation.`
  String get vCardRedeemImmediate {
    return Intl.message(
      'This entitlement starts immediately after confirmation.',
      name: 'vCardRedeemImmediate',
      desc: '',
      args: [],
    );
  }

  /// `Confirm redemption`
  String get vCardConfirmRedeem {
    return Intl.message(
      'Confirm redemption',
      name: 'vCardConfirmRedeem',
      desc: '',
      args: [],
    );
  }

  /// `Redemption accepted. The entitlement timeline was updated.`
  String get vCardRedeemSuccess {
    return Intl.message(
      'Redemption accepted. The entitlement timeline was updated.',
      name: 'vCardRedeemSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Current entitlements`
  String get vCardTimelineCurrent {
    return Intl.message(
      'Current entitlements',
      name: 'vCardTimelineCurrent',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming schedule`
  String get vCardTimelinePending {
    return Intl.message(
      'Upcoming schedule',
      name: 'vCardTimelinePending',
      desc: '',
      args: [],
    );
  }

  /// `No matching entitlements.`
  String get vCardTimelineEmpty {
    return Intl.message(
      'No matching entitlements.',
      name: 'vCardTimelineEmpty',
      desc: '',
      args: [],
    );
  }

  /// `{start} to {end}`
  String vCardTimelinePeriod(Object start, Object end) {
    return Intl.message(
      '$start to $end',
      name: 'vCardTimelinePeriod',
      desc: '',
      args: [start, end],
    );
  }

  /// `Available`
  String get vCardStatusAvailable {
    return Intl.message(
      'Available',
      name: 'vCardStatusAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Redeemed`
  String get vCardStatusRedeemed {
    return Intl.message(
      'Redeemed',
      name: 'vCardStatusRedeemed',
      desc: '',
      args: [],
    );
  }

  /// `Revoked`
  String get vCardStatusRevoked {
    return Intl.message(
      'Revoked',
      name: 'vCardStatusRevoked',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get vCardStatusActive {
    return Intl.message(
      'Active',
      name: 'vCardStatusActive',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled`
  String get vCardStatusScheduled {
    return Intl.message(
      'Scheduled',
      name: 'vCardStatusScheduled',
      desc: '',
      args: [],
    );
  }

  /// `Paused`
  String get vCardStatusPaused {
    return Intl.message(
      'Paused',
      name: 'vCardStatusPaused',
      desc: '',
      args: [],
    );
  }

  /// `Activation pending`
  String get vCardStatusActivationPending {
    return Intl.message(
      'Activation pending',
      name: 'vCardStatusActivationPending',
      desc: '',
      args: [],
    );
  }

  /// `Awaiting payment`
  String get vCardStatusWaiting {
    return Intl.message(
      'Awaiting payment',
      name: 'vCardStatusWaiting',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get vCardStatusPaid {
    return Intl.message('Paid', name: 'vCardStatusPaid', desc: '', args: []);
  }

  /// `Expired`
  String get vCardStatusExpired {
    return Intl.message(
      'Expired',
      name: 'vCardStatusExpired',
      desc: '',
      args: [],
    );
  }

  /// `Awaiting issuance`
  String get vCardStatusNotStarted {
    return Intl.message(
      'Awaiting issuance',
      name: 'vCardStatusNotStarted',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get vCardStatusProcessing {
    return Intl.message(
      'Processing',
      name: 'vCardStatusProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Issued`
  String get vCardStatusSucceeded {
    return Intl.message(
      'Issued',
      name: 'vCardStatusSucceeded',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get vCardStatusFailed {
    return Intl.message(
      'Failed',
      name: 'vCardStatusFailed',
      desc: '',
      args: [],
    );
  }

  /// `Card order #{id}`
  String vCardOrderTitle(Object id) {
    return Intl.message(
      'Card order #$id',
      name: 'vCardOrderTitle',
      desc: '',
      args: [id],
    );
  }

  /// `Payment: {payment} · Issuance: {issuance}`
  String vCardOrderState(Object payment, Object issuance) {
    return Intl.message(
      'Payment: $payment · Issuance: $issuance',
      name: 'vCardOrderState',
      desc: '',
      args: [payment, issuance],
    );
  }

  /// `Copy amount`
  String get vCardCopyAmount {
    return Intl.message(
      'Copy amount',
      name: 'vCardCopyAmount',
      desc: '',
      args: [],
    );
  }

  /// `Copy address`
  String get vCardCopyAddress {
    return Intl.message(
      'Copy address',
      name: 'vCardCopyAddress',
      desc: '',
      args: [],
    );
  }

  /// `Use USDT-TRC20 and transfer the exact amount shown. Pay exchange fees separately so the received amount is not short.`
  String get vCardPaymentWarning {
    return Intl.message(
      'Use USDT-TRC20 and transfer the exact amount shown. Pay exchange fees separately so the received amount is not short.',
      name: 'vCardPaymentWarning',
      desc: '',
      args: [],
    );
  }

  /// `I paid / submit transaction hash`
  String get vCardClaimTitle {
    return Intl.message(
      'I paid / submit transaction hash',
      name: 'vCardClaimTitle',
      desc: '',
      args: [],
    );
  }

  /// `Transaction hash`
  String get vCardTxHash {
    return Intl.message(
      'Transaction hash',
      name: 'vCardTxHash',
      desc: '',
      args: [],
    );
  }

  /// `Submit for verification`
  String get vCardClaimSubmit {
    return Intl.message(
      'Submit for verification',
      name: 'vCardClaimSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Payment confirmed. Issuing cards securely…`
  String get vCardIssuing {
    return Intl.message(
      'Payment confirmed. Issuing cards securely…',
      name: 'vCardIssuing',
      desc: '',
      args: [],
    );
  }

  /// `Cards issued`
  String get vCardIssuedTitle {
    return Intl.message(
      'Cards issued',
      name: 'vCardIssuedTitle',
      desc: '',
      args: [],
    );
  }

  /// `{count} membership cards are now in your inventory.`
  String vCardIssuedDescription(Object count) {
    return Intl.message(
      '$count membership cards are now in your inventory.',
      name: 'vCardIssuedDescription',
      desc: '',
      args: [count],
    );
  }

  /// `View card inventory`
  String get vCardViewInventory {
    return Intl.message(
      'View card inventory',
      name: 'vCardViewInventory',
      desc: '',
      args: [],
    );
  }

  /// `This order expired. Return and create a new order; late payments follow the existing funding rules.`
  String get vCardOrderExpired {
    return Intl.message(
      'This order expired. Return and create a new order; late payments follow the existing funding rules.',
      name: 'vCardOrderExpired',
      desc: '',
      args: [],
    );
  }

  /// `Status check temporarily failed. The app will keep retrying.`
  String get vCardOrderPollFailed {
    return Intl.message(
      'Status check temporarily failed. The app will keep retrying.',
      name: 'vCardOrderPollFailed',
      desc: '',
      args: [],
    );
  }

  /// `The membership card operation failed. Please try again.`
  String get vCardGenericError {
    return Intl.message(
      'The membership card operation failed. Please try again.',
      name: 'vCardGenericError',
      desc: '',
      args: [],
    );
  }

  /// `Membership cards or sales are not currently available. Please try again later.`
  String get vCardUnavailableSales {
    return Intl.message(
      'Membership cards or sales are not currently available. Please try again later.',
      name: 'vCardUnavailableSales',
      desc: '',
      args: [],
    );
  }

  /// `Bulk card purchases are currently disabled. Reduce the quantity and request a new quote.`
  String get vCardUnavailableBulk {
    return Intl.message(
      'Bulk card purchases are currently disabled. Reduce the quantity and request a new quote.',
      name: 'vCardUnavailableBulk',
      desc: '',
      args: [],
    );
  }

  /// `The quote changed. Request a fresh quote before confirming.`
  String get vCardErrQuoteChanged {
    return Intl.message(
      'The quote changed. Request a fresh quote before confirming.',
      name: 'vCardErrQuoteChanged',
      desc: '',
      args: [],
    );
  }

  /// `You have reached the pending card order limit. Complete an existing order first.`
  String get vCardErrOpenOrderLimit {
    return Intl.message(
      'You have reached the pending card order limit. Complete an existing order first.',
      name: 'vCardErrOpenOrderLimit',
      desc: '',
      args: [],
    );
  }

  /// `The purchaser cannot redeem wholesale inventory cards. Distribute them to end users.`
  String get vCardErrWholesaleSelf {
    return Intl.message(
      'The purchaser cannot redeem wholesale inventory cards. Distribute them to end users.',
      name: 'vCardErrWholesaleSelf',
      desc: '',
      args: [],
    );
  }

  /// `Card redemption is temporarily frozen. Please try again later.`
  String get vCardErrRedemptionFrozen {
    return Intl.message(
      'Card redemption is temporarily frozen. Please try again later.',
      name: 'vCardErrRedemptionFrozen',
      desc: '',
      args: [],
    );
  }

  /// `The redemption preview expired. Enter the activation code again.`
  String get vCardErrPreviewExpired {
    return Intl.message(
      'The redemption preview expired. Enter the activation code again.',
      name: 'vCardErrPreviewExpired',
      desc: '',
      args: [],
    );
  }

  /// `This redemption preview was already used. Do not submit it again.`
  String get vCardErrPreviewConsumed {
    return Intl.message(
      'This redemption preview was already used. Do not submit it again.',
      name: 'vCardErrPreviewConsumed',
      desc: '',
      args: [],
    );
  }

  /// `The entitlement schedule changed. Preview again before confirming.`
  String get vCardErrScheduleChanged {
    return Intl.message(
      'The entitlement schedule changed. Preview again before confirming.',
      name: 'vCardErrScheduleChanged',
      desc: '',
      args: [],
    );
  }

  /// `Verify your linked email before revealing a full activation code.`
  String get vCardErrRevealAuth {
    return Intl.message(
      'Verify your linked email before revealing a full activation code.',
      name: 'vCardErrRevealAuth',
      desc: '',
      args: [],
    );
  }

  /// `This reveal authorization expired. Verify again.`
  String get vCardErrRevealExpired {
    return Intl.message(
      'This reveal authorization expired. Verify again.',
      name: 'vCardErrRevealExpired',
      desc: '',
      args: [],
    );
  }

  /// `This card cannot currently be viewed or operated on.`
  String get vCardErrUnavailable {
    return Intl.message(
      'This card cannot currently be viewed or operated on.',
      name: 'vCardErrUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Card export is currently unavailable.`
  String get vCardErrExportUnavailable {
    return Intl.message(
      'Card export is currently unavailable.',
      name: 'vCardErrExportUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get vHelpTitle {
    return Intl.message('Help Center', name: 'vHelpTitle', desc: '', args: []);
  }

  /// `Outbound mode decides how traffic that has entered Verstro leaves your device; System proxy and Virtual NIC decide which traffic enters Verstro. This help is available offline.`
  String get vHelpIntro {
    return Intl.message(
      'Outbound mode decides how traffic that has entered Verstro leaves your device; System proxy and Virtual NIC decide which traffic enters Verstro. This help is available offline.',
      name: 'vHelpIntro',
      desc: '',
      args: [],
    );
  }

  /// `Quick start`
  String get vHelpQuickTitle {
    return Intl.message(
      'Quick start',
      name: 'vHelpQuickTitle',
      desc: '',
      args: [],
    );
  }

  /// `After signing in and confirming that your subscription is active, choose a node, keep Smart routing selected, and tap Connect. Tap Disconnect to stop. Authorize the system prompt when using Virtual NIC or the system VPN for the first time.`
  String get vHelpQuickBody {
    return Intl.message(
      'After signing in and confirming that your subscription is active, choose a node, keep Smart routing selected, and tap Connect. Tap Disconnect to stop. Authorize the system prompt when using Virtual NIC or the system VPN for the first time.',
      name: 'vHelpQuickBody',
      desc: '',
      args: [],
    );
  }

  /// `Outbound modes`
  String get vHelpOutboundTitle {
    return Intl.message(
      'Outbound modes',
      name: 'vHelpOutboundTitle',
      desc: '',
      args: [],
    );
  }

  /// `Outbound modes decide only how traffic already inside Verstro leaves the device; they do not decide which apps or system traffic enter Verstro.`
  String get vHelpOutboundIntro {
    return Intl.message(
      'Outbound modes decide only how traffic already inside Verstro leaves the device; they do not decide which apps or system traffic enter Verstro.',
      name: 'vHelpOutboundIntro',
      desc: '',
      args: [],
    );
  }

  /// `Smart routing`
  String get vHelpSmartTitle {
    return Intl.message(
      'Smart routing',
      name: 'vHelpSmartTitle',
      desc: '',
      args: [],
    );
  }

  /// `Rules keep local networks, LAN resources, and services suitable for direct access direct, while traffic that needs a proxy uses a node. This usually reduces latency and data use and helps reach printers and NAS devices, so it is recommended for everyday use.`
  String get vHelpSmartBody {
    return Intl.message(
      'Rules keep local networks, LAN resources, and services suitable for direct access direct, while traffic that needs a proxy uses a node. This usually reduces latency and data use and helps reach printers and NAS devices, so it is recommended for everyday use.',
      name: 'vHelpSmartBody',
      desc: '',
      args: [],
    );
  }

  /// `Global proxy`
  String get vHelpGlobalTitle {
    return Intl.message(
      'Global proxy',
      name: 'vHelpGlobalTitle',
      desc: '',
      args: [],
    );
  }

  /// `Routes internet traffic that has already entered Verstro through the current node, while preserving system addresses, LAN traffic, and required bypasses. It does not automatically take over the whole device and is not necessarily faster. Use it for an inaccessible service, a consistent egress IP, development tests, or temporary troubleshooting, then return to Smart routing.`
  String get vHelpGlobalBody {
    return Intl.message(
      'Routes internet traffic that has already entered Verstro through the current node, while preserving system addresses, LAN traffic, and required bypasses. It does not automatically take over the whole device and is not necessarily faster. Use it for an inaccessible service, a consistent egress IP, development tests, or temporary troubleshooting, then return to Smart routing.',
      name: 'vHelpGlobalBody',
      desc: '',
      args: [],
    );
  }

  /// `Traffic coverage`
  String get vHelpCoverageTitle {
    return Intl.message(
      'Traffic coverage',
      name: 'vHelpCoverageTitle',
      desc: '',
      args: [],
    );
  }

  /// `System proxy`
  String get vHelpSystemProxyTitle {
    return Intl.message(
      'System proxy',
      name: 'vHelpSystemProxyTitle',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, Verstro writes the operating-system proxy settings, so browsers and other apps that honor the system proxy enter Verstro. When disabled, they no longer enter by that route. It needs no virtual adapter and fewer permissions, but terminals, Git, Docker, games, and some desktop apps may ignore it.`
  String get vHelpSystemProxyBody {
    return Intl.message(
      'When enabled, Verstro writes the operating-system proxy settings, so browsers and other apps that honor the system proxy enter Verstro. When disabled, they no longer enter by that route. It needs no virtual adapter and fewer permissions, but terminals, Git, Docker, games, and some desktop apps may ignore it.',
      name: 'vHelpSystemProxyBody',
      desc: '',
      args: [],
    );
  }

  /// `Virtual NIC (TUN)`
  String get vHelpTunTitle {
    return Intl.message(
      'Virtual NIC (TUN)',
      name: 'vHelpTunTitle',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, it creates a virtual network interface and takes traffic at the system network layer, including apps that do not read the system proxy. When disabled, it no longer provides system-level coverage; only the system proxy or manually configured app paths remain. It suits terminals, Git, brew, Docker, Electron, and similar apps. The first use may need administrator approval and can conflict with other VPNs, proxies, or security software. A Virtual NIC can work with Smart routing; it is not Global proxy.`
  String get vHelpTunBody {
    return Intl.message(
      'When enabled, it creates a virtual network interface and takes traffic at the system network layer, including apps that do not read the system proxy. When disabled, it no longer provides system-level coverage; only the system proxy or manually configured app paths remain. It suits terminals, Git, brew, Docker, Electron, and similar apps. The first use may need administrator approval and can conflict with other VPNs, proxies, or security software. A Virtual NIC can work with Smart routing; it is not Global proxy.',
      name: 'vHelpTunBody',
      desc: '',
      args: [],
    );
  }

  /// `Recommended everyday setup: Smart routing + System proxy on + Virtual NIC on.`
  String get vHelpDesktopRecommended {
    return Intl.message(
      'Recommended everyday setup: Smart routing + System proxy on + Virtual NIC on.',
      name: 'vHelpDesktopRecommended',
      desc: '',
      args: [],
    );
  }

  /// `System proxy on / Virtual NIC on: browsers and similar apps use the system proxy, while the Virtual NIC adds coverage for other traffic. This is the most complete coverage and is recommended for everyday use.\n\nSystem proxy on / Virtual NIC off: only apps that honor the system proxy are covered. Use this without administrator permission or when only a browser needs it.\n\nSystem proxy off / Virtual NIC on: the Virtual NIC primarily covers device traffic. This suits advanced users or troubleshooting a system-proxy conflict.\n\nSystem proxy off / Virtual NIC off: Verstro does not actively take over most system traffic. This is normally not recommended and is for troubleshooting only.`
  String get vHelpDesktopCombinations {
    return Intl.message(
      'System proxy on / Virtual NIC on: browsers and similar apps use the system proxy, while the Virtual NIC adds coverage for other traffic. This is the most complete coverage and is recommended for everyday use.\n\nSystem proxy on / Virtual NIC off: only apps that honor the system proxy are covered. Use this without administrator permission or when only a browser needs it.\n\nSystem proxy off / Virtual NIC on: the Virtual NIC primarily covers device traffic. This suits advanced users or troubleshooting a system-proxy conflict.\n\nSystem proxy off / Virtual NIC off: Verstro does not actively take over most system traffic. This is normally not recommended and is for troubleshooting only.',
      name: 'vHelpDesktopCombinations',
      desc: '',
      args: [],
    );
  }

  /// `System VPN tunnel`
  String get vHelpMobileVpnTitle {
    return Intl.message(
      'System VPN tunnel',
      name: 'vHelpMobileVpnTitle',
      desc: '',
      args: [],
    );
  }

  /// `Android and iOS use the system VPN tunnel for traffic coverage. Approve the system prompt on the first connection. On mobile, choose an outbound mode and node; the desktop System proxy and Virtual NIC switches are not shown.`
  String get vHelpMobileVpnBody {
    return Intl.message(
      'Android and iOS use the system VPN tunnel for traffic coverage. Approve the system prompt on the first connection. On mobile, choose an outbound mode and node; the desktop System proxy and Virtual NIC switches are not shown.',
      name: 'vHelpMobileVpnBody',
      desc: '',
      args: [],
    );
  }

  /// `Nodes and routes`
  String get vHelpNodesTitle {
    return Intl.message(
      'Nodes and routes',
      name: 'vHelpNodesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Prefer automatic selection to balance latency and availability. If a service behaves unexpectedly, manually choose another node and reconnect. Node availability changes with the network environment.`
  String get vHelpNodesBody {
    return Intl.message(
      'Prefer automatic selection to balance latency and availability. If a service behaves unexpectedly, manually choose another node and reconnect. Node availability changes with the network environment.',
      name: 'vHelpNodesBody',
      desc: '',
      args: [],
    );
  }

  /// `Account, subscription, and devices`
  String get vHelpAccountTitle {
    return Intl.message(
      'Account, subscription, and devices',
      name: 'vHelpAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Use the account page to review subscription status, expiry, and signed-in devices. Sign in only on your own devices. For a subscription or device issue, first confirm the account and network state.`
  String get vHelpAccountBody {
    return Intl.message(
      'Use the account page to review subscription status, expiry, and signed-in devices. Sign in only on your own devices. For a subscription or device issue, first confirm the account and network state.',
      name: 'vHelpAccountBody',
      desc: '',
      args: [],
    );
  }

  /// `Purchase and payment`
  String get vHelpPaymentTitle {
    return Intl.message(
      'Purchase and payment',
      name: 'vHelpPaymentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Check the plan, amount, and network before ordering. Pay only with the network and exact amount shown on the page, then wait for on-chain confirmation. For an unusual order, contact support with the order details.`
  String get vHelpPaymentBody {
    return Intl.message(
      'Check the plan, amount, and network before ordering. Pay only with the network and exact amount shown on the page, then wait for on-chain confirmation. For an unusual order, contact support with the order details.',
      name: 'vHelpPaymentBody',
      desc: '',
      args: [],
    );
  }

  /// `Updates and installation help`
  String get vHelpUpdateTitle {
    return Intl.message(
      'Updates and installation help',
      name: 'vHelpUpdateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Download updates from official sources. If installation or an upgrade fails, check storage, system permissions, and the package source. Do not use modified packages from unknown sources.`
  String get vHelpUpdateBody {
    return Intl.message(
      'Download updates from official sources. If installation or an upgrade fails, check storage, system permissions, and the package source. Do not use modified packages from unknown sources.',
      name: 'vHelpUpdateBody',
      desc: '',
      args: [],
    );
  }

  /// `FAQ and troubleshooting`
  String get vHelpFaqTitle {
    return Intl.message(
      'FAQ and troubleshooting',
      name: 'vHelpFaqTitle',
      desc: '',
      args: [],
    );
  }

  /// `What is the difference between Smart routing and Global proxy?`
  String get vHelpFaqModeDifferenceQ {
    return Intl.message(
      'What is the difference between Smart routing and Global proxy?',
      name: 'vHelpFaqModeDifferenceQ',
      desc: '',
      args: [],
    );
  }

  /// `Smart routing uses rules to choose direct access or a node. Global proxy sends internet traffic that has already entered Verstro through the current node. Global proxy does not expand traffic coverage by itself, so Smart routing is preferred for everyday use.`
  String get vHelpFaqModeDifferenceA {
    return Intl.message(
      'Smart routing uses rules to choose direct access or a node. Global proxy sends internet traffic that has already entered Verstro through the current node. Global proxy does not expand traffic coverage by itself, so Smart routing is preferred for everyday use.',
      name: 'vHelpFaqModeDifferenceA',
      desc: '',
      args: [],
    );
  }

  /// `Does Global proxy mean the entire device uses a proxy?`
  String get vHelpFaqGlobalCoverageQ {
    return Intl.message(
      'Does Global proxy mean the entire device uses a proxy?',
      name: 'vHelpFaqGlobalCoverageQ',
      desc: '',
      args: [],
    );
  }

  /// `No. Global proxy affects only traffic that has already entered Verstro. System proxy and Virtual NIC decide which app or system traffic enters it. For broader desktop coverage, turn on both; on mobile, the system VPN tunnel provides coverage.`
  String get vHelpFaqGlobalCoverageA {
    return Intl.message(
      'No. Global proxy affects only traffic that has already entered Verstro. System proxy and Virtual NIC decide which app or system traffic enters it. For broader desktop coverage, turn on both; on mobile, the system VPN tunnel provides coverage.',
      name: 'vHelpFaqGlobalCoverageA',
      desc: '',
      args: [],
    );
  }

  /// `Do System proxy and Virtual NIC both need to be enabled?`
  String get vHelpFaqProxyAndTunQ {
    return Intl.message(
      'Do System proxy and Virtual NIC both need to be enabled?',
      name: 'vHelpFaqProxyAndTunQ',
      desc: '',
      args: [],
    );
  }

  /// `For everyday use, enable both: System proxy covers apps that honor it, and Virtual NIC adds other apps. If Virtual NIC conflicts with another VPN, proxy, or security software, temporarily disable Virtual NIC and keep System proxy enabled. You may also use only System proxy without administrator permission or when you only need browser proxying.`
  String get vHelpFaqProxyAndTunA {
    return Intl.message(
      'For everyday use, enable both: System proxy covers apps that honor it, and Virtual NIC adds other apps. If Virtual NIC conflicts with another VPN, proxy, or security software, temporarily disable Virtual NIC and keep System proxy enabled. You may also use only System proxy without administrator permission or when you only need browser proxying.',
      name: 'vHelpFaqProxyAndTunA',
      desc: '',
      args: [],
    );
  }

  /// `It says connected, but my IP or some apps have not changed. What should I do?`
  String get vHelpFaqConnectedNoEffectQ {
    return Intl.message(
      'It says connected, but my IP or some apps have not changed. What should I do?',
      name: 'vHelpFaqConnectedNoEffectQ',
      desc: '',
      args: [],
    );
  }

  /// `First check the System proxy and Virtual NIC switches, the current outbound mode, node, and other VPNs, then disconnect and reconnect. If it persists, confirm whether the app honors the system proxy; on desktop, enable Virtual NIC or temporarily use Global proxy to diagnose it, then restore Smart routing.`
  String get vHelpFaqConnectedNoEffectA {
    return Intl.message(
      'First check the System proxy and Virtual NIC switches, the current outbound mode, node, and other VPNs, then disconnect and reconnect. If it persists, confirm whether the app honors the system proxy; on desktop, enable Virtual NIC or temporarily use Global proxy to diagnose it, then restore Smart routing.',
      name: 'vHelpFaqConnectedNoEffectA',
      desc: '',
      args: [],
    );
  }

  /// `Why does Virtual NIC need administrator permission?`
  String get vHelpFaqTunPermissionQ {
    return Intl.message(
      'Why does Virtual NIC need administrator permission?',
      name: 'vHelpFaqTunPermissionQ',
      desc: '',
      args: [],
    );
  }

  /// `Virtual NIC creates or changes a system network interface, so its first use may request administrator approval. Approve only a system prompt you recognize as Verstro. Verstro never asks for or receives your account or administrator password. Without permission, use System proxy first.`
  String get vHelpFaqTunPermissionA {
    return Intl.message(
      'Virtual NIC creates or changes a system network interface, so its first use may request administrator approval. Approve only a system prompt you recognize as Verstro. Verstro never asks for or receives your account or administrator password. Without permission, use System proxy first.',
      name: 'vHelpFaqTunPermissionA',
      desc: '',
      args: [],
    );
  }

  /// `When should I temporarily disable Virtual NIC?`
  String get vHelpFaqDisableTunQ {
    return Intl.message(
      'When should I temporarily disable Virtual NIC?',
      name: 'vHelpFaqDisableTunQ',
      desc: '',
      args: [],
    );
  }

  /// `Temporarily disable Virtual NIC and keep System proxy enabled if it conflicts with another VPN, proxy, or security software, if sleep or wake recovery is abnormal, or if you only need browser proxying. Re-enable Virtual NIC after diagnosing the issue to restore broader coverage.`
  String get vHelpFaqDisableTunA {
    return Intl.message(
      'Temporarily disable Virtual NIC and keep System proxy enabled if it conflicts with another VPN, proxy, or security software, if sleep or wake recovery is abnormal, or if you only need browser proxying. Re-enable Virtual NIC after diagnosing the issue to restore broader coverage.',
      name: 'vHelpFaqDisableTunA',
      desc: '',
      args: [],
    );
  }

  /// `How do I restore the recommended configuration?`
  String get vHelpFaqRestoreRecommendedQ {
    return Intl.message(
      'How do I restore the recommended configuration?',
      name: 'vHelpFaqRestoreRecommendedQ',
      desc: '',
      args: [],
    );
  }

  /// `On desktop, select Smart routing, enable System proxy and Virtual NIC, then disconnect and reconnect. On mobile, select Smart routing and an appropriate node, and confirm that system VPN permission is still granted.`
  String get vHelpFaqRestoreRecommendedA {
    return Intl.message(
      'On desktop, select Smart routing, enable System proxy and Virtual NIC, then disconnect and reconnect. On mobile, select Smart routing and an appropriate node, and confirm that system VPN permission is still granted.',
      name: 'vHelpFaqRestoreRecommendedA',
      desc: '',
      args: [],
    );
  }

  /// `Why are System proxy and Virtual NIC not shown on mobile?`
  String get vHelpFaqMobileTogglesQ {
    return Intl.message(
      'Why are System proxy and Virtual NIC not shown on mobile?',
      name: 'vHelpFaqMobileTogglesQ',
      desc: '',
      args: [],
    );
  }

  /// `Android and iOS use the system VPN tunnel to cover traffic instead of those desktop switches. Grant VPN permission when prompted, then choose an outbound mode and node.`
  String get vHelpFaqMobileTogglesA {
    return Intl.message(
      'Android and iOS use the system VPN tunnel to cover traffic instead of those desktop switches. Grant VPN permission when prompted, then choose an outbound mode and node.',
      name: 'vHelpFaqMobileTogglesA',
      desc: '',
      args: [],
    );
  }

  /// `Support and feedback`
  String get vHelpContactTitle {
    return Intl.message(
      'Support and feedback',
      name: 'vHelpContactTitle',
      desc: '',
      args: [],
    );
  }

  /// `Use the public group only for general troubleshooting and share your platform, app version, error text, and when it happened. Send order-related sensitive details by private email instead.`
  String get vHelpContactBody {
    return Intl.message(
      'Use the public group only for general troubleshooting and share your platform, app version, error text, and when it happened. Send order-related sensitive details by private email instead.',
      name: 'vHelpContactBody',
      desc: '',
      args: [],
    );
  }

  /// `Telegram community group`
  String get vSupportCommunityTitle {
    return Intl.message(
      'Telegram community group',
      name: 'vSupportCommunityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Public-group privacy reminder: do not post email addresses, order numbers, TXIDs, wallet screenshots, card codes, subscription links, passwords, verification codes, private keys, or recovery phrases. You may share your platform, version, error text, and when it happened.`
  String get vSupportPublicGroupPrivacy {
    return Intl.message(
      'Public-group privacy reminder: do not post email addresses, order numbers, TXIDs, wallet screenshots, card codes, subscription links, passwords, verification codes, private keys, or recovery phrases. You may share your platform, version, error text, and when it happened.',
      name: 'vSupportPublicGroupPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Sensitive details may be sent privately to feedback@verstro.com, but never send passwords, verification codes, private keys, or recovery phrases.`
  String get vSupportFeedbackPrivacy {
    return Intl.message(
      'Sensitive details may be sent privately to feedback@verstro.com, but never send passwords, verification codes, private keys, or recovery phrases.',
      name: 'vSupportFeedbackPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Open full web help`
  String get vHelpWebTitle {
    return Intl.message(
      'Open full web help',
      name: 'vHelpWebTitle',
      desc: '',
      args: [],
    );
  }

  /// `Open the website help center in your system browser.`
  String get vHelpWebSubtitle {
    return Intl.message(
      'Open the website help center in your system browser.',
      name: 'vHelpWebSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Replay onboarding`
  String get vHelpReplayTitle {
    return Intl.message(
      'Replay onboarding',
      name: 'vHelpReplayTitle',
      desc: '',
      args: [],
    );
  }

  /// `Review connection, mode, and platform guidance without changing your current network settings.`
  String get vHelpReplaySubtitle {
    return Intl.message(
      'Review connection, mode, and platform guidance without changing your current network settings.',
      name: 'vHelpReplaySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get vOnboardingConnectTitle {
    return Intl.message(
      'Connect',
      name: 'vOnboardingConnectTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tap the Connect button on the main screen to connect or disconnect. The first use may request system permission.`
  String get vOnboardingConnectDesktopBody {
    return Intl.message(
      'Tap the Connect button on the main screen to connect or disconnect. The first use may request system permission.',
      name: 'vOnboardingConnectDesktopBody',
      desc: '',
      args: [],
    );
  }

  /// `Tap the Connect button on the main screen to connect or disconnect. The first connection may request system VPN permission.`
  String get vOnboardingConnectMobileBody {
    return Intl.message(
      'Tap the Connect button on the main screen to connect or disconnect. The first connection may request system VPN permission.',
      name: 'vOnboardingConnectMobileBody',
      desc: '',
      args: [],
    );
  }

  /// `Smart routing is recommended for everyday use. Use Global proxy temporarily only for a consistent egress or troubleshooting.`
  String get vOnboardingOutboundBody {
    return Intl.message(
      'Smart routing is recommended for everyday use. Use Global proxy temporarily only for a consistent egress or troubleshooting.',
      name: 'vOnboardingOutboundBody',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get vOnboardingHelpTitle {
    return Intl.message(
      'Help',
      name: 'vOnboardingHelpTitle',
      desc: '',
      args: [],
    );
  }

  /// `Replay this later from the dashboard question-mark button or Settings → Help Center.`
  String get vOnboardingHelpBody {
    return Intl.message(
      'Replay this later from the dashboard question-mark button or Settings → Help Center.',
      name: 'vOnboardingHelpBody',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get vOnboardingSkip {
    return Intl.message('Skip', name: 'vOnboardingSkip', desc: '', args: []);
  }

  /// `Back`
  String get vOnboardingBack {
    return Intl.message('Back', name: 'vOnboardingBack', desc: '', args: []);
  }

  /// `Next`
  String get vOnboardingNext {
    return Intl.message('Next', name: 'vOnboardingNext', desc: '', args: []);
  }

  /// `Finish`
  String get vOnboardingFinish {
    return Intl.message(
      'Finish',
      name: 'vOnboardingFinish',
      desc: '',
      args: [],
    );
  }

  /// `Open Help Center`
  String get vOnboardingOpenHelp {
    return Intl.message(
      'Open Help Center',
      name: 'vOnboardingOpenHelp',
      desc: '',
      args: [],
    );
  }

  /// `Could not open the link. Please try again later.`
  String get vHelpOpenLinkFailed {
    return Intl.message(
      'Could not open the link. Please try again later.',
      name: 'vHelpOpenLinkFailed',
      desc: '',
      args: [],
    );
  }

  /// `Promotions`
  String get vPromotionTitle {
    return Intl.message(
      'Promotions',
      name: 'vPromotionTitle',
      desc: '',
      args: [],
    );
  }

  /// `My promotions`
  String get vPromotionMyEntryTitle {
    return Intl.message(
      'My promotions',
      name: 'vPromotionMyEntryTitle',
      desc: '',
      args: [],
    );
  }

  /// `View available, used, and expired offers`
  String get vPromotionMyEntrySubtitle {
    return Intl.message(
      'View available, used, and expired offers',
      name: 'vPromotionMyEntrySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Current offers`
  String get vPromotionPublicTitle {
    return Intl.message(
      'Current offers',
      name: 'vPromotionPublicTitle',
      desc: '',
      args: [],
    );
  }

  /// `The server automatically applies your best available offer at checkout.`
  String get vPromotionAutomaticBest {
    return Intl.message(
      'The server automatically applies your best available offer at checkout.',
      name: 'vPromotionAutomaticBest',
      desc: '',
      args: [],
    );
  }

  /// `Offer available`
  String get vPromotionBadge {
    return Intl.message(
      'Offer available',
      name: 'vPromotionBadge',
      desc: '',
      args: [],
    );
  }

  /// `Apply code`
  String get vPromotionApply {
    return Intl.message(
      'Apply code',
      name: 'vPromotionApply',
      desc: '',
      args: [],
    );
  }

  /// `Getting quote…`
  String get vPromotionApplying {
    return Intl.message(
      'Getting quote…',
      name: 'vPromotionApplying',
      desc: '',
      args: [],
    );
  }

  /// `Coupon code (optional)`
  String get vPromotionCodeHint {
    return Intl.message(
      'Coupon code (optional)',
      name: 'vPromotionCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `Original price`
  String get vPromotionQuoteBase {
    return Intl.message(
      'Original price',
      name: 'vPromotionQuoteBase',
      desc: '',
      args: [],
    );
  }

  /// `Promotion`
  String get vPromotionQuoteDiscount {
    return Intl.message(
      'Promotion',
      name: 'vPromotionQuoteDiscount',
      desc: '',
      args: [],
    );
  }

  /// `After promotion`
  String get vPromotionQuoteAfter {
    return Intl.message(
      'After promotion',
      name: 'vPromotionQuoteAfter',
      desc: '',
      args: [],
    );
  }

  /// `No additional promotion applies to this plan.`
  String get vPromotionNoDiscount {
    return Intl.message(
      'No additional promotion applies to this plan.',
      name: 'vPromotionNoDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get vPromotionAvailable {
    return Intl.message(
      'Available',
      name: 'vPromotionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get vPromotionUnavailable {
    return Intl.message(
      'Unavailable',
      name: 'vPromotionUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Used`
  String get vPromotionUsed {
    return Intl.message('Used', name: 'vPromotionUsed', desc: '', args: []);
  }

  /// `Released`
  String get vPromotionReleased {
    return Intl.message(
      'Released',
      name: 'vPromotionReleased',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get vPromotionHeld {
    return Intl.message(
      'Processing',
      name: 'vPromotionHeld',
      desc: '',
      args: [],
    );
  }

  /// `No visible promotions or redemption history yet.`
  String get vPromotionEmpty {
    return Intl.message(
      'No visible promotions or redemption history yet.',
      name: 'vPromotionEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Promotions are not supported by this server version.`
  String get vPromotionUnsupported {
    return Intl.message(
      'Promotions are not supported by this server version.',
      name: 'vPromotionUnsupported',
      desc: '',
      args: [],
    );
  }

  /// `Saved {amount}`
  String vPromotionDiscountRecord(Object amount) {
    return Intl.message(
      'Saved $amount',
      name: 'vPromotionDiscountRecord',
      desc: '',
      args: [amount],
    );
  }

  /// `The quote expired. Refreshing it once…`
  String get vPromotionQuoteExpired {
    return Intl.message(
      'The quote expired. Refreshing it once…',
      name: 'vPromotionQuoteExpired',
      desc: '',
      args: [],
    );
  }

  /// `Unable to get a promotion quote: {error}`
  String vPromotionQuoteFailed(Object error) {
    return Intl.message(
      'Unable to get a promotion quote: $error',
      name: 'vPromotionQuoteFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Promotion discount`
  String get vPayPromotionDiscountLabel {
    return Intl.message(
      'Promotion discount',
      name: 'vPayPromotionDiscountLabel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
