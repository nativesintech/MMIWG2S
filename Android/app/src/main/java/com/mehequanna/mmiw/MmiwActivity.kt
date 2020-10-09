package com.mehequanna.mmiw

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Matrix
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.HandlerThread
import android.view.HapticFeedbackConstants
import android.view.PixelCopy
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ShareCompat
import androidx.core.content.FileProvider.getUriForFile
import com.google.ar.core.ArCoreApk
import com.google.ar.core.AugmentedFace
import com.google.ar.core.TrackingState
import com.google.ar.sceneform.ArSceneView
import com.google.ar.sceneform.rendering.Renderable
import com.google.ar.sceneform.rendering.Texture
import com.google.ar.sceneform.ux.AugmentedFaceNode
import kotlinx.android.synthetic.main.activity_mmiw_ar.*
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class MmiwActivity : AppCompatActivity() {
    private lateinit var arFragment: FaceArFragment
    private var faceMeshTexture: Texture? = null
    private var faceNodeMap = HashMap<AugmentedFace, AugmentedFaceNode>()
    private lateinit var sceneView: ArSceneView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (!checkIsSupportedDeviceOrFinish()) {
            return
        }

        setContentView(R.layout.activity_mmiw_ar)
        arFragment = face_fragment as FaceArFragment
        Texture.builder()
            .setSource(this, R.drawable.red_hand_80_texture)
            .build()
            .thenAccept { texture -> faceMeshTexture = texture }

        sceneView = arFragment.arSceneView
        sceneView.cameraStreamRenderPriority = Renderable.RENDER_PRIORITY_FIRST
        val scene = sceneView.scene

        scene.addOnUpdateListener {
            faceMeshTexture.let {
                sceneView.session
                    ?.getAllTrackables(AugmentedFace::class.java)?.let {
                        for (f in it) {
                            if (!faceNodeMap.containsKey(f)) {
                                val faceNode = AugmentedFaceNode(f)
                                faceNode.setParent(scene)
                                faceNode.faceMeshTexture = faceMeshTexture
                                faceNodeMap[f] = faceNode
                            }
                        }
                        // Remove any AugmentedFaceNodes associated with an AugmentedFace that stopped tracking.
                        val iter = faceNodeMap.entries.iterator()
                        while (iter.hasNext()) {
                            val entry = iter.next()
                            val face = entry.key
                            if (face.trackingState == TrackingState.STOPPED) {
                                val faceNode = entry.value
                                faceNode.setParent(null)
                                iter.remove()
                            }
                        }
                    }
            }
        }

        capture_button.setOnClickListener {
            it.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            changeButtonVisibility(false)
            pauseSceneView(true)
        }

        send_button.setOnClickListener {
            it.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            takePhoto()
            send_button.isEnabled = false
        }

        back_button.setOnClickListener {
            it.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            changeButtonVisibility(true)
            pauseSceneView(false)
        }
    }

    private fun checkIsSupportedDeviceOrFinish(): Boolean {
        if (ArCoreApk.getInstance()
                .checkAvailability(this) == ArCoreApk.Availability.UNSUPPORTED_DEVICE_NOT_CAPABLE
        ) {
            Toast.makeText(this, "Augmented Faces requires ARCore", Toast.LENGTH_LONG).show()
            finish()
            return false
        }
        val openGlVersionString = (getSystemService(Context.ACTIVITY_SERVICE) as? ActivityManager)
            ?.deviceConfigurationInfo
            ?.glEsVersion

        openGlVersionString?.let { _ ->
            if (java.lang.Double.parseDouble(openGlVersionString) < MIN_OPENGL_VERSION) {
                Toast.makeText(this, "Sceneform requires OpenGL ES 3.0 or later", Toast.LENGTH_LONG)
                    .show()
                finish()
                return false
            }
        }
        return true
    }

    private fun takeScreenshot(): Bitmap =
        mmiw_overlay_view.let { view ->
            val bitmap = Bitmap.createBitmap(
                view.width,
                view.height,
                Bitmap.Config.ARGB_8888
            )
            val canvas = Canvas(bitmap)
            view.draw(canvas)
            return bitmap
        }

    private fun combineBitmaps(baseBitmap: Bitmap, overlayBitmap: Bitmap): Bitmap {
        val combinedBitmap =
            Bitmap.createBitmap(baseBitmap.width, baseBitmap.height, baseBitmap.config)
        val canvas = Canvas(combinedBitmap)
        canvas.drawBitmap(baseBitmap, Matrix(), null)
        canvas.drawBitmap(overlayBitmap, 0f, 0f, null)
        return combinedBitmap
    }

    private fun changeButtonVisibility(showCapture: Boolean) {
        back_group.visibility = if (showCapture) View.GONE else View.VISIBLE
        send_to_group.visibility = if (showCapture) View.GONE else View.VISIBLE
        capture_button.visibility = if (showCapture) View.VISIBLE else View.GONE
        capture_button.isEnabled = showCapture
    }

    private fun pauseSceneView(pause: Boolean) =
        if (pause) sceneView.pause() else sceneView.resume()

    private fun takePhoto() {
        val arSceneView: ArSceneView = arFragment.arSceneView

        // Create a bitmap the size of the scene view.
        val arViewBitmap = Bitmap.createBitmap(
            arSceneView.width,
            arSceneView.height,
            Bitmap.Config.ARGB_8888
        )

        // Create a handler thread to offload the processing of the image.
        val handlerThread = HandlerThread("PixelCopier")
        handlerThread.start()
        // Make the request to copy.
        PixelCopy.request(arSceneView, arViewBitmap, { copyResult ->
            if (copyResult == PixelCopy.SUCCESS) {
                val file: File?
                try {
                    val screenElementsBitmap: Bitmap = takeScreenshot()
                    val combinedBitmap: Bitmap =
                        combineBitmaps(arViewBitmap, screenElementsBitmap)

                    file = saveBitmapToDisk(combinedBitmap)
                } catch (e: Exception) {
                    val toast: Toast = Toast.makeText(
                        this, e.toString(),
                        Toast.LENGTH_LONG
                    )
                    toast.show()
                    return@request
                }

                sharePhoto(file)
            } else {
                val toast = Toast.makeText(
                    this,
                    "Failed to save image: $copyResult", Toast.LENGTH_LONG
                )
                toast.show()
            }

            // Re-enable capture_button even if the PixelCopy fails.
            runOnUiThread {
                changeButtonVisibility(true)
                send_button.isEnabled = true
            }

            handlerThread.quitSafely()
        }, Handler(handlerThread.looper))
    }

    private fun sharePhoto(file: File) {
        val photoURI = getUriForFile(this, "com.mehequanna.mmiw.fileprovider", file)

        // TODO figure where to share.
        val intent: Intent = ShareCompat.IntentBuilder.from(this)
            .setType("image/jpg")
            .setSubject("MMIW Support Image") // TODO
            .setStream(photoURI)
            .setChooserTitle("R.string.share_title")
            .createChooserIntent()
            .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

        grantReadUriPermission(intent, photoURI)

        startActivity(intent)
    }

    private fun grantReadUriPermission(intent: Intent, photoURI: Uri) {
        val resInfoList: List<ResolveInfo> = this.packageManager
            .queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
        for (resolveInfo in resInfoList) {
            val packageName: String = resolveInfo.activityInfo.packageName
            this.grantUriPermission(
                packageName,
                photoURI,
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION
            )
        }
    }

    @Throws(IOException::class)
    private fun saveBitmapToDisk(bitmap: Bitmap): File {
        try {
            val imagePath = File(cacheDir, "images")
            if (!imagePath.exists()) {
                imagePath.mkdir()
            }
            val file = File(imagePath, "mmiw_photo.jpg")

            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
            val image = stream.toByteArray()

            val fos = FileOutputStream(file)
            fos.write(image)
            fos.close()

            return file
        } catch (e: Exception) {
            throw java.lang.Exception("Error writing temp queued file", e)
        }
    }

    companion object {
        const val MIN_OPENGL_VERSION = 3.0
    }
}
