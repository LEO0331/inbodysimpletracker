package com.example.inbodysimpletracker

import io.flutter.embedding.android.FlutterActivity
import android.app.Activity
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.view.WindowManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private var exportResult: MethodChannel.Result? = null
    private var exportSource: File? = null
    private val exportExecutor = Executors.newSingleThreadExecutor()
    private val exportRequest = 7318

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "inbodysimpletracker/private_health")
            .setMethodCallHandler { call, result ->
                if (call.method == "setSensitiveView") {
                    if (call.argument<Boolean>("visible") == true) {
                        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    } else {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    }
                    result.success(true)
                    return@setMethodCallHandler
                }
                val path = call.argument<String>("path")
                if (path == null) {
                    result.error("private_health", "Private operation unavailable.", null)
                } else when (call.method) {
                    "protectImportFile" -> {
                        try {
                            val source = File(path).canonicalFile
                            val cache = cacheDir.canonicalFile
                            if (!source.path.startsWith(cache.path + File.separator) || !source.isFile ||
                                source.extension.lowercase() !in setOf("xml", "zip") || isDeviceProtectedStorage ||
                                (applicationInfo.flags and ApplicationInfo.FLAG_ALLOW_BACKUP) != 0) throw SecurityException()
                            result.success(true)
                        } catch (_: Exception) {
                            result.error("private_health", "Protected import unavailable.", null)
                        }
                    }
                    "protectDirectory" -> {
                        try {
                            val directory = File(path).canonicalFile
                            val expected = File(filesDir, "private_health_data").canonicalFile
                            if (directory != expected || !directory.isDirectory) throw SecurityException()
                            if ((applicationInfo.flags and ApplicationInfo.FLAG_ALLOW_BACKUP) != 0) throw SecurityException()
                            result.success(true)
                        } catch (_: Exception) {
                            result.error("private_health", "Protected storage unavailable.", null)
                        }
                    }
                    "exportBackup" -> {
                        try {
                            val source = File(path).canonicalFile
                            val allowed = File(cacheDir, "health_backups").canonicalFile
                            if (exportResult != null || source.parentFile != allowed || !source.isFile ||
                                !source.name.matches(Regex("^[a-f0-9]{32}\\.healthbackup$"))) throw SecurityException()
                            val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                                addCategory(Intent.CATEGORY_OPENABLE)
                                type = "application/octet-stream"
                                putExtra(Intent.EXTRA_TITLE, "private-health.healthbackup")
                            }
                            exportResult = result
                            exportSource = source
                            startActivityForResult(intent, exportRequest)
                        } catch (_: Exception) {
                            exportResult = null
                            exportSource = null
                            result.error("private_health", "Encrypted Files export unavailable.", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode != exportRequest) {
            super.onActivityResult(requestCode, resultCode, data)
            return
        }
        val result = exportResult ?: return
        val source = exportSource
        exportResult = null
        exportSource = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || source == null || uri == null) {
            result.success(false)
            return
        }
        exportExecutor.execute {
            try {
                source.inputStream().use { input ->
                    contentResolver.openOutputStream(uri, "w").use { output ->
                        if (output == null) throw IllegalStateException()
                        input.copyTo(output)
                    }
                }
                runOnUiThread { result.success(true) }
            } catch (_: Exception) {
                runOnUiThread { result.error("private_health", "Encrypted Files export failed.", null) }
            }
        }
    }

    override fun onDestroy() {
        exportResult?.error("private_health", "Files export interrupted.", null)
        exportResult = null
        exportSource = null
        exportExecutor.shutdown()
        super.onDestroy()
    }
}
