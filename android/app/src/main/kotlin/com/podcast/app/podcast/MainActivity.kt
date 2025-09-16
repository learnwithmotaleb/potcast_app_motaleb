package com.podcast.app.podcast

import android.content.Context
import android.media.MediaMetadataRetriever
import android.net.Uri
import androidx.annotation.NonNull
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : AudioServiceActivity() {
    private val CHANNEL = "com.podcast.media/duration"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        println("MainActivity: configureFlutterEngine called")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                println("Method called: ${call.method}")
                when (call.method) {
                    "getMediaDuration" -> {
                        val path = call.argument<String>("path")
                        if (path.isNullOrBlank()) {
                            result.error("INVALID_ARGUMENT", "path is required", null)
                            return@setMethodCallHandler
                        }

                        try {
                            val durationMs = getMediaDuration(this.applicationContext, path)
                            if (durationMs == null) {
                                result.success(
                                    mapOf(
                                        "success" to false,
                                        "error" to "Could not read duration"
                                    )
                                )
                            } else {
                                val durationSeconds = durationMs.toDouble() / 1000.0
                                result.success(
                                    mapOf(
                                        "success" to true,
                                        "durationMillis" to durationMs,
                                        "durationSeconds" to durationSeconds,
                                        "durationString" to formatDuration(durationMs)
                                    )
                                )
                            }
                        } catch (e: Exception) {
                            result.success(
                                mapOf(
                                    "success" to false,
                                    "error" to (e.localizedMessage ?: "unknown error")
                                )
                            )
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun getMediaDuration(context: Context, path: String): Long? {
        val retriever = MediaMetadataRetriever()
        try {
            when {
                path.startsWith("content://") || path.startsWith("file://") -> {
                    retriever.setDataSource(context, Uri.parse(path))
                }
                path.startsWith("http://") || path.startsWith("https://") -> {
                    retriever.setDataSource(path, HashMap())
                }
                else -> {
                    retriever.setDataSource(path) // absolute local path
                }
            }
            val dur = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
            return dur?.toLongOrNull()
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        } finally {
            try {
                retriever.release()
            } catch (_: Throwable) {
            }
        }
    }

    private fun formatDuration(durationMs: Long): String {
        var seconds = durationMs / 1000
        val hours = seconds / 3600
        seconds %= 3600
        val minutes = seconds / 60
        val secs = seconds % 60
        return if (hours > 0) {
            String.format(Locale.getDefault(), "%d:%02d:%02d", hours, minutes, secs)
        } else {
            String.format(Locale.getDefault(), "%02d:%02d", minutes, secs)
        }
    }
}
