package com.follow.clash.plugins

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import com.follow.clash.common.Components
import com.follow.clash.common.GlobalState
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.lang.ref.WeakReference

/**
 * Verstro 应用内升级: 把 Dart 侧下好并校验过 sha256 的 APK 交给系统安装器.
 *
 * 依赖 AndroidManifest 声明:
 *   - REQUEST_INSTALL_PACKAGES 权限
 *   - 一个 FileProvider, authority = "${applicationId}.updateprovider",
 *     paths = res/xml/update_file_paths.xml (覆盖 cacheDir, 对应 Dart getTemporaryDirectory()).
 *
 * Android 8+ 安装"未知来源"需用户逐 app 授权: 无权限时跳系统设置页引导,
 * 用户开启后需再次点"立即更新"(本插件不缓存待装文件, 由 Dart 重新触发).
 *
 * channel 名须与 Dart apk_installer.dart 的 '$packageName/update' 对齐
 * (Components.PACKAGE_NAME == Dart const packageName == "com.follow.clash").
 */
class UpdatePlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activityRef: WeakReference<Activity>? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "installApk" -> {
                val path = call.argument<String>("path")
                if (path.isNullOrEmpty()) {
                    result.error("invalid_args", "path 为空", null)
                    return
                }
                installApk(path, result)
            }

            else -> result.notImplemented()
        }
    }

    private fun installApk(path: String, result: Result) {
        val context = GlobalState.application
        val file = File(path)
        if (!file.exists()) {
            result.error("file_not_found", "APK 文件不存在: $path", null)
            return
        }

        // Android 8+ 需"安装未知应用"授权; 无授权先跳设置页引导
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            !context.packageManager.canRequestPackageInstalls()
        ) {
            val settingsIntent = Intent(
                Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                Uri.parse("package:${context.packageName}"),
            ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            try {
                (activityRef?.get() ?: context).startActivity(settingsIntent)
            } catch (_: Exception) {
                // 个别 ROM 无此设置页, 忽略——下面的 error 让 Dart 提示用户手动装
            }
            result.error(
                "install_permission_required",
                "需要先在系统设置里允许 Verstro 安装未知来源应用, 然后重试",
                null,
            )
            return
        }

        val authority = "${context.packageName}.updateprovider"
        val uri: Uri = try {
            FileProvider.getUriForFile(context, authority, file)
        } catch (e: Exception) {
            result.error("file_provider_error", e.message, null)
            return
        }

        val installIntent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "application/vnd.android.package-archive")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            (activityRef?.get() ?: context).startActivity(installIntent)
            result.success(true)
        } catch (e: Exception) {
            result.error("install_failed", e.message, null)
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "${Components.PACKAGE_NAME}/update")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityRef = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityRef = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityRef = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivity() {
        activityRef = null
    }
}
