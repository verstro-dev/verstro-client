// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) =>
      "${Intl.plural(count, one: '1 day ago', other: '${count} days ago')}";

  static String m1(label) =>
      "Are you sure you want to delete the selected ${label}?";

  static String m2(label) =>
      "Are you sure you want to delete the current ${label}?";

  static String m3(label) => "${label} details";

  static String m4(label) => "${label} cannot be empty";

  static String m5(label) => "Current ${label} already exists";

  static String m6(count) =>
      "${Intl.plural(count, one: '1 hour ago', other: '${count} hours ago')}";

  static String m7(count) =>
      "${Intl.plural(count, one: '1 minute ago', other: '${count} minutes ago')}";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 month ago', other: '${count} months ago')}";

  static String m9(label) => "No ${label} yet";

  static String m10(label) => "${label} must be a number";

  static String m11(label) => "${label} must be between 1024 and 49151";

  static String m12(count) => "${count} items have been selected";

  static String m13(label) => "${label} must be a url";

  static String m14(url) => "Cannot open: ${url}";

  static String m15(days) => "Active ${days} day(s) ago";

  static String m16(hours) => "Active ${hours} hour(s) ago";

  static String m17(minutes) => "Active ${minutes} minute(s) ago";

  static String m18(count) =>
      "Invite friends to earn 30% commission · ${count} invited";

  static String m19(amount) => "Withdrawable ${amount}";

  static String m20(amount) => "Balance: ${amount}";

  static String m21(error) => "Startup failed: ${error}";

  static String m22(days) => "in ${days} day(s)";

  static String m23(count, max) => "${count} / ${max} device(s) registered";

  static String m24(count) => "${count} device(s) registered";

  static String m25(date) => "Expires ${date}";

  static String m26(hours) => "in ${hours} hour(s)";

  static String m27(name) =>
      "\"${name}\" will be removed and will need to sign in again to keep using Verstro.";

  static String m28(error) => "Sign out failed: ${error}";

  static String m29(minutes) => "in ${minutes} minute(s)";

  static String m30(error) => "Failed to load orders: ${error}";

  static String m31(amount) => "${amount} left";

  static String m32(email) =>
      "A verification code has been sent to ${email} (check your spam folder too). Enter the 6-digit code to complete verification.";

  static String m33(amount) => "Available ${amount}";

  static String m34(dest) => "Destination ${dest}";

  static String m35(count) => "Invited: ${count}";

  static String m36(price) => "Minimum sale price ${price}";

  static String m37(amount) => "Paid out ${amount}";

  static String m38(min) =>
      "Available balance is too low. Minimum payout is ${min}.";

  static String m39(amount, dest) =>
      "Payout amount: ${amount}\nDestination address (TRC20):\n${dest}\n\nPayouts are processed manually — usually within 24 hours, and no later than 3 business days. On-chain fees are covered by the platform, so you receive exactly the amount requested.\n\nPlease double-check the address: it cannot be changed after submission, and funds sent to a wrong address cannot be recovered.";

  static String m40(min, current) =>
      "Withdrawals available from ${min} (current: ${current})";

  static String m41(amount) => "Maturing ${amount} (14-day maturation period)";

  static String m42(planId) => "Plan ${planId}";

  static String m43(list, floor) => "List price ${list} · your cost ${floor}";

  static String m44(floor, list) => "Must be between ${floor} and ${list}";

  static String m45(floor, list) =>
      "Allowed range ${floor} ~ ${list} (discounts only)";

  static String m46(planId, price) => "Price for ${planId} set to ${price}";

  static String m47(list) => "Not set (charged at list price ${list})";

  static String m48(amount) =>
      "Processing ${amount} (manual payout in progress)";

  static String m49(planId) => "Set price for ${planId}";

  static String m50(code, url) =>
      "Sign up for Verstro with my invite code ${code} — you\'ll get a reward on your first purchase too! Download: ${url}";

  static String m51(count, amount) =>
      "Sub-agents: ${count} · override available ${amount}";

  static String m52(price, earn) =>
      "Your price ${price} · you earn ${earn} per order";

  static String m53(detail) => "Could not connect to the server: ${detail}";

  static String m54(status) => "Server error (${status})";

  static String m55(detail) => "TLS certificate error: ${detail}";

  static String m56(type) => "Unexpected response type: ${type}";

  static String m57(status) => "Unexpected status code ${status}";

  static String m58(error) => "Sign-in failed: ${error}";

  static String m59(error) => "Sign-up failed: ${error}";

  static String m60(seconds) => "Resend (${seconds}s)";

  static String m61(email) =>
      "A verification code has been sent to ${email} (check spam too).\nEnter the 6-digit code and set a new password.";

  static String m62(count) =>
      "${count} membership cards are now in your inventory.";

  static String m63(payment, issuance) =>
      "Payment: ${payment} · Issuance: ${issuance}";

  static String m64(id) => "Card order #${id}";

  static String m65(days, traffic) => "${days} days · ${traffic}";

  static String m66(count) =>
      "Regular-user bulk price: ${count} cards at the server-confirmed 70% tier.";

  static String m67(cost) =>
      "Master cost tier: server cost ratio ${cost}/10000, with no additional bulk discount.";

  static String m68(cost) =>
      "Promoter cost tier: server cost ratio ${cost}/10000, with no additional bulk discount.";

  static String m69(cost) =>
      "Reseller cost tier: server cost ratio ${cost}/10000, with no additional bulk discount.";

  static String m70(count) =>
      "Regular retail gift cards: ${count} cards at list price.";

  static String m71(date) =>
      "This entitlement is scheduled to start on ${date}.";

  static String m72(start, end) => "${start} to ${end}";

  static String m73(amount) =>
      "Confirmed — your subscription is active. The ${amount} overpayment was added to your account balance and applies automatically next time.";

  static String m74(amount) =>
      "This order had expired, but we received your transfer. ${amount} was credited to your account balance. Order again — your balance applies automatically and activates immediately if it covers the total.";

  static String m75(amount) =>
      "${amount} was credited to your account balance. Order again — your balance applies automatically.";

  static String m76(amount, shortfall) =>
      "The amount received was less than due. ${amount} was credited to your account balance and the original order was voided. Order again — your balance applies automatically; you only need to cover the ${shortfall} difference.";

  static String m77(code) => "Authorization ${code}";

  static String m78(basePrice) =>
      "Plan base price \$${basePrice} + unique cents suffix. Even 0.01 more or less cannot be matched automatically. Make sure the \"amount\" field in your wallet matches to 2 decimal places.";

  static String m79(id) =>
      "Order #${id} received no payment within 24 hours and has been voided automatically.";

  static String m80(id) => "Order #${id}";

  static String m81(plan, id) => "${plan} order #${id}";

  static String m82(error) => "Submission failed: ${error}";

  static String m83(email) => "Account: ${email}";

  static String m84(error) => "Failed to create order: ${error}";

  static String m85(days) => "Valid for ${days} days";

  static String m86(error) => "Failed to load plans: ${error}";

  static String m87(count) => "${count} device(s) online at the same time";

  static String m88(price) => "≈ \$${price} / mo";

  static String m89(amount) => "${amount} of data";

  static String m90(trial, invite, url) =>
      "Verstro global network acceleration: one-tap connect on every platform, stable with no drops. ${trial}${invite}${url}";

  static String m91(trial, invite, url) =>
      "Tired of brew / docker / git bypassing your proxy? Verstro uses TUN to take over all traffic at the system level — CLI and desktop apps fully covered, smart switching across multi-region nodes, and the client is GPLv3 open source and auditable. ${trial}${invite}${url}";

  static String m92(trial, invite, url) =>
      "I\'m using Verstro — privacy-first global network acceleration. One-tap acceleration for your whole device, on every platform — phone and desktop — stable with no drops, and the client is open source and auditable. ${trial}${invite}Download: ${url}";

  static String m93(prefix, amount) =>
      "${prefix} — after your first purchase we each get ${amount} in credit. ";

  static String m94(prefix) => "${prefix}. ";

  static String m95(code) => "Enter my invite code ${code} when signing up";

  static String m96(code) => "Sign up with invite code ${code}";

  static String m97(prefix, amount) =>
      "${prefix} — you\'ll get ${amount} in credit after your first purchase. ";

  static String m98(amount) =>
      "Sign up with this code · we each get ${amount} after your first purchase";

  static String m99(amount) =>
      "Sign up with this code · get ${amount} credit on your first purchase";

  static String m100(days) => "free ${days}-day trial";

  static String m101(trial, gb) => "New users: ${trial}${gb}";

  static String m102(days) => "New users get a free ${days}-day trial. ";

  static String m103(days, gb) => "${days} days · ${gb} GB of data";

  static String m104(days) =>
      "Verify your email to claim a ${days}-day free trial (enter the 6-digit code from the email)";

  static String m105(error) => "Download failed: ${error}";

  static String m106(percent) => "Downloading ${percent}%";

  static String m107(version) => "Update to v${version} Required";

  static String m108(error) => "Failed to launch installer: ${error}";

  static String m109(version) => "New Version v${version} Available";

  static String m110(error) => "Update failed: ${error}";

  static String m111(count) =>
      "${Intl.plural(count, one: '1 year ago', other: '${count} years ago')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "accessControl": MessageLookupByLibrary.simpleMessage("AccessControl"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Only allow selected app to enter VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "Configure application access proxy",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "The selected application will be excluded from VPN",
    ),
    "accessControlSettings": MessageLookupByLibrary.simpleMessage(
      "Access Control Settings",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "action": MessageLookupByLibrary.simpleMessage("Action"),
    "action_mode": MessageLookupByLibrary.simpleMessage("Switch mode"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "action_start": MessageLookupByLibrary.simpleMessage("Start/Stop"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("Show/Hide"),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addProfile": MessageLookupByLibrary.simpleMessage("Add Profile"),
    "addRule": MessageLookupByLibrary.simpleMessage("Add rule"),
    "addedOriginRules": MessageLookupByLibrary.simpleMessage(
      "Attach on the original rules",
    ),
    "addedRules": MessageLookupByLibrary.simpleMessage("Added rules"),
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "addressHelp": MessageLookupByLibrary.simpleMessage(
      "WebDAV server address",
    ),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid WebDAV address",
    ),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage(
      "Admin auto launch",
    ),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Boot up by using admin mode",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage(
      "Advanced configuration",
    ),
    "advancedConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Provide diverse configuration options",
    ),
    "ago": MessageLookupByLibrary.simpleMessage(" Ago"),
    "agree": MessageLookupByLibrary.simpleMessage("Agree"),
    "allApps": MessageLookupByLibrary.simpleMessage("All apps"),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Allow applications to bypass VPN",
    ),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "Some apps can bypass VPN when turned on",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("AllowLan"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage(
      "Allow access proxy through the LAN",
    ),
    "app": MessageLookupByLibrary.simpleMessage("App"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "App access control",
    ),
    "appDesc": MessageLookupByLibrary.simpleMessage(
      "Processing app related settings",
    ),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage(
      "Append System DNS",
    ),
    "appendSystemDnsTip": MessageLookupByLibrary.simpleMessage(
      "Forcefully append system DNS to the configuration",
    ),
    "application": MessageLookupByLibrary.simpleMessage("Application"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage(
      "Modify application related settings",
    ),
    "auto": MessageLookupByLibrary.simpleMessage("Auto"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Auto check updates",
    ),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Auto check for updates when the app starts",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Auto close connections",
    ),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Auto close connections after change node",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Auto launch"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Follow the system self startup",
    ),
    "autoRun": MessageLookupByLibrary.simpleMessage("AutoRun"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Auto run when the application is opened",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Auto set system DNS",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("Auto update"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Auto update interval (minutes)",
    ),
    "backup": MessageLookupByLibrary.simpleMessage("Backup"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage(
      "Backup and Restore",
    ),
    "backupAndRestoreDesc": MessageLookupByLibrary.simpleMessage(
      "Sync data via WebDAV or files",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("Backup success"),
    "basicConfig": MessageLookupByLibrary.simpleMessage("Basic configuration"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Modify the basic configuration globally",
    ),
    "bind": MessageLookupByLibrary.simpleMessage("Bind"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("Blacklist mode"),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Bypass domain"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Only takes effect when the system proxy is enabled",
    ),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "The cache is corrupt. Do you want to clear it?",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Cancel filter system app",
    ),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage(
      "Cancel select all",
    ),
    "checkError": MessageLookupByLibrary.simpleMessage("Check error"),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("Check for updates"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "The current application is already the latest version",
    ),
    "checking": MessageLookupByLibrary.simpleMessage("Checking..."),
    "clearData": MessageLookupByLibrary.simpleMessage("Clear Data"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("Export clipboard"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("Clipboard import"),
    "color": MessageLookupByLibrary.simpleMessage("Color"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("Color schemes"),
    "columns": MessageLookupByLibrary.simpleMessage("Columns"),
    "compatible": MessageLookupByLibrary.simpleMessage("Compatibility mode"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "Opening it will lose part of its application ability and gain the support of full amount of Clash.",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to clear all data?",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to force crash the core?",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connecting..."),
    "connection": MessageLookupByLibrary.simpleMessage("Connection"),
    "connections": MessageLookupByLibrary.simpleMessage("Connections"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage(
      "View current connections data",
    ),
    "connectivity": MessageLookupByLibrary.simpleMessage("Connectivity："),
    "contactMe": MessageLookupByLibrary.simpleMessage("Contact me"),
    "content": MessageLookupByLibrary.simpleMessage("Content"),
    "contentScheme": MessageLookupByLibrary.simpleMessage("Content"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "Control global added rules",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copy"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Copying environment variables",
    ),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copy link"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Copy success"),
    "core": MessageLookupByLibrary.simpleMessage("Core"),
    "coreConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "Core configuration change detected",
    ),
    "coreInfo": MessageLookupByLibrary.simpleMessage("Core info"),
    "coreStatus": MessageLookupByLibrary.simpleMessage("Core status"),
    "country": MessageLookupByLibrary.simpleMessage("Country"),
    "crashTest": MessageLookupByLibrary.simpleMessage("Crash test"),
    "crashlytics": MessageLookupByLibrary.simpleMessage("Crash Analysis"),
    "crashlyticsTip": MessageLookupByLibrary.simpleMessage(
      "When enabled, automatically uploads crash logs without sensitive information when the app crashes",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "creationTime": MessageLookupByLibrary.simpleMessage("Creation time"),
    "cut": MessageLookupByLibrary.simpleMessage("Cut"),
    "dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
    "days": MessageLookupByLibrary.simpleMessage("Days"),
    "daysAgo": m0,
    "defaultNameserver": MessageLookupByLibrary.simpleMessage(
      "Default nameserver",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "For resolving DNS server",
    ),
    "defaultSort": MessageLookupByLibrary.simpleMessage("Sort by default"),
    "defaultText": MessageLookupByLibrary.simpleMessage("Default"),
    "delay": MessageLookupByLibrary.simpleMessage("Delay"),
    "delaySort": MessageLookupByLibrary.simpleMessage("Sort by delay"),
    "delayTest": MessageLookupByLibrary.simpleMessage("Delay Test"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteMultipTip": m1,
    "deleteTip": m2,
    "desc": MessageLookupByLibrary.simpleMessage(
      "A multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free.",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Destination"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage(
      "Destination GeoIP",
    ),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage(
      "Destination IPASN",
    ),
    "details": m3,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Relying on third-party api is for reference only",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Developer mode"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Developer mode is enabled.",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("Direct"),
    "disclaimer": MessageLookupByLibrary.simpleMessage("Disclaimer"),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "This software is only used for non-commercial purposes such as learning exchanges and scientific research. It is strictly prohibited to use this software for commercial purposes. Any commercial activity, if any, has nothing to do with this software.",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Disconnected"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "Discover the new version",
    ),
    "discovery": MessageLookupByLibrary.simpleMessage(
      "Discovery a new version",
    ),
    "dnsDesc": MessageLookupByLibrary.simpleMessage(
      "Update DNS related settings",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNS hijacking"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNS mode"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage(
      "Do you want to pass",
    ),
    "domain": MessageLookupByLibrary.simpleMessage("Domain"),
    "download": MessageLookupByLibrary.simpleMessage("Download"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage(
      "Edit global rules",
    ),
    "editRule": MessageLookupByLibrary.simpleMessage("Edit rule"),
    "emptyTip": m4,
    "en": MessageLookupByLibrary.simpleMessage("English"),
    "enableOverride": MessageLookupByLibrary.simpleMessage("Enable override"),
    "entries": MessageLookupByLibrary.simpleMessage(" entries"),
    "exclude": MessageLookupByLibrary.simpleMessage("Hidden from recent tasks"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "When the app is in the background, the app is hidden from the recent task",
    ),
    "existsTip": m5,
    "exit": MessageLookupByLibrary.simpleMessage("Exit"),
    "expand": MessageLookupByLibrary.simpleMessage("Standard"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("Expiration time"),
    "exportFile": MessageLookupByLibrary.simpleMessage("Export file"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Export logs"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("Export Success"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("Expressive"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "ExternalController",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "Once enabled, the Clash kernel can be controlled on port 9090",
    ),
    "externalFetch": MessageLookupByLibrary.simpleMessage("External fetch"),
    "externalLink": MessageLookupByLibrary.simpleMessage("External link"),
    "externalResources": MessageLookupByLibrary.simpleMessage(
      "External resources",
    ),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fakeip filter"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fakeip range"),
    "fallback": MessageLookupByLibrary.simpleMessage("Fallback"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Generally use offshore DNS",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Fallback filter"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("Fidelity"),
    "file": MessageLookupByLibrary.simpleMessage("File"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("Directly upload profile"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "The file has been modified. Do you want to save the changes?",
    ),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Filter system app",
    ),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("Find process"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "There is a certain performance loss after opening",
    ),
    "fontFamily": MessageLookupByLibrary.simpleMessage("FontFamily"),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to force restart the core?",
    ),
    "fourColumns": MessageLookupByLibrary.simpleMessage("Four columns"),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("FruitSalad"),
    "general": MessageLookupByLibrary.simpleMessage("General"),
    "generalDesc": MessageLookupByLibrary.simpleMessage(
      "Modify general settings",
    ),
    "geoData": MessageLookupByLibrary.simpleMessage("GeoData"),
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Geo Low Memory Mode",
    ),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "Enabling will use the Geo low memory loader",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Geoip code"),
    "getOriginRules": MessageLookupByLibrary.simpleMessage(
      "Get original rules",
    ),
    "global": MessageLookupByLibrary.simpleMessage("Global"),
    "go": MessageLookupByLibrary.simpleMessage("Go"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Go to download"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage(
      "Go to configure script",
    ),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Do you want to cache the changes?",
    ),
    "host": MessageLookupByLibrary.simpleMessage("Host"),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("Add Hosts"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage("Hotkey conflict"),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "Hotkey Management",
    ),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "Use keyboard to control applications",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("Hours"),
    "hoursAgo": m6,
    "icon": MessageLookupByLibrary.simpleMessage("Icon"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage(
      "Icon configuration",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Icon style"),
    "import": MessageLookupByLibrary.simpleMessage("Import"),
    "importFile": MessageLookupByLibrary.simpleMessage("Import from file"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("Import from URL"),
    "importUrl": MessageLookupByLibrary.simpleMessage("Import from URL"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("Long term effective"),
    "init": MessageLookupByLibrary.simpleMessage("Init"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage(
      "Please enter the correct hotkey",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "Intelligent selection",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Internet"),
    "interval": MessageLookupByLibrary.simpleMessage("Interval"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("Intranet IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Invalid backup file",
    ),
    "ipcidr": MessageLookupByLibrary.simpleMessage("Ipcidr"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "When turned on it will be able to receive IPv6 traffic",
    ),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage(
      "Allow IPv6 inbound",
    ),
    "ja": MessageLookupByLibrary.simpleMessage("Japanese"),
    "just": MessageLookupByLibrary.simpleMessage("Just"),
    "justNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "Tcp keep alive interval",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Key"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "layout": MessageLookupByLibrary.simpleMessage("Layout"),
    "light": MessageLookupByLibrary.simpleMessage("Light"),
    "list": MessageLookupByLibrary.simpleMessage("List"),
    "listen": MessageLookupByLibrary.simpleMessage("Listen"),
    "loadTest": MessageLookupByLibrary.simpleMessage("Load test"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "local": MessageLookupByLibrary.simpleMessage("Local"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Backup local data to local",
    ),
    "log": MessageLookupByLibrary.simpleMessage("Log"),
    "logLevel": MessageLookupByLibrary.simpleMessage("LogLevel"),
    "logcat": MessageLookupByLibrary.simpleMessage("Logcat"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "Disabling will hide the log entry",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("Logs"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("Log capture records"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Logs test"),
    "loopback": MessageLookupByLibrary.simpleMessage("Loopback unlock tool"),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage(
      "Used for UWP loopback unlocking",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Loose"),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Memory info"),
    "messageTest": MessageLookupByLibrary.simpleMessage("Message test"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage(
      "This is a message.",
    ),
    "min": MessageLookupByLibrary.simpleMessage("Min"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("Minimize on exit"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "Modify the default system exit event",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("Minutes"),
    "minutesAgo": m7,
    "mixedPort": MessageLookupByLibrary.simpleMessage("Mixed Port"),
    "mode": MessageLookupByLibrary.simpleMessage("Mode"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Monochrome"),
    "months": MessageLookupByLibrary.simpleMessage("Months"),
    "monthsAgo": m8,
    "more": MessageLookupByLibrary.simpleMessage("More"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameSort": MessageLookupByLibrary.simpleMessage("Sort by name"),
    "nameserver": MessageLookupByLibrary.simpleMessage("Nameserver"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "For resolving domain",
    ),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage(
      "Nameserver policy",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Specify the corresponding nameserver policy",
    ),
    "network": MessageLookupByLibrary.simpleMessage("Network"),
    "networkDesc": MessageLookupByLibrary.simpleMessage(
      "Modify network-related settings",
    ),
    "networkDetection": MessageLookupByLibrary.simpleMessage(
      "Network detection",
    ),
    "networkException": MessageLookupByLibrary.simpleMessage(
      "Network exception, please check your connection and try again",
    ),
    "networkRequestException": MessageLookupByLibrary.simpleMessage(
      "Network request exception, please try again later.",
    ),
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Network speed"),
    "networkType": MessageLookupByLibrary.simpleMessage("Network type"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("Neutral"),
    "noData": MessageLookupByLibrary.simpleMessage("No data"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("No HotKey"),
    "noIcon": MessageLookupByLibrary.simpleMessage("None"),
    "noInfo": MessageLookupByLibrary.simpleMessage("No info"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage(
      "Don\'t remind again",
    ),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage("No more info"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("No network"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("No network APP"),
    "noProxy": MessageLookupByLibrary.simpleMessage("No proxy"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Please create a profile or add a valid profile",
    ),
    "noResolve": MessageLookupByLibrary.simpleMessage("No resolve IP"),
    "none": MessageLookupByLibrary.simpleMessage("none"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "The current proxy group cannot be selected.",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "No profile, Please add a profile",
    ),
    "nullTip": m9,
    "numberTip": m10,
    "oneColumn": MessageLookupByLibrary.simpleMessage("One column"),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("Icon"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage(
      "Only third-party apps",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Only statistics proxy",
    ),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "When turned on, only statistics proxy traffic",
    ),
    "options": MessageLookupByLibrary.simpleMessage("Options"),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Other contributors",
    ),
    "outboundMode": MessageLookupByLibrary.simpleMessage("Outbound mode"),
    "override": MessageLookupByLibrary.simpleMessage("Override"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage(
      "Override Proxy related config",
    ),
    "overrideDns": MessageLookupByLibrary.simpleMessage("Override Dns"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "Turning it on will override the DNS options in the profile",
    ),
    "overrideInvalidTip": MessageLookupByLibrary.simpleMessage(
      "Does not take effect in script mode",
    ),
    "overrideMode": MessageLookupByLibrary.simpleMessage("Override mode"),
    "overrideOriginRules": MessageLookupByLibrary.simpleMessage(
      "Override the original rule",
    ),
    "overrideScript": MessageLookupByLibrary.simpleMessage("Override script"),
    "overwriteTypeCustom": MessageLookupByLibrary.simpleMessage("Custom"),
    "overwriteTypeCustomDesc": MessageLookupByLibrary.simpleMessage(
      "Custom mode, fully customize proxy groups and rules",
    ),
    "palette": MessageLookupByLibrary.simpleMessage("Palette"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "paste": MessageLookupByLibrary.simpleMessage("Paste"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Please bind WebDAV",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Please enter a script name",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter the admin password",
    ),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage(
      "Please upload file",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Please upload a valid QR code",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Port"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Please enter a different port",
    ),
    "portTip": m11,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage(
      "Prioritize the use of DOH\'s http/3",
    ),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Please press the keyboard.",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "process": MessageLookupByLibrary.simpleMessage("Process"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Please input a valid interval time format",
        ),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Please enter the auto update interval time",
        ),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "The profile has been modified. Do you want to disable auto update?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please input the profile name",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage(
      "profile parse error",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please input a valid profile URL",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please input the profile URL",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Profiles"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Profiles sort"),
    "project": MessageLookupByLibrary.simpleMessage("Project"),
    "providers": MessageLookupByLibrary.simpleMessage("Providers"),
    "proxies": MessageLookupByLibrary.simpleMessage("Proxies"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("Proxies setting"),
    "proxyChains": MessageLookupByLibrary.simpleMessage("Proxy chains"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Proxy group"),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage("Proxy nameserver"),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Domain for resolving proxy nodes",
    ),
    "proxyPort": MessageLookupByLibrary.simpleMessage("ProxyPort"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage(
      "Set the Clash listening port",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("Proxy providers"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("Prune cache"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Pure black mode"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QR code"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Scan QR code to obtain profile",
    ),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("Rainbow"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir Port"),
    "redo": MessageLookupByLibrary.simpleMessage("redo"),
    "regExp": MessageLookupByLibrary.simpleMessage("RegExp"),
    "reload": MessageLookupByLibrary.simpleMessage("Reload"),
    "remote": MessageLookupByLibrary.simpleMessage("Remote"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Backup local data to WebDAV",
    ),
    "remoteDestination": MessageLookupByLibrary.simpleMessage(
      "Remote destination",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "rename": MessageLookupByLibrary.simpleMessage("Rename"),
    "request": MessageLookupByLibrary.simpleMessage("Request"),
    "requests": MessageLookupByLibrary.simpleMessage("Requests"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage(
      "View recently request records",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "The current page has changes. Are you sure you want to reset?",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage("Make sure to reset"),
    "resources": MessageLookupByLibrary.simpleMessage("Resources"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage(
      "External resource related info",
    ),
    "respectRules": MessageLookupByLibrary.simpleMessage("Respect rules"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS connection following rules, need to configure proxy-server-nameserver",
    ),
    "restart": MessageLookupByLibrary.simpleMessage("Restart"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to restart the core?",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Restore"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage("Restore all data"),
    "restoreException": MessageLookupByLibrary.simpleMessage(
      "Recovery exception",
    ),
    "restoreFromFileDesc": MessageLookupByLibrary.simpleMessage(
      "Restore data via file",
    ),
    "restoreFromWebDAVDesc": MessageLookupByLibrary.simpleMessage(
      "Restore data via WebDAV",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage(
      "Restore configuration files only",
    ),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage("Restore strategy"),
    "restoreStrategy_compatible": MessageLookupByLibrary.simpleMessage(
      "Compatible",
    ),
    "restoreStrategy_override": MessageLookupByLibrary.simpleMessage(
      "Override",
    ),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage("Restore success"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Route address"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage(
      "Config listen route address",
    ),
    "routeMode": MessageLookupByLibrary.simpleMessage("Route mode"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "Bypass private route address",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage("Use config"),
    "ru": MessageLookupByLibrary.simpleMessage("Russian"),
    "rule": MessageLookupByLibrary.simpleMessage("Rule"),
    "ruleName": MessageLookupByLibrary.simpleMessage("Rule name"),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("Rule providers"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Rule target"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveChanges": MessageLookupByLibrary.simpleMessage(
      "Do you want to save the changes?",
    ),
    "saveTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to save?",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Script"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "Script mode, use external extension scripts, provide one-click override configuration capability",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "seconds": MessageLookupByLibrary.simpleMessage("Seconds"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Select all"),
    "selected": MessageLookupByLibrary.simpleMessage("Selected"),
    "selectedCountTitle": m12,
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "show": MessageLookupByLibrary.simpleMessage("Show"),
    "shrink": MessageLookupByLibrary.simpleMessage("Shrink"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("SilentLaunch"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Start in the background",
    ),
    "size": MessageLookupByLibrary.simpleMessage("Size"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Socks Port"),
    "sort": MessageLookupByLibrary.simpleMessage("Sort"),
    "source": MessageLookupByLibrary.simpleMessage("Source"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("Source IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("Special proxy"),
    "specialRules": MessageLookupByLibrary.simpleMessage("special rules"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage("Speed statistics"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Stack mode"),
    "standard": MessageLookupByLibrary.simpleMessage("Standard"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Standard mode, override basic configuration, provide simple rule addition capability",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "startVpn": MessageLookupByLibrary.simpleMessage("Starting VPN..."),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "System DNS will be used when turned off",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Stop"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Stopping VPN..."),
    "style": MessageLookupByLibrary.simpleMessage("Style"),
    "subRule": MessageLookupByLibrary.simpleMessage("Sub rule"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "sync": MessageLookupByLibrary.simpleMessage("Sync"),
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "systemApp": MessageLookupByLibrary.simpleMessage("System APP"),
    "systemFont": MessageLookupByLibrary.simpleMessage("System font"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Attach HTTP proxy to VpnService",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Tab"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("Tab animation"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage(
      "Effective only in mobile view",
    ),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP concurrent"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage(
      "Enabling it will allow TCP concurrency",
    ),
    "testUrl": MessageLookupByLibrary.simpleMessage("Test url"),
    "textScale": MessageLookupByLibrary.simpleMessage("Text Scaling"),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Theme color"),
    "themeDesc": MessageLookupByLibrary.simpleMessage(
      "Set dark mode,adjust the color",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Theme mode"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("Three columns"),
    "tight": MessageLookupByLibrary.simpleMessage("Tight"),
    "time": MessageLookupByLibrary.simpleMessage("Time"),
    "tip": MessageLookupByLibrary.simpleMessage("tip"),
    "toggle": MessageLookupByLibrary.simpleMessage("Toggle"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("TonalSpot"),
    "tools": MessageLookupByLibrary.simpleMessage("Tools"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Tproxy Port"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("Traffic usage"),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "only effective in administrator mode",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("Turn Off"),
    "turnOn": MessageLookupByLibrary.simpleMessage("Turn On"),
    "twoColumns": MessageLookupByLibrary.simpleMessage("Two columns"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "unable to update current profile",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("undo"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("Unified delay"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "Remove extra delays such as handshaking",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage(
      "Unknown network error",
    ),
    "unnamed": MessageLookupByLibrary.simpleMessage("Unnamed"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage(
      "Obtain profile through URL",
    ),
    "urlTip": m13,
    "useHosts": MessageLookupByLibrary.simpleMessage("Use hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("Use system hosts"),
    "vAboutCannotOpen": m14,
    "vAboutChecking": MessageLookupByLibrary.simpleMessage("Checking…"),
    "vAboutContactSection": MessageLookupByLibrary.simpleMessage(
      "Contact & Support",
    ),
    "vAboutCreditsBody": MessageLookupByLibrary.simpleMessage(
      "Thanks to FlClash (chen08209), the Mihomo (Clash.Meta) team, the sing-box team, and the wider open-source networking community. Verstro\'s networking capabilities are built on these projects.",
    ),
    "vAboutCreditsSection": MessageLookupByLibrary.simpleMessage(
      "Acknowledgements",
    ),
    "vAboutEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "vAboutOssBody": MessageLookupByLibrary.simpleMessage(
      "The Verstro client is derived from the open-source project FlClash (GPLv3), with Mihomo / sing-box cores (both GPLv3). In accordance with GPLv3, the complete source code of this client is publicly available.",
    ),
    "vAboutOssSection": MessageLookupByLibrary.simpleMessage(
      "Open Source & Licenses",
    ),
    "vAboutPrivacyBody": MessageLookupByLibrary.simpleMessage(
      "• Your email is used only for payment notices and password recovery — no marketing emails\n• We do not collect device IDs, location, or contacts\n• Traffic stats record usage volume only, never content\n• Payments are received on-chain via our own infrastructure, with no third-party custody",
    ),
    "vAboutPrivacySection": MessageLookupByLibrary.simpleMessage(
      "Privacy Commitment",
    ),
    "vAboutSlogan": MessageLookupByLibrary.simpleMessage(
      "Privacy-first global network",
    ),
    "vAboutSourceCode": MessageLookupByLibrary.simpleMessage(
      "Source Code & License",
    ),
    "vAboutTelegramGroup": MessageLookupByLibrary.simpleMessage(
      "Telegram Community",
    ),
    "vAboutTitle": MessageLookupByLibrary.simpleMessage("About Verstro"),
    "vAboutVisitWebsite": MessageLookupByLibrary.simpleMessage("Visit Website"),
    "vAboutWebsiteSection": MessageLookupByLibrary.simpleMessage("Website"),
    "vAcctActiveDaysAgo": m15,
    "vAcctActiveHoursAgo": m16,
    "vAcctActiveJustNow": MessageLookupByLibrary.simpleMessage(
      "Active just now",
    ),
    "vAcctActiveMinutesAgo": m17,
    "vAcctAgentCenter": MessageLookupByLibrary.simpleMessage("Referral Center"),
    "vAcctAgentEntrySubtitle": m18,
    "vAcctAgentTierAgent": MessageLookupByLibrary.simpleMessage(
      "Certified reseller",
    ),
    "vAcctAgentTierMaster": MessageLookupByLibrary.simpleMessage(
      "Strategic distributor",
    ),
    "vAcctAgentWithdrawable": m19,
    "vAcctBalanceSubtitle": MessageLookupByLibrary.simpleMessage(
      "Auto-applied at checkout · submit the TXID to credit an incorrect amount",
    ),
    "vAcctBalanceTitle": m20,
    "vAcctBootFailed": MessageLookupByLibrary.simpleMessage("Startup failed"),
    "vAcctBootFailedWithError": m21,
    "vAcctBuyPlan": MessageLookupByLibrary.simpleMessage("Buy a plan"),
    "vAcctCheckingSubscription": MessageLookupByLibrary.simpleMessage(
      "Checking subscription status...",
    ),
    "vAcctCopySubscriptionUrl": MessageLookupByLibrary.simpleMessage(
      "Copy subscription link",
    ),
    "vAcctDaysLater": m22,
    "vAcctDevicesEntrySubtitle": MessageLookupByLibrary.simpleMessage(
      "Manage signed-in devices",
    ),
    "vAcctDevicesLimitHint": MessageLookupByLibrary.simpleMessage(
      "When the device limit is reached, signing in on a new device automatically signs out the least recently active one",
    ),
    "vAcctDevicesRegistered": m23,
    "vAcctDevicesRegisteredNoMax": m24,
    "vAcctDevicesUnavailable": MessageLookupByLibrary.simpleMessage(
      "Device list temporarily unavailable",
    ),
    "vAcctEmailUnverified": MessageLookupByLibrary.simpleMessage(
      "Email not verified (needed for password recovery)",
    ),
    "vAcctEmailVerified": MessageLookupByLibrary.simpleMessage(
      "Email verified",
    ),
    "vAcctExpired": MessageLookupByLibrary.simpleMessage("Expired"),
    "vAcctExpiresOn": m25,
    "vAcctGrantActive": MessageLookupByLibrary.simpleMessage("Active"),
    "vAcctGrantExhausted": MessageLookupByLibrary.simpleMessage("Used up"),
    "vAcctHoursLater": m26,
    "vAcctLogout": MessageLookupByLibrary.simpleMessage("Sign out"),
    "vAcctLogoutDevice": MessageLookupByLibrary.simpleMessage(
      "Sign out this device",
    ),
    "vAcctLogoutDeviceContent": m27,
    "vAcctLogoutDeviceTitle": MessageLookupByLibrary.simpleMessage(
      "Sign out this device?",
    ),
    "vAcctLogoutFailed": m28,
    "vAcctMinutesLater": m29,
    "vAcctMultiPlanBadge": MessageLookupByLibrary.simpleMessage("Multi-plan"),
    "vAcctMyDevices": MessageLookupByLibrary.simpleMessage("My devices"),
    "vAcctNoDevices": MessageLookupByLibrary.simpleMessage(
      "No registered devices",
    ),
    "vAcctNoOrders": MessageLookupByLibrary.simpleMessage("No orders yet"),
    "vAcctNoSubscription": MessageLookupByLibrary.simpleMessage(
      "No subscription",
    ),
    "vAcctNoSubscriptionDesc": MessageLookupByLibrary.simpleMessage(
      "Purchase a plan to start using Verstro VPN.",
    ),
    "vAcctOrderFailed": MessageLookupByLibrary.simpleMessage("Failed"),
    "vAcctOrderHistory": MessageLookupByLibrary.simpleMessage("Order history"),
    "vAcctOrderHistorySubtitle": MessageLookupByLibrary.simpleMessage(
      "View past orders and payment records",
    ),
    "vAcctOrderPaid": MessageLookupByLibrary.simpleMessage("Paid"),
    "vAcctOrderWaiting": MessageLookupByLibrary.simpleMessage(
      "Awaiting payment",
    ),
    "vAcctOrdersQueryFailed": m30,
    "vAcctPageTitle": MessageLookupByLibrary.simpleMessage("My Account"),
    "vAcctPlanDetails": MessageLookupByLibrary.simpleMessage("Plan details"),
    "vAcctPlanLabel": MessageLookupByLibrary.simpleMessage("Plan"),
    "vAcctPlanPremiumMonthly": MessageLookupByLibrary.simpleMessage(
      "Pro · Monthly",
    ),
    "vAcctPlanPremiumQuarterly": MessageLookupByLibrary.simpleMessage(
      "Pro · Quarterly",
    ),
    "vAcctPlanPremiumYearly": MessageLookupByLibrary.simpleMessage(
      "Pro · Yearly",
    ),
    "vAcctPlanStandardMonthly": MessageLookupByLibrary.simpleMessage(
      "Standard · Monthly",
    ),
    "vAcctPlanStandardQuarterly": MessageLookupByLibrary.simpleMessage(
      "Standard · Quarterly",
    ),
    "vAcctPlanStandardYearly": MessageLookupByLibrary.simpleMessage(
      "Standard · Yearly",
    ),
    "vAcctRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "vAcctRemainingBytes": m31,
    "vAcctRemainingLabel": MessageLookupByLibrary.simpleMessage("Remaining"),
    "vAcctRenewUpgrade": MessageLookupByLibrary.simpleMessage(
      "Renew / upgrade plan",
    ),
    "vAcctRepurchase": MessageLookupByLibrary.simpleMessage("Buy again"),
    "vAcctRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "vAcctSubActive": MessageLookupByLibrary.simpleMessage("Active"),
    "vAcctSubExpired": MessageLookupByLibrary.simpleMessage("Expired"),
    "vAcctSubQueryFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to check subscription status",
    ),
    "vAcctSubQueryFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Subscription check failed",
    ),
    "vAcctSubscriptionUrlCopied": MessageLookupByLibrary.simpleMessage(
      "Subscription link copied",
    ),
    "vAcctSubscriptionUrlDesc": MessageLookupByLibrary.simpleMessage(
      "Can be copied into third-party clients such as Shadowrocket (e.g. on iOS devices).",
    ),
    "vAcctSubscriptionUrlLabel": MessageLookupByLibrary.simpleMessage(
      "Subscription link",
    ),
    "vAcctTapToContinuePayment": MessageLookupByLibrary.simpleMessage(
      "Tap to continue payment",
    ),
    "vAcctTapToReorder": MessageLookupByLibrary.simpleMessage(
      "Tap to order again",
    ),
    "vAcctThisDevice": MessageLookupByLibrary.simpleMessage("This device"),
    "vAcctTotalRemainingLabel": MessageLookupByLibrary.simpleMessage(
      "Total remaining",
    ),
    "vAcctTrafficLimitLabel": MessageLookupByLibrary.simpleMessage(
      "Data limit",
    ),
    "vAcctTrafficNearLimit": MessageLookupByLibrary.simpleMessage(
      "Data almost used up — consider upgrading your plan",
    ),
    "vAcctTrafficUsage": MessageLookupByLibrary.simpleMessage("Data usage"),
    "vAcctTryLater": MessageLookupByLibrary.simpleMessage(
      "Please try again later",
    ),
    "vAcctUnknownDevice": MessageLookupByLibrary.simpleMessage(
      "Unknown device",
    ),
    "vAcctVerifyCodeSentDesc": m32,
    "vAcctVerifyEmailTitle": MessageLookupByLibrary.simpleMessage(
      "Verify email",
    ),
    "vAgentAvailable": m33,
    "vAgentChangePrice": MessageLookupByLibrary.simpleMessage("Edit price"),
    "vAgentCopyInviteCode": MessageLookupByLibrary.simpleMessage(
      "Copy invite code",
    ),
    "vAgentCopyShareText": MessageLookupByLibrary.simpleMessage(
      "Copy share text",
    ),
    "vAgentCopyTxid": MessageLookupByLibrary.simpleMessage("Copy txid"),
    "vAgentDestLine": m34,
    "vAgentInviteCode": MessageLookupByLibrary.simpleMessage("Invite code"),
    "vAgentInviteCodeCopied": MessageLookupByLibrary.simpleMessage(
      "Invite code copied",
    ),
    "vAgentInvitedCount": m35,
    "vAgentLoadFailed": MessageLookupByLibrary.simpleMessage("Failed to load"),
    "vAgentMinimumSaleLine": m36,
    "vAgentNextStep": MessageLookupByLibrary.simpleMessage("Next"),
    "vAgentOpenBrowserFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t open the browser. Please look up this transaction on tronscan.org manually.",
    ),
    "vAgentPaid": m37,
    "vAgentPanelTitle": MessageLookupByLibrary.simpleMessage("Referral Center"),
    "vAgentPayoutAddrInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid TRC20 address",
    ),
    "vAgentPayoutAddrLabel": MessageLookupByLibrary.simpleMessage(
      "TRC20 address (starts with T, 34 chars)",
    ),
    "vAgentPayoutBelowMin": m38,
    "vAgentPayoutButton": MessageLookupByLibrary.simpleMessage(
      "Withdraw to TRC20",
    ),
    "vAgentPayoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Confirm payout",
    ),
    "vAgentPayoutConfirmContent": m39,
    "vAgentPayoutDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Withdraw to a TRC20 address",
    ),
    "vAgentPayoutFailed": MessageLookupByLibrary.simpleMessage(
      "Payout failed. Please try again.",
    ),
    "vAgentPayoutGuardProcessing": MessageLookupByLibrary.simpleMessage(
      "A payout is being processed. You can request another once it completes.",
    ),
    "vAgentPayoutHistory": MessageLookupByLibrary.simpleMessage(
      "Payout history",
    ),
    "vAgentPayoutInProgress": MessageLookupByLibrary.simpleMessage(
      "A payout is already in progress. You can request a new one after it completes.",
    ),
    "vAgentPayoutInvalidDest": MessageLookupByLibrary.simpleMessage(
      "Invalid destination address. Please check the TRC20 address.",
    ),
    "vAgentPayoutRefundedDesc": MessageLookupByLibrary.simpleMessage(
      "The transfer didn\'t go through; the amount has been returned to your available balance.",
    ),
    "vAgentPayoutSubmitted": MessageLookupByLibrary.simpleMessage(
      "Payout request submitted. Awaiting manual transfer (usually within 24 hours).",
    ),
    "vAgentPayoutThinkAgain": MessageLookupByLibrary.simpleMessage("Not now"),
    "vAgentPayoutThreshold": m40,
    "vAgentPending": m41,
    "vAgentPlanPricing": MessageLookupByLibrary.simpleMessage("Plan pricing"),
    "vAgentPlanTitle": m42,
    "vAgentPlatformFloorLine": m43,
    "vAgentPriceLabel": MessageLookupByLibrary.simpleMessage("Price (USD)"),
    "vAgentPriceNotNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter a number",
    ),
    "vAgentPriceOutOfRange": m44,
    "vAgentPriceRangeHint": m45,
    "vAgentPriceSetFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to set the price. Please try again.",
    ),
    "vAgentPriceSetSuccess": m46,
    "vAgentPriceUnset": m47,
    "vAgentProcessing": m48,
    "vAgentRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "vAgentSetPriceTitle": m49,
    "vAgentSharePoster": MessageLookupByLibrary.simpleMessage("Share poster"),
    "vAgentShareText": m50,
    "vAgentShareTextCopied": MessageLookupByLibrary.simpleMessage(
      "Share text copied",
    ),
    "vAgentStatusProcessing": MessageLookupByLibrary.simpleMessage(
      "Processing",
    ),
    "vAgentStatusRefunded": MessageLookupByLibrary.simpleMessage("Returned"),
    "vAgentStatusSent": MessageLookupByLibrary.simpleMessage("Paid"),
    "vAgentSubAgentLine": m51,
    "vAgentTierMaster": MessageLookupByLibrary.simpleMessage(
      "Strategic distributor",
    ),
    "vAgentTierPromoter": MessageLookupByLibrary.simpleMessage("Promoter"),
    "vAgentTierReseller": MessageLookupByLibrary.simpleMessage(
      "Certified reseller",
    ),
    "vAgentTxidCopied": MessageLookupByLibrary.simpleMessage("txid copied"),
    "vAgentViewOnTronScan": MessageLookupByLibrary.simpleMessage(
      "View on TronScan",
    ),
    "vAgentWalletTitle": MessageLookupByLibrary.simpleMessage(
      "Commission wallet",
    ),
    "vAgentYourPriceLine": m52,
    "vApiBadRequest": MessageLookupByLibrary.simpleMessage(
      "Invalid request parameters",
    ),
    "vApiConflict": MessageLookupByLibrary.simpleMessage("Operation conflict"),
    "vApiConnectFailed": m53,
    "vApiEmailTaken": MessageLookupByLibrary.simpleMessage(
      "This email is already registered",
    ),
    "vApiForbidden": MessageLookupByLibrary.simpleMessage("Permission denied"),
    "vApiInvalidCredentials": MessageLookupByLibrary.simpleMessage(
      "Incorrect email or password",
    ),
    "vApiNoActiveBackend": MessageLookupByLibrary.simpleMessage(
      "Could not connect to any backup domain. Check your network.",
    ),
    "vApiNotFound": MessageLookupByLibrary.simpleMessage("Resource not found"),
    "vApiNotLoggedIn": MessageLookupByLibrary.simpleMessage(
      "Not signed in or session expired",
    ),
    "vApiRequestCancelled": MessageLookupByLibrary.simpleMessage(
      "Request cancelled",
    ),
    "vApiRequestTimeout": MessageLookupByLibrary.simpleMessage(
      "Request timed out. Check your network or VPN.",
    ),
    "vApiServerError": MessageLookupByLibrary.simpleMessage(
      "Server error. Please try again later.",
    ),
    "vApiServerErrorStatus": m54,
    "vApiTlsCertError": m55,
    "vApiTokenExpired": MessageLookupByLibrary.simpleMessage(
      "Your session has expired. Please sign in again.",
    ),
    "vApiTokenInvalid": MessageLookupByLibrary.simpleMessage(
      "Invalid sign-in credentials",
    ),
    "vApiUnauthorized": MessageLookupByLibrary.simpleMessage("Unauthorized"),
    "vApiUnexpectedResponseType": m56,
    "vApiUnexpectedStatus": m57,
    "vAppCountryAu": MessageLookupByLibrary.simpleMessage("Australia"),
    "vAppCountryCa": MessageLookupByLibrary.simpleMessage("Canada"),
    "vAppCountryCn": MessageLookupByLibrary.simpleMessage("China"),
    "vAppCountryDe": MessageLookupByLibrary.simpleMessage("Germany"),
    "vAppCountryFr": MessageLookupByLibrary.simpleMessage("France"),
    "vAppCountryGb": MessageLookupByLibrary.simpleMessage("United Kingdom"),
    "vAppCountryHk": MessageLookupByLibrary.simpleMessage("Hong Kong"),
    "vAppCountryId": MessageLookupByLibrary.simpleMessage("Indonesia"),
    "vAppCountryIn": MessageLookupByLibrary.simpleMessage("India"),
    "vAppCountryJp": MessageLookupByLibrary.simpleMessage("Japan"),
    "vAppCountryKr": MessageLookupByLibrary.simpleMessage("South Korea"),
    "vAppCountryMo": MessageLookupByLibrary.simpleMessage("Macao"),
    "vAppCountryMy": MessageLookupByLibrary.simpleMessage("Malaysia"),
    "vAppCountryNl": MessageLookupByLibrary.simpleMessage("Netherlands"),
    "vAppCountryPh": MessageLookupByLibrary.simpleMessage("Philippines"),
    "vAppCountryRu": MessageLookupByLibrary.simpleMessage("Russia"),
    "vAppCountrySg": MessageLookupByLibrary.simpleMessage("Singapore"),
    "vAppCountryTh": MessageLookupByLibrary.simpleMessage("Thailand"),
    "vAppCountryTr": MessageLookupByLibrary.simpleMessage("Türkiye"),
    "vAppCountryTw": MessageLookupByLibrary.simpleMessage("Taiwan"),
    "vAppCountryUs": MessageLookupByLibrary.simpleMessage("United States"),
    "vAppCountryVn": MessageLookupByLibrary.simpleMessage("Vietnam"),
    "vAppLogout": MessageLookupByLibrary.simpleMessage("Log Out"),
    "vAppLogoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to log out of this account?",
    ),
    "vAppModeGlobal": MessageLookupByLibrary.simpleMessage("Global"),
    "vAppModeRule": MessageLookupByLibrary.simpleMessage("Smart"),
    "vAppProfilesSyncingTip": MessageLookupByLibrary.simpleMessage(
      "Syncing subscription… If this stays empty, pull to refresh on the Account page or sign in again.",
    ),
    "vAppShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Invite friends and you both get rewards",
    ),
    "vAppShareTitle": MessageLookupByLibrary.simpleMessage("Share Verstro"),
    "vAuthBackToLogin": MessageLookupByLibrary.simpleMessage("Back to sign in"),
    "vAuthCodeHint": MessageLookupByLibrary.simpleMessage("6 digits"),
    "vAuthCodeLabel": MessageLookupByLibrary.simpleMessage("Verification code"),
    "vAuthCodeRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter the verification code",
    ),
    "vAuthCodeResent": MessageLookupByLibrary.simpleMessage(
      "Verification code resent. Please check your inbox",
    ),
    "vAuthCodeSent": MessageLookupByLibrary.simpleMessage(
      "Verification code sent. Please check your inbox",
    ),
    "vAuthConfirmNewPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Confirm new password",
    ),
    "vAuthConfirmNewPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Please re-enter the new password",
    ),
    "vAuthConfirmPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Confirm password",
    ),
    "vAuthConfirmPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Please re-enter your password",
    ),
    "vAuthEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Invalid email format",
    ),
    "vAuthEmailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "vAuthEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "vAuthEmailVerified": MessageLookupByLibrary.simpleMessage(
      "Email verified ✓",
    ),
    "vAuthForgotIntro": MessageLookupByLibrary.simpleMessage(
      "Enter your registered email and we\'ll send a 6-digit verification code (valid for 10 minutes).",
    ),
    "vAuthForgotPasswordLink": MessageLookupByLibrary.simpleMessage(
      "Forgot password?",
    ),
    "vAuthForgotPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Forgot password",
    ),
    "vAuthGoToLogin": MessageLookupByLibrary.simpleMessage(
      "Already have an account? Sign in",
    ),
    "vAuthGoToRegister": MessageLookupByLibrary.simpleMessage(
      "No account? Sign up now",
    ),
    "vAuthLoginButton": MessageLookupByLibrary.simpleMessage("Sign in"),
    "vAuthLoginFailed": m58,
    "vAuthLoginTitle": MessageLookupByLibrary.simpleMessage(
      "Sign in to Verstro",
    ),
    "vAuthNewPasswordLabelMin8": MessageLookupByLibrary.simpleMessage(
      "New password (min 8 characters)",
    ),
    "vAuthNewPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter a new password",
    ),
    "vAuthPasswordLabelMin6": MessageLookupByLibrary.simpleMessage(
      "Password (min 6 characters)",
    ),
    "vAuthPasswordMin6": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "vAuthPasswordMin8": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 8 characters",
    ),
    "vAuthPasswordMismatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "vAuthPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "vAuthPasswordResetDone": MessageLookupByLibrary.simpleMessage(
      "Password has been reset",
    ),
    "vAuthReferralCodeLabel": MessageLookupByLibrary.simpleMessage(
      "Referral code (optional)",
    ),
    "vAuthRegisterButton": MessageLookupByLibrary.simpleMessage("Sign up"),
    "vAuthRegisterFailed": m59,
    "vAuthRegisterIntro": MessageLookupByLibrary.simpleMessage(
      "Free to sign up. Your email is only used for password recovery and payment notifications; verification is optional.",
    ),
    "vAuthRegisterTitle": MessageLookupByLibrary.simpleMessage(
      "Sign up for Verstro",
    ),
    "vAuthResendCodeButton": MessageLookupByLibrary.simpleMessage(
      "Resend code",
    ),
    "vAuthResendCodeLink": MessageLookupByLibrary.simpleMessage(
      "Didn\'t get it? Resend code",
    ),
    "vAuthResendCooldown": m60,
    "vAuthResetFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "Reset failed. Check your network and try again",
    ),
    "vAuthResetIntro": m61,
    "vAuthResetPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Reset password",
    ),
    "vAuthResetSuccessDesc": MessageLookupByLibrary.simpleMessage(
      "Redirecting to sign-in. Please sign in with your new password.",
    ),
    "vAuthResetSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "Reset successful",
    ),
    "vAuthSendCodeButton": MessageLookupByLibrary.simpleMessage("Send code"),
    "vAuthSendFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "Failed to send. Check your network or try again later",
    ),
    "vAuthSendFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Failed to send. Please try again later",
    ),
    "vAuthVerifyButton": MessageLookupByLibrary.simpleMessage("Verify"),
    "vAuthVerifyFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "Verification failed. Check your network and try again",
    ),
    "vCardActivationCode": MessageLookupByLibrary.simpleMessage(
      "Activation code",
    ),
    "vCardCashBackedApplied": MessageLookupByLibrary.simpleMessage(
      "Cash-backed credit",
    ),
    "vCardCashDue": MessageLookupByLibrary.simpleMessage("Amount due"),
    "vCardClaimSubmit": MessageLookupByLibrary.simpleMessage(
      "Submit for verification",
    ),
    "vCardClaimTitle": MessageLookupByLibrary.simpleMessage(
      "I paid / submit transaction hash",
    ),
    "vCardConfirmRedeem": MessageLookupByLibrary.simpleMessage(
      "Confirm redemption",
    ),
    "vCardCopyAddress": MessageLookupByLibrary.simpleMessage("Copy address"),
    "vCardCopyAmount": MessageLookupByLibrary.simpleMessage("Copy amount"),
    "vCardCreateOrder": MessageLookupByLibrary.simpleMessage(
      "Confirm and create order",
    ),
    "vCardDecrease": MessageLookupByLibrary.simpleMessage("Decrease quantity"),
    "vCardEmailCode": MessageLookupByLibrary.simpleMessage(
      "Email verification code",
    ),
    "vCardEntrySubtitle": MessageLookupByLibrary.simpleMessage(
      "Buy, distribute, reveal, or redeem membership cards",
    ),
    "vCardEntryTitle": MessageLookupByLibrary.simpleMessage(
      "Membership cards and activation codes",
    ),
    "vCardErrExportUnavailable": MessageLookupByLibrary.simpleMessage(
      "Card export is currently unavailable.",
    ),
    "vCardErrOpenOrderLimit": MessageLookupByLibrary.simpleMessage(
      "You have reached the pending card order limit. Complete an existing order first.",
    ),
    "vCardErrPreviewConsumed": MessageLookupByLibrary.simpleMessage(
      "This redemption preview was already used. Do not submit it again.",
    ),
    "vCardErrPreviewExpired": MessageLookupByLibrary.simpleMessage(
      "The redemption preview expired. Enter the activation code again.",
    ),
    "vCardErrQuoteChanged": MessageLookupByLibrary.simpleMessage(
      "The quote changed. Request a fresh quote before confirming.",
    ),
    "vCardErrRedemptionFrozen": MessageLookupByLibrary.simpleMessage(
      "Card redemption is temporarily frozen. Please try again later.",
    ),
    "vCardErrRevealAuth": MessageLookupByLibrary.simpleMessage(
      "Verify your linked email before revealing a full activation code.",
    ),
    "vCardErrRevealExpired": MessageLookupByLibrary.simpleMessage(
      "This reveal authorization expired. Verify again.",
    ),
    "vCardErrScheduleChanged": MessageLookupByLibrary.simpleMessage(
      "The entitlement schedule changed. Preview again before confirming.",
    ),
    "vCardErrUnavailable": MessageLookupByLibrary.simpleMessage(
      "This card cannot currently be viewed or operated on.",
    ),
    "vCardErrWholesaleSelf": MessageLookupByLibrary.simpleMessage(
      "The purchaser cannot redeem wholesale inventory cards. Distribute them to end users.",
    ),
    "vCardGenericError": MessageLookupByLibrary.simpleMessage(
      "The membership card operation failed. Please try again.",
    ),
    "vCardGetQuote": MessageLookupByLibrary.simpleMessage("Get quote"),
    "vCardGoodsTotal": MessageLookupByLibrary.simpleMessage("Card price"),
    "vCardIncrease": MessageLookupByLibrary.simpleMessage("Increase quantity"),
    "vCardInventoryDescription": MessageLookupByLibrary.simpleMessage(
      "Only masked codes are shown by default. Full codes exist briefly in app memory and are cleared when you leave or background the app.",
    ),
    "vCardInventoryEmpty": MessageLookupByLibrary.simpleMessage(
      "No cards in inventory yet. Cards appear here after payment and successful issuance.",
    ),
    "vCardInventoryTab": MessageLookupByLibrary.simpleMessage("Inventory"),
    "vCardIssuedDescription": m62,
    "vCardIssuedTitle": MessageLookupByLibrary.simpleMessage("Cards issued"),
    "vCardIssuing": MessageLookupByLibrary.simpleMessage(
      "Payment confirmed. Issuing cards securely…",
    ),
    "vCardListTotal": MessageLookupByLibrary.simpleMessage("List total"),
    "vCardMarketDescription": MessageLookupByLibrary.simpleMessage(
      "Mix multiple plans in one cart. Regular users pay list price for 1–9 cards and 70% from 10 cards; authorized agents use their existing cost tier with no extra bulk discount. The server quote is authoritative.",
    ),
    "vCardMarketTab": MessageLookupByLibrary.simpleMessage("Buy"),
    "vCardNeedQuantity": MessageLookupByLibrary.simpleMessage(
      "Select at least one membership card.",
    ),
    "vCardOrderExpired": MessageLookupByLibrary.simpleMessage(
      "This order expired. Return and create a new order; late payments follow the existing funding rules.",
    ),
    "vCardOrderPollFailed": MessageLookupByLibrary.simpleMessage(
      "Status check temporarily failed. The app will keep retrying.",
    ),
    "vCardOrderState": m63,
    "vCardOrderTitle": m64,
    "vCardPaymentWarning": MessageLookupByLibrary.simpleMessage(
      "Use USDT-TRC20 and transfer the exact amount shown. Pay exchange fees separately so the received amount is not short.",
    ),
    "vCardPlanMeta": m65,
    "vCardPreviewRedeem": MessageLookupByLibrary.simpleMessage(
      "Preview redemption",
    ),
    "vCardPriceBulkRetail": m66,
    "vCardPriceMaster": m67,
    "vCardPricePromoter": m68,
    "vCardPriceReseller": m69,
    "vCardPriceRetail": m70,
    "vCardQuantity": MessageLookupByLibrary.simpleMessage("Quantity"),
    "vCardQuoting": MessageLookupByLibrary.simpleMessage("Getting quote…"),
    "vCardRedeemDescription": MessageLookupByLibrary.simpleMessage(
      "Preview the plan and activation time before confirming. Confirmation never uploads the full code again.",
    ),
    "vCardRedeemImmediate": MessageLookupByLibrary.simpleMessage(
      "This entitlement starts immediately after confirmation.",
    ),
    "vCardRedeemScheduled": m71,
    "vCardRedeemSuccess": MessageLookupByLibrary.simpleMessage(
      "Redemption accepted. The entitlement timeline was updated.",
    ),
    "vCardRedeemTab": MessageLookupByLibrary.simpleMessage("Redeem"),
    "vCardRevealAction": MessageLookupByLibrary.simpleMessage(
      "Reveal full code",
    ),
    "vCardRevealContinue": MessageLookupByLibrary.simpleMessage(
      "Understand and continue",
    ),
    "vCardRevealIrreversible": MessageLookupByLibrary.simpleMessage(
      "Once a full activation code is revealed, it is considered delivered and is no longer refundable. Continue only when ready to store or distribute it securely.",
    ),
    "vCardRevealTitle": MessageLookupByLibrary.simpleMessage(
      "Reveal full activation code",
    ),
    "vCardRevealVerifyHint": MessageLookupByLibrary.simpleMessage(
      "A 6-digit code was sent to your verified email",
    ),
    "vCardRevealVerifyTitle": MessageLookupByLibrary.simpleMessage(
      "Verify email to reveal",
    ),
    "vCardServerQuote": MessageLookupByLibrary.simpleMessage("Server quote"),
    "vCardShareExplicit": MessageLookupByLibrary.simpleMessage(
      "Share explicitly",
    ),
    "vCardShareExplicitDone": MessageLookupByLibrary.simpleMessage(
      "Full activation code copied. Distribute it only through a trusted channel.",
    ),
    "vCardStatusActivationPending": MessageLookupByLibrary.simpleMessage(
      "Activation pending",
    ),
    "vCardStatusActive": MessageLookupByLibrary.simpleMessage("Active"),
    "vCardStatusAvailable": MessageLookupByLibrary.simpleMessage("Available"),
    "vCardStatusExpired": MessageLookupByLibrary.simpleMessage("Expired"),
    "vCardStatusFailed": MessageLookupByLibrary.simpleMessage("Failed"),
    "vCardStatusNotStarted": MessageLookupByLibrary.simpleMessage(
      "Awaiting issuance",
    ),
    "vCardStatusPaid": MessageLookupByLibrary.simpleMessage("Paid"),
    "vCardStatusPaused": MessageLookupByLibrary.simpleMessage("Paused"),
    "vCardStatusProcessing": MessageLookupByLibrary.simpleMessage("Processing"),
    "vCardStatusRedeemed": MessageLookupByLibrary.simpleMessage("Redeemed"),
    "vCardStatusRevoked": MessageLookupByLibrary.simpleMessage("Revoked"),
    "vCardStatusScheduled": MessageLookupByLibrary.simpleMessage("Scheduled"),
    "vCardStatusSucceeded": MessageLookupByLibrary.simpleMessage("Issued"),
    "vCardStatusWaiting": MessageLookupByLibrary.simpleMessage(
      "Awaiting payment",
    ),
    "vCardTimelineCurrent": MessageLookupByLibrary.simpleMessage(
      "Current entitlements",
    ),
    "vCardTimelineEmpty": MessageLookupByLibrary.simpleMessage(
      "No matching entitlements.",
    ),
    "vCardTimelinePending": MessageLookupByLibrary.simpleMessage(
      "Upcoming schedule",
    ),
    "vCardTimelinePeriod": m72,
    "vCardTimelineTab": MessageLookupByLibrary.simpleMessage("Timeline"),
    "vCardTitle": MessageLookupByLibrary.simpleMessage(
      "Membership card center",
    ),
    "vCardTxHash": MessageLookupByLibrary.simpleMessage("Transaction hash"),
    "vCardUnavailableBulk": MessageLookupByLibrary.simpleMessage(
      "Bulk card purchases are currently disabled. Reduce the quantity and request a new quote.",
    ),
    "vCardUnavailableSales": MessageLookupByLibrary.simpleMessage(
      "Membership cards or sales are not currently available. Please try again later.",
    ),
    "vCardUseCashBacked": MessageLookupByLibrary.simpleMessage(
      "Use refundable cash-backed credit",
    ),
    "vCardVerify": MessageLookupByLibrary.simpleMessage("Verify"),
    "vCardViewInventory": MessageLookupByLibrary.simpleMessage(
      "View card inventory",
    ),
    "vCardWarningWholesaleSelf": MessageLookupByLibrary.simpleMessage(
      "This is wholesale inventory. The purchaser cannot redeem these cards. Eligible redeemers are attributed to the purchaser while commissions remain governed by existing agent rules.",
    ),
    "vCardWholesaleConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Confirm wholesale inventory rules",
    ),
    "vClaimActivated": MessageLookupByLibrary.simpleMessage(
      "Confirmed — your subscription is now active.",
    ),
    "vClaimActivatedOverpay": m73,
    "vClaimAlreadyProcessed": MessageLookupByLibrary.simpleMessage(
      "This transaction was already processed and can\'t be reused. Questions? Contact support @VerstroSupportBot.",
    ),
    "vClaimCreditedExpired": m74,
    "vClaimCreditedNoShortfall": m75,
    "vClaimCreditedUnderpay": m76,
    "vClaimMatchedOtherOrder": MessageLookupByLibrary.simpleMessage(
      "This transaction matched a different order. If you don\'t have another order, contact support @VerstroSupportBot.",
    ),
    "vClaimRejectedManual": MessageLookupByLibrary.simpleMessage(
      "We\'ve logged this transaction, but it needs manual review (large amount or special case). DM Telegram support @VerstroSupportBot with your order number, registration email, and transaction ID (TXID).",
    ),
    "vClaimVerifyFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t verify this transaction (it may be unconfirmed, the address may be wrong, or the network hiccuped). Try again shortly, or contact support @VerstroSupportBot.",
    ),
    "vErrCodeExpired": MessageLookupByLibrary.simpleMessage(
      "Verification code expired — request a new one",
    ),
    "vErrCodeLocked": MessageLookupByLibrary.simpleMessage(
      "Too many attempts — request a new code",
    ),
    "vErrCouponDisabled": MessageLookupByLibrary.simpleMessage(
      "This coupon has been disabled",
    ),
    "vErrCouponInactive": MessageLookupByLibrary.simpleMessage(
      "This coupon isn\'t active yet or has expired",
    ),
    "vErrCouponInvalid": MessageLookupByLibrary.simpleMessage(
      "Invalid coupon code",
    ),
    "vErrCouponLimitReached": MessageLookupByLibrary.simpleMessage(
      "You\'ve reached the usage limit for this coupon",
    ),
    "vErrCouponNewUsersOnly": MessageLookupByLibrary.simpleMessage(
      "New users only",
    ),
    "vErrCouponPartnerPriceConflict": MessageLookupByLibrary.simpleMessage(
      "Partner prices can\'t be combined with platform coupons",
    ),
    "vErrCouponPlanMismatch": MessageLookupByLibrary.simpleMessage(
      "This coupon doesn\'t apply to this plan",
    ),
    "vErrCouponSoldOut": MessageLookupByLibrary.simpleMessage(
      "This coupon is fully claimed",
    ),
    "vErrDuplicateCode": MessageLookupByLibrary.simpleMessage(
      "This coupon code already exists",
    ),
    "vErrEmailUnverified": MessageLookupByLibrary.simpleMessage(
      "Verify your email before claiming the trial",
    ),
    "vErrHasSubscription": MessageLookupByLibrary.simpleMessage(
      "You already have a subscription — no trial needed",
    ),
    "vErrInvalidCode": MessageLookupByLibrary.simpleMessage(
      "Incorrect or expired verification code",
    ),
    "vErrInvalidDest": MessageLookupByLibrary.simpleMessage(
      "Enter a valid TRC20 address",
    ),
    "vErrInvalidPlan": MessageLookupByLibrary.simpleMessage(
      "This plan doesn\'t exist",
    ),
    "vErrInvalidReferralCode": MessageLookupByLibrary.simpleMessage(
      "Invalid referral code. Check it and try again.",
    ),
    "vErrInvalidTxHash": MessageLookupByLibrary.simpleMessage(
      "Transaction ID looks invalid",
    ),
    "vErrMissingCode": MessageLookupByLibrary.simpleMessage(
      "Enter the verification code",
    ),
    "vErrNoSubscription": MessageLookupByLibrary.simpleMessage(
      "No subscription",
    ),
    "vErrProvisionFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t start the trial — try again",
    ),
    "vErrSubExpired": MessageLookupByLibrary.simpleMessage(
      "Your subscription has expired",
    ),
    "vErrSubProxyDisabled": MessageLookupByLibrary.simpleMessage(
      "Subscription proxy is off — no link to reset",
    ),
    "vErrTokenUsed": MessageLookupByLibrary.simpleMessage(
      "This link has already been used",
    ),
    "vErrTrialClaimed": MessageLookupByLibrary.simpleMessage(
      "You\'ve already claimed the trial",
    ),
    "vErrTrialDisabled": MessageLookupByLibrary.simpleMessage(
      "The trial isn\'t available right now",
    ),
    "vHelpAccountBody": MessageLookupByLibrary.simpleMessage(
      "Use the account page to review subscription status, expiry, and signed-in devices. Sign in only on your own devices. For a subscription or device issue, first confirm the account and network state.",
    ),
    "vHelpAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Account, subscription, and devices",
    ),
    "vHelpContactBody": MessageLookupByLibrary.simpleMessage(
      "When contacting support, include the platform, app version, network environment, node, and steps to reproduce. Do not send passwords, full payment credentials, or other sensitive information.",
    ),
    "vHelpContactTitle": MessageLookupByLibrary.simpleMessage(
      "Contact support",
    ),
    "vHelpCoverageTitle": MessageLookupByLibrary.simpleMessage(
      "Traffic coverage",
    ),
    "vHelpDesktopCombinations": MessageLookupByLibrary.simpleMessage(
      "System proxy on / Virtual NIC on: browsers and similar apps use the system proxy, while the Virtual NIC adds coverage for other traffic. This is the most complete coverage and is recommended for everyday use.\n\nSystem proxy on / Virtual NIC off: only apps that honor the system proxy are covered. Use this without administrator permission or when only a browser needs it.\n\nSystem proxy off / Virtual NIC on: the Virtual NIC primarily covers device traffic. This suits advanced users or troubleshooting a system-proxy conflict.\n\nSystem proxy off / Virtual NIC off: Verstro does not actively take over most system traffic. This is normally not recommended and is for troubleshooting only.",
    ),
    "vHelpDesktopRecommended": MessageLookupByLibrary.simpleMessage(
      "Recommended everyday setup: Smart routing + System proxy on + Virtual NIC on.",
    ),
    "vHelpFaqConnectedNoEffectA": MessageLookupByLibrary.simpleMessage(
      "First check the System proxy and Virtual NIC switches, the current outbound mode, node, and other VPNs, then disconnect and reconnect. If it persists, confirm whether the app honors the system proxy; on desktop, enable Virtual NIC or temporarily use Global proxy to diagnose it, then restore Smart routing.",
    ),
    "vHelpFaqConnectedNoEffectQ": MessageLookupByLibrary.simpleMessage(
      "It says connected, but my IP or some apps have not changed. What should I do?",
    ),
    "vHelpFaqDisableTunA": MessageLookupByLibrary.simpleMessage(
      "Temporarily disable Virtual NIC and keep System proxy enabled if it conflicts with another VPN, proxy, or security software, if sleep or wake recovery is abnormal, or if you only need browser proxying. Re-enable Virtual NIC after diagnosing the issue to restore broader coverage.",
    ),
    "vHelpFaqDisableTunQ": MessageLookupByLibrary.simpleMessage(
      "When should I temporarily disable Virtual NIC?",
    ),
    "vHelpFaqGlobalCoverageA": MessageLookupByLibrary.simpleMessage(
      "No. Global proxy affects only traffic that has already entered Verstro. System proxy and Virtual NIC decide which app or system traffic enters it. For broader desktop coverage, turn on both; on mobile, the system VPN tunnel provides coverage.",
    ),
    "vHelpFaqGlobalCoverageQ": MessageLookupByLibrary.simpleMessage(
      "Does Global proxy mean the entire device uses a proxy?",
    ),
    "vHelpFaqMobileTogglesA": MessageLookupByLibrary.simpleMessage(
      "Android and iOS use the system VPN tunnel to cover traffic instead of those desktop switches. Grant VPN permission when prompted, then choose an outbound mode and node.",
    ),
    "vHelpFaqMobileTogglesQ": MessageLookupByLibrary.simpleMessage(
      "Why are System proxy and Virtual NIC not shown on mobile?",
    ),
    "vHelpFaqModeDifferenceA": MessageLookupByLibrary.simpleMessage(
      "Smart routing uses rules to choose direct access or a node. Global proxy sends internet traffic that has already entered Verstro through the current node. Global proxy does not expand traffic coverage by itself, so Smart routing is preferred for everyday use.",
    ),
    "vHelpFaqModeDifferenceQ": MessageLookupByLibrary.simpleMessage(
      "What is the difference between Smart routing and Global proxy?",
    ),
    "vHelpFaqProxyAndTunA": MessageLookupByLibrary.simpleMessage(
      "For everyday use, enable both: System proxy covers apps that honor it, and Virtual NIC adds other apps. If Virtual NIC conflicts with another VPN, proxy, or security software, temporarily disable Virtual NIC and keep System proxy enabled. You may also use only System proxy without administrator permission or when you only need browser proxying.",
    ),
    "vHelpFaqProxyAndTunQ": MessageLookupByLibrary.simpleMessage(
      "Do System proxy and Virtual NIC both need to be enabled?",
    ),
    "vHelpFaqRestoreRecommendedA": MessageLookupByLibrary.simpleMessage(
      "On desktop, select Smart routing, enable System proxy and Virtual NIC, then disconnect and reconnect. On mobile, select Smart routing and an appropriate node, and confirm that system VPN permission is still granted.",
    ),
    "vHelpFaqRestoreRecommendedQ": MessageLookupByLibrary.simpleMessage(
      "How do I restore the recommended configuration?",
    ),
    "vHelpFaqTitle": MessageLookupByLibrary.simpleMessage(
      "FAQ and troubleshooting",
    ),
    "vHelpFaqTunPermissionA": MessageLookupByLibrary.simpleMessage(
      "Virtual NIC creates or changes a system network interface, so its first use may request administrator approval. Approve only a system prompt you recognize as Verstro. Verstro never asks for or receives your account or administrator password. Without permission, use System proxy first.",
    ),
    "vHelpFaqTunPermissionQ": MessageLookupByLibrary.simpleMessage(
      "Why does Virtual NIC need administrator permission?",
    ),
    "vHelpGlobalBody": MessageLookupByLibrary.simpleMessage(
      "Routes internet traffic that has already entered Verstro through the current node, while preserving system addresses, LAN traffic, and required bypasses. It does not automatically take over the whole device and is not necessarily faster. Use it for an inaccessible service, a consistent egress IP, development tests, or temporary troubleshooting, then return to Smart routing.",
    ),
    "vHelpGlobalTitle": MessageLookupByLibrary.simpleMessage("Global proxy"),
    "vHelpIntro": MessageLookupByLibrary.simpleMessage(
      "Outbound mode decides how traffic that has entered Verstro leaves your device; System proxy and Virtual NIC decide which traffic enters Verstro. This help is available offline.",
    ),
    "vHelpMobileVpnBody": MessageLookupByLibrary.simpleMessage(
      "Android and iOS use the system VPN tunnel for traffic coverage. Approve the system prompt on the first connection. On mobile, choose an outbound mode and node; the desktop System proxy and Virtual NIC switches are not shown.",
    ),
    "vHelpMobileVpnTitle": MessageLookupByLibrary.simpleMessage(
      "System VPN tunnel",
    ),
    "vHelpNodesBody": MessageLookupByLibrary.simpleMessage(
      "Prefer automatic selection to balance latency and availability. If a service behaves unexpectedly, manually choose another node and reconnect. Node availability changes with the network environment.",
    ),
    "vHelpNodesTitle": MessageLookupByLibrary.simpleMessage("Nodes and routes"),
    "vHelpOpenLinkFailed": MessageLookupByLibrary.simpleMessage(
      "Could not open the link. Please try again later.",
    ),
    "vHelpOutboundIntro": MessageLookupByLibrary.simpleMessage(
      "Outbound modes decide only how traffic already inside Verstro leaves the device; they do not decide which apps or system traffic enter Verstro.",
    ),
    "vHelpOutboundTitle": MessageLookupByLibrary.simpleMessage(
      "Outbound modes",
    ),
    "vHelpPaymentBody": MessageLookupByLibrary.simpleMessage(
      "Check the plan, amount, and network before ordering. Pay only with the network and exact amount shown on the page, then wait for on-chain confirmation. For an unusual order, contact support with the order details.",
    ),
    "vHelpPaymentTitle": MessageLookupByLibrary.simpleMessage(
      "Purchase and payment",
    ),
    "vHelpQuickBody": MessageLookupByLibrary.simpleMessage(
      "After signing in and confirming that your subscription is active, choose a node, keep Smart routing selected, and tap Connect. Tap Disconnect to stop. Authorize the system prompt when using Virtual NIC or the system VPN for the first time.",
    ),
    "vHelpQuickTitle": MessageLookupByLibrary.simpleMessage("Quick start"),
    "vHelpReplaySubtitle": MessageLookupByLibrary.simpleMessage(
      "Review connection, mode, and platform guidance without changing your current network settings.",
    ),
    "vHelpReplayTitle": MessageLookupByLibrary.simpleMessage(
      "Replay onboarding",
    ),
    "vHelpSmartBody": MessageLookupByLibrary.simpleMessage(
      "Rules keep local networks, LAN resources, and services suitable for direct access direct, while traffic that needs a proxy uses a node. This usually reduces latency and data use and helps reach printers and NAS devices, so it is recommended for everyday use.",
    ),
    "vHelpSmartTitle": MessageLookupByLibrary.simpleMessage("Smart routing"),
    "vHelpSystemProxyBody": MessageLookupByLibrary.simpleMessage(
      "When enabled, Verstro writes the operating-system proxy settings, so browsers and other apps that honor the system proxy enter Verstro. When disabled, they no longer enter by that route. It needs no virtual adapter and fewer permissions, but terminals, Git, Docker, games, and some desktop apps may ignore it.",
    ),
    "vHelpSystemProxyTitle": MessageLookupByLibrary.simpleMessage(
      "System proxy",
    ),
    "vHelpTitle": MessageLookupByLibrary.simpleMessage("Help Center"),
    "vHelpTunBody": MessageLookupByLibrary.simpleMessage(
      "When enabled, it creates a virtual network interface and takes traffic at the system network layer, including apps that do not read the system proxy. When disabled, it no longer provides system-level coverage; only the system proxy or manually configured app paths remain. It suits terminals, Git, brew, Docker, Electron, and similar apps. The first use may need administrator approval and can conflict with other VPNs, proxies, or security software. A Virtual NIC can work with Smart routing; it is not Global proxy.",
    ),
    "vHelpTunTitle": MessageLookupByLibrary.simpleMessage("Virtual NIC (TUN)"),
    "vHelpUpdateBody": MessageLookupByLibrary.simpleMessage(
      "Download updates from official sources. If installation or an upgrade fails, check storage, system permissions, and the package source. Do not use modified packages from unknown sources.",
    ),
    "vHelpUpdateTitle": MessageLookupByLibrary.simpleMessage(
      "Updates and installation help",
    ),
    "vHelpWebSubtitle": MessageLookupByLibrary.simpleMessage(
      "Open the website help center in your system browser.",
    ),
    "vHelpWebTitle": MessageLookupByLibrary.simpleMessage("Open full web help"),
    "vOnboardingBack": MessageLookupByLibrary.simpleMessage("Back"),
    "vOnboardingConnectDesktopBody": MessageLookupByLibrary.simpleMessage(
      "Tap the Connect button on the main screen to connect or disconnect. The first use may request system permission.",
    ),
    "vOnboardingConnectMobileBody": MessageLookupByLibrary.simpleMessage(
      "Tap the Connect button on the main screen to connect or disconnect. The first connection may request system VPN permission.",
    ),
    "vOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage("Connect"),
    "vOnboardingFinish": MessageLookupByLibrary.simpleMessage("Finish"),
    "vOnboardingHelpBody": MessageLookupByLibrary.simpleMessage(
      "Replay this later from the dashboard question-mark button or Settings → Help Center.",
    ),
    "vOnboardingHelpTitle": MessageLookupByLibrary.simpleMessage("Help"),
    "vOnboardingNext": MessageLookupByLibrary.simpleMessage("Next"),
    "vOnboardingOpenHelp": MessageLookupByLibrary.simpleMessage(
      "Open Help Center",
    ),
    "vOnboardingOutboundBody": MessageLookupByLibrary.simpleMessage(
      "Smart routing is recommended for everyday use. Use Global proxy temporarily only for a consistent egress or troubleshooting.",
    ),
    "vOnboardingSkip": MessageLookupByLibrary.simpleMessage("Skip"),
    "vPartnerAuthorizationCode": m77,
    "vPartnerCertifiedAffiliate": MessageLookupByLibrary.simpleMessage(
      "Certified affiliate",
    ),
    "vPartnerCertifiedReseller": MessageLookupByLibrary.simpleMessage(
      "Certified reseller",
    ),
    "vPartnerNonExclusive": MessageLookupByLibrary.simpleMessage(
      "Standard partnerships are non-exclusive",
    ),
    "vPartnerStrategicDistributor": MessageLookupByLibrary.simpleMessage(
      "Strategic distributor",
    ),
    "vPartnerVerified": MessageLookupByLibrary.simpleMessage(
      "Verified by Verstro",
    ),
    "vPayAddressCopied": MessageLookupByLibrary.simpleMessage(
      "Deposit address copied",
    ),
    "vPayAmountCopied": MessageLookupByLibrary.simpleMessage(
      "Amount copied (keep all decimal places)",
    ),
    "vPayAmountMismatchNote": MessageLookupByLibrary.simpleMessage(
      "Even 0.01 more or less cannot be matched automatically. Make sure the \"amount\" field in your wallet matches to 2 decimal places.",
    ),
    "vPayAmountMismatchNoteWithBase": m78,
    "vPayAntiCollisionSuffixLabel": MessageLookupByLibrary.simpleMessage(
      "Matching cents",
    ),
    "vPayBackToHome": MessageLookupByLibrary.simpleMessage("Back to home"),
    "vPayBackToReorder": MessageLookupByLibrary.simpleMessage(
      "Back to reorder",
    ),
    "vPayBasePriceLabel": MessageLookupByLibrary.simpleMessage(
      "Original price",
    ),
    "vPayClaimInstruction": MessageLookupByLibrary.simpleMessage(
      "Copy the tx hash of your transfer from your wallet (imToken / TronLink, etc.) and paste it below:",
    ),
    "vPayClaimNote": MessageLookupByLibrary.simpleMessage(
      "After you submit, the backend verifies the transaction on-chain immediately. If you overpaid, your subscription is activated and the excess is credited to your account balance; if you underpaid, the full received amount is credited to your balance and applied automatically when you place a new order.",
    ),
    "vPayContactSupport": MessageLookupByLibrary.simpleMessage(
      "Contact support bot (amount mismatch / wrong address)",
    ),
    "vPayCopyAddress": MessageLookupByLibrary.simpleMessage("Copy address"),
    "vPayCopyAmount": MessageLookupByLibrary.simpleMessage("Copy amount"),
    "vPayCountdownExpired": MessageLookupByLibrary.simpleMessage("Expired"),
    "vPayCouponDiscountLabel": MessageLookupByLibrary.simpleMessage("Coupon"),
    "vPayCreditAppliedLabel": MessageLookupByLibrary.simpleMessage(
      "Balance applied",
    ),
    "vPayExactAmountWarning": MessageLookupByLibrary.simpleMessage(
      "Transfer exactly this amount",
    ),
    "vPayExpiredClaimHint": MessageLookupByLibrary.simpleMessage(
      "Transferred but not credited? Submit your transaction hash and the received amount will be added to your account balance automatically.",
    ),
    "vPayFeeWarningBody": MessageLookupByLibrary.simpleMessage(
      "Exchanges deduct a network fee from the withdrawal amount (typically ~1 USDT on TRC20), so the amount received will be less than what you entered and the payment cannot be matched automatically. We recommend transferring directly from your own wallet (imToken / TronLink). If you must use an exchange, set withdrawal amount = amount due + fee, so the received amount exactly equals the amount due. For an incorrect amount, submit the TXID: an overpayment activates the subscription and credits the excess; an underpayment is credited in full and applied automatically when you reorder.",
    ),
    "vPayFeeWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Paying by exchange withdrawal? Mind the fee",
    ),
    "vPayIHavePaid": MessageLookupByLibrary.simpleMessage("I\'ve paid"),
    "vPayIHavePaidSubmitTx": MessageLookupByLibrary.simpleMessage(
      "I\'ve paid (submit tx hash)",
    ),
    "vPayIHavePaidWithHash": MessageLookupByLibrary.simpleMessage(
      "I\'ve paid (enter tx hash to verify now)",
    ),
    "vPayOrderExpiredDesc": m79,
    "vPayOrderExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "Order expired",
    ),
    "vPayOrderFooterNote": MessageLookupByLibrary.simpleMessage(
      "Unpaid orders are voided automatically after 24h. Once you pay within 24h, the backend matches the payment within 30s; tap \"I\'ve paid\" to trigger matching immediately.",
    ),
    "vPayOrderNumber": m80,
    "vPayOrderTitle": m81,
    "vPayPaymentConfirmed": MessageLookupByLibrary.simpleMessage(
      "Payment confirmed",
    ),
    "vPayPlanMonthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "vPayPlanQuarterly": MessageLookupByLibrary.simpleMessage("Quarterly"),
    "vPayPlanYearly": MessageLookupByLibrary.simpleMessage("Yearly"),
    "vPayReorderWithCredit": MessageLookupByLibrary.simpleMessage(
      "Place a new order (balance applied automatically)",
    ),
    "vPayStatusChecking": MessageLookupByLibrary.simpleMessage(
      "Checking order status...",
    ),
    "vPayStatusQueryFailed": MessageLookupByLibrary.simpleMessage(
      "Query failed, retrying...",
    ),
    "vPayStatusWaiting": MessageLookupByLibrary.simpleMessage(
      "⏳ Awaiting payment... (auto-refresh every 5s)",
    ),
    "vPaySubmitFailed": m82,
    "vPaySubmitVerify": MessageLookupByLibrary.simpleMessage(
      "Submit for verification",
    ),
    "vPaySubscriptionActivated": MessageLookupByLibrary.simpleMessage(
      "Subscription activated",
    ),
    "vPayTelegramNotInstalled": MessageLookupByLibrary.simpleMessage(
      "Telegram is not installed. Support: @VerstroSupportBot",
    ),
    "vPayTronAddressTitle": MessageLookupByLibrary.simpleMessage(
      "Tron USDT address",
    ),
    "vPayTxHashHint": MessageLookupByLibrary.simpleMessage(
      "64-char hex, e.g. abc1234...",
    ),
    "vPayTxHashLengthError": MessageLookupByLibrary.simpleMessage(
      "Invalid tx hash length (should be 64 characters)",
    ),
    "vPlanAccountEmail": m83,
    "vPlanBadgeBestValue": MessageLookupByLibrary.simpleMessage("Best value"),
    "vPlanBadgeRecommended": MessageLookupByLibrary.simpleMessage(
      "Recommended",
    ),
    "vPlanCouponLabel": MessageLookupByLibrary.simpleMessage(
      "Coupon code (optional)",
    ),
    "vPlanCreateOrderFailed": m84,
    "vPlanDurationDays": m85,
    "vPlanFeatureAutoNode": MessageLookupByLibrary.simpleMessage(
      "Auto-selects the fastest node",
    ),
    "vPlanFeaturePremiumNodes": MessageLookupByLibrary.simpleMessage(
      "Manually pick country / node · accelerated nodes included",
    ),
    "vPlanLoadFailed": m86,
    "vPlanLogout": MessageLookupByLibrary.simpleMessage("Sign out"),
    "vPlanMaxDevices": m87,
    "vPlanMultiDevices": MessageLookupByLibrary.simpleMessage(
      "Use on multiple devices at once",
    ),
    "vPlanNameTrial": MessageLookupByLibrary.simpleMessage("Trial"),
    "vPlanPartnerPriceLabel": MessageLookupByLibrary.simpleMessage(
      "Partner price",
    ),
    "vPlanPartnerSalesPaused": MessageLookupByLibrary.simpleMessage(
      "New purchases of this plan are temporarily unavailable through this partner. Existing orders and benefits are unaffected.",
    ),
    "vPlanPaymentMethodNote": MessageLookupByLibrary.simpleMessage(
      "Payment method: USDT-TRC20\nPayments go directly to Verstro\'s own on-chain address — no third-party custody",
    ),
    "vPlanPerMonthHint": m88,
    "vPlanPickThis": MessageLookupByLibrary.simpleMessage("Choose this plan"),
    "vPlanPickTitle": MessageLookupByLibrary.simpleMessage("Choose a plan"),
    "vPlanPriceChanged": MessageLookupByLibrary.simpleMessage(
      "The plan price changed. Review the new price and confirm again.",
    ),
    "vPlanRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "vPlanTelegramSupport": MessageLookupByLibrary.simpleMessage(
      "Telegram community support",
    ),
    "vPlanTierPremium": MessageLookupByLibrary.simpleMessage("Pro plans"),
    "vPlanTierPremiumDesc": MessageLookupByLibrary.simpleMessage(
      "Manually pick country / node · low-latency accelerated nodes · more devices",
    ),
    "vPlanTierStandard": MessageLookupByLibrary.simpleMessage("Standard plans"),
    "vPlanTierStandardDesc": MessageLookupByLibrary.simpleMessage(
      "Auto-selects the fastest node · fast and sufficient",
    ),
    "vPlanTraffic": m89,
    "vPlanUnavailable": MessageLookupByLibrary.simpleMessage("Unavailable"),
    "vShareCodeLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to load invite code",
    ),
    "vShareCopyBrief": m90,
    "vShareCopyButton": MessageLookupByLibrary.simpleMessage("Copy text"),
    "vShareCopyDev": m91,
    "vShareCopyGeneral": m92,
    "vShareCopyTitle": MessageLookupByLibrary.simpleMessage("Share text"),
    "vShareGenerating": MessageLookupByLibrary.simpleMessage("Generating…"),
    "vShareInviteBoth": m93,
    "vShareInvitePlain": m94,
    "vShareInvitePrefix": m95,
    "vShareInvitePrefixBrief": m96,
    "vShareInviteReferee": m97,
    "vSharePageTitle": MessageLookupByLibrary.simpleMessage("Share Verstro"),
    "vSharePosterFeat1Desc": MessageLookupByLibrary.simpleMessage(
      "All apps, not just browsers",
    ),
    "vSharePosterFeat1Label": MessageLookupByLibrary.simpleMessage(
      "True global proxy",
    ),
    "vSharePosterFeat2Desc": MessageLookupByLibrary.simpleMessage(
      "Smart switching, no drops",
    ),
    "vSharePosterFeat2Label": MessageLookupByLibrary.simpleMessage(
      "Multi-region nodes",
    ),
    "vSharePosterFeat3Desc": MessageLookupByLibrary.simpleMessage(
      "No logs, fully encrypted",
    ),
    "vSharePosterFeat3Label": MessageLookupByLibrary.simpleMessage(
      "Privacy first",
    ),
    "vSharePosterFeat4Label": MessageLookupByLibrary.simpleMessage(
      "All platforms",
    ),
    "vSharePosterFileName": MessageLookupByLibrary.simpleMessage(
      "Verstro-invite-poster.png",
    ),
    "vSharePosterFooter": MessageLookupByLibrary.simpleMessage(
      "GPLv3 open-source client · auditable behavior",
    ),
    "vSharePosterGenFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to generate the image. Please try again.",
    ),
    "vSharePosterGetVerstro": MessageLookupByLibrary.simpleMessage(
      "Get Verstro",
    ),
    "vSharePosterHeadline": MessageLookupByLibrary.simpleMessage(
      "One-Tap Global Boost",
    ),
    "vSharePosterNotReady": MessageLookupByLibrary.simpleMessage(
      "The poster isn\'t ready yet. Please try again shortly.",
    ),
    "vSharePosterRewardBoth": m98,
    "vSharePosterRewardNone": MessageLookupByLibrary.simpleMessage(
      "Enter this invite code when signing up",
    ),
    "vSharePosterRewardReferee": m99,
    "vSharePosterSaved": MessageLookupByLibrary.simpleMessage("Poster saved"),
    "vSharePosterScanHint": MessageLookupByLibrary.simpleMessage(
      "Scan to download",
    ),
    "vSharePosterScanSite": MessageLookupByLibrary.simpleMessage(
      "Scan to visit the site and download the client",
    ),
    "vSharePosterSubline": MessageLookupByLibrary.simpleMessage(
      "Every app · stable, no drops",
    ),
    "vSharePosterTagline": MessageLookupByLibrary.simpleMessage(
      "Privacy-first global network",
    ),
    "vSharePosterTrialDays": m100,
    "vSharePosterTrialGeneric": MessageLookupByLibrary.simpleMessage(
      "free trial available",
    ),
    "vSharePosterTrialLine": m101,
    "vShareSaveCanceled": MessageLookupByLibrary.simpleMessage("Save canceled"),
    "vShareSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Save failed. Please try again.",
    ),
    "vShareSaveImage": MessageLookupByLibrary.simpleMessage("Save image"),
    "vShareStyleBrief": MessageLookupByLibrary.simpleMessage("Brief"),
    "vShareStyleDeveloper": MessageLookupByLibrary.simpleMessage(
      "For developers",
    ),
    "vShareStyleGeneral": MessageLookupByLibrary.simpleMessage("General"),
    "vShareTrialGeneral": MessageLookupByLibrary.simpleMessage(
      "New users can try it for free. ",
    ),
    "vShareTrialGeneralDays": m102,
    "vShareTrialShort": MessageLookupByLibrary.simpleMessage(
      "Free trial available. ",
    ),
    "vTrialActivated": MessageLookupByLibrary.simpleMessage("Trial activated!"),
    "vTrialClaimFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to claim, please try again",
    ),
    "vTrialClaimNow": MessageLookupByLibrary.simpleMessage("Claim now"),
    "vTrialSpec": m103,
    "vTrialTitle": MessageLookupByLibrary.simpleMessage("Free trial"),
    "vTrialVerifyEmailHint": m104,
    "vUpdAlreadyLatest": MessageLookupByLibrary.simpleMessage(
      "You\'re on the latest version",
    ),
    "vUpdChecksumFailed": MessageLookupByLibrary.simpleMessage(
      "Integrity check failed (sha256 mismatch); the download was discarded",
    ),
    "vUpdDownloadFailed": m105,
    "vUpdDownloadingProgress": m106,
    "vUpdExitApp": MessageLookupByLibrary.simpleMessage("Exit App"),
    "vUpdForceDesc": MessageLookupByLibrary.simpleMessage(
      "This version is no longer supported. Please update to continue.",
    ),
    "vUpdForceTitle": m107,
    "vUpdIgnoreThisVersion": MessageLookupByLibrary.simpleMessage(
      "Skip This Version",
    ),
    "vUpdInstallLaunchFailed": m108,
    "vUpdLater": MessageLookupByLibrary.simpleMessage("Later"),
    "vUpdNewVersionTitle": m109,
    "vUpdNoMatchingPackage": MessageLookupByLibrary.simpleMessage(
      "No installer package found for this device",
    ),
    "vUpdUpdateFailed": m110,
    "vUpdUpdateNow": MessageLookupByLibrary.simpleMessage("Update Now"),
    "value": MessageLookupByLibrary.simpleMessage("Value"),
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("Vibrant"),
    "view": MessageLookupByLibrary.simpleMessage("View"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "VPN configuration change detected",
    ),
    "vpnDesc": MessageLookupByLibrary.simpleMessage(
      "Modify VPN related settings",
    ),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "Auto routes all system traffic through VpnService",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Attach HTTP proxy to VpnService",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage(
      "Changes take effect after restarting the VPN",
    ),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "WebDAV configuration",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("Whitelist mode"),
    "years": MessageLookupByLibrary.simpleMessage("Years"),
    "yearsAgo": m111,
    "zh_CN": MessageLookupByLibrary.simpleMessage("Simplified Chinese"),
  };
}
