package com.mehequanna.mmiw

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Matrix
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import android.util.TypedValue
import android.view.HapticFeedbackConstants
import android.view.PixelCopy
import android.view.View
import android.view.ViewTreeObserver
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ShareCompat
import androidx.core.content.FileProvider.getUriForFile
import androidx.core.view.ViewCompat
import androidx.viewpager2.widget.ViewPager2
import com.google.ar.core.ArCoreApk
import com.google.ar.core.AugmentedFace
import com.google.ar.core.TrackingState
import com.google.ar.sceneform.ArSceneView
import com.google.ar.sceneform.rendering.Renderable
import com.google.ar.sceneform.rendering.Texture
import com.google.ar.sceneform.ux.AugmentedFaceNode
import com.mehequanna.mmiw.adapter.StatisticsAdapter
import com.mehequanna.mmiw.network.RetrofitEventListener
import com.mehequanna.mmiw.network.Submission
import com.mehequanna.mmiw.network.SubmissionRestClient
import kotlinx.android.synthetic.main.activity_mmiw_ar.*
import retrofit2.Call
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class MmiwActivity : AppCompatActivity() {
    private val TAG: String = MmiwActivity::class.java.name
    private lateinit var arFragment: FaceArFragment
    private var faceMeshTexture: Texture? = null
    private var faceNodeMap = HashMap<AugmentedFace, AugmentedFaceNode>()
    private lateinit var sceneView: ArSceneView
    private val statisticsAdapter = StatisticsAdapter()

    private lateinit var redHand: Texture
    private lateinit var blackHand: Texture
    private var changeColor = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (!checkIsSupportedDeviceOrFinish()) {
            return
        }

        setContentView(R.layout.activity_mmiw_ar)
        arFragment = face_fragment as FaceArFragment
        Texture.builder()
            .setSource(this, R.drawable.hand_red_solid)
            .build()
            .thenAccept { texture ->
                redHand = texture
                faceMeshTexture = texture
            }

        Texture.builder()
            .setSource(this, R.drawable.hand_black_solid)
            .build()
            .thenAccept { texture ->
                blackHand = texture
            }

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
                            } else if (changeColor) {
                                faceNodeMap.getValue(f).faceMeshTexture = faceMeshTexture
                            }
                        }
                        changeColor = false
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

        setupStatisticsViewPager()

        setViewOnClickerListeners()
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

    private fun setupStatisticsViewPager() {
        statisticsViewPager.adapter = statisticsAdapter
        statisticsAdapter.setStatisticsAdapterData(Statistics(this).statisticsList)

        with(statisticsViewPager) {
            offscreenPageLimit = 3
        }

        updateViewPagerTransformer(
            resources.getDimensionPixelOffset(R.dimen.viewpager_offset),
            resources.getDimensionPixelOffset(R.dimen.page_margin)
        )
    }

    private fun updateViewPagerTransformer(offsetPixels: Int, pageMarginPixels: Int) {
        statisticsViewPager.setPageTransformer { page, position ->
            val viewPager = page.parent.parent as ViewPager2
            val offset = position * -(2 * offsetPixels + pageMarginPixels)
            if (viewPager.orientation == ViewPager2.ORIENTATION_HORIZONTAL) {
                if (ViewCompat.getLayoutDirection(viewPager) == ViewCompat.LAYOUT_DIRECTION_RTL) {
                    page.translationX = -offset
                } else {
                    page.translationX = offset
                }
            } else {
                page.translationY = offset
            }
        }
    }

    private fun setViewOnClickerListeners() {
        capture_button.setOnClickListener {
            it.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            changeButtonVisibility(false)
            pauseSceneView(true)
        }

        share_button.setOnClickListener {
            it.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            back_group.visibility = View.INVISIBLE
            share_group.visibility = View.INVISIBLE
            statisticsViewPager.visibility = View.GONE
            statisticsCaptureView.apply {
                visibility = View.VISIBLE
                text = statisticsAdapter.getCurrentItemText(statisticsViewPager.currentItem)
                waitForLayout {
                    takePhoto()
                }
            }
            share_button.isEnabled = false
        }

        back_button.setOnClickListener {
            it.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            changeButtonVisibility(true)
            pauseSceneView(false)
        }

        color_button_black.setOnClickListener { blackButton ->
            blackButton.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            blackButton.updateHeightWidth(54f.toDips(resources))

            color_button_red.updateHeightWidth(36f.toDips(resources))
            faceMeshTexture = blackHand
            changeColor = true
        }

        color_button_red.setOnClickListener { redButton ->
            redButton.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            redButton.updateHeightWidth(54f.toDips(resources))

            color_button_black.updateHeightWidth(36f.toDips(resources))
            faceMeshTexture = redHand
            changeColor = true
        }
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

    private fun changeButtonVisibility(isCapturing: Boolean) {
        // Capture and hand option view
        color_button_black.visibility = if (isCapturing) View.VISIBLE else View.GONE
        color_button_red.visibility = if (isCapturing) View.VISIBLE else View.GONE
        capture_button.visibility = if (isCapturing) View.VISIBLE else View.GONE
        capture_button.isEnabled = isCapturing

        // Statistics and send view.
        back_group.visibility = if (isCapturing) View.GONE else View.VISIBLE
        share_group.visibility = if (isCapturing) View.GONE else View.VISIBLE
        statisticsViewPager.visibility = if (isCapturing) View.GONE else View.VISIBLE
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
                val databaseFile: File?
                try {
                    val screenElementsBitmap: Bitmap = takeScreenshot()
                    val combinedBitmap: Bitmap =
                        combineBitmaps(arViewBitmap, screenElementsBitmap)

                    databaseFile = saveBitmapToDisk(combinedBitmap.compressBitmapForDatabase())
                    file = saveBitmapToDisk(combinedBitmap)
                } catch (e: Exception) {
                    val toast: Toast = Toast.makeText(
                        this, e.toString(),
                        Toast.LENGTH_LONG
                    )
                    toast.show()
                    return@request
                }

                val newSubmission = Submission().apply {
                    this.name = "Testing This"
                    this.email = "upload_newtest@gmail.com"
                    this.image = databaseFile
                }

                sendPhotoToBackend(newSubmission)
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
                statisticsCaptureView.visibility = View.INVISIBLE
                share_button.isEnabled = true
            }

            handlerThread.quitSafely()
        }, Handler(handlerThread.looper))
    }

    private fun sharePhoto(file: File) {
        val photoURI = getUriForFile(this, "com.mehequanna.mmiw.fileprovider", file)

        // TODO figure where to share.
        val intent: Intent = ShareCompat.IntentBuilder.from(this)
            .setType("image/png")
            .setSubject("MMIW Support Image") // TODO
            .setStream(photoURI)
            .setChooserTitle("R.string.share_title")
            .createChooserIntent()
            .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

        grantReadUriPermission(intent, photoURI)

        startActivity(intent)
    }

    private fun sendPhotoToBackend(submission: Submission) {
        SubmissionRestClient.instance.submitUserInfo(submission, object : RetrofitEventListener {
            override fun onSuccess(call: Call<*>?, response: Any?) {
                // TODO
                Log.d(TAG, response.toString())
            }

            override fun onError(call: Call<*>?, t: Throwable?) {
                // TODO
                Log.d(TAG, "Image failed to upload to server with error: ${t.toString()}")
            }
        })
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
            val file = File(imagePath, "mmiw_photo.png")

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

private inline fun View.waitForLayout(crossinline action: () -> Unit) {
    viewTreeObserver.also {
        it.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
            override fun onGlobalLayout() {
                when {
                    it.isAlive -> {
                        it.removeOnGlobalLayoutListener(this)
                        action()
                    }
                    else -> viewTreeObserver.removeOnGlobalLayoutListener(this)
                }
            }
        })
    }
}

private fun View.updateHeightWidth(size: Int) {
    this.layoutParams = this.layoutParams.apply {
        this.width = size
        this.height = size
    }
}

fun Float.toDips(resources: Resources): Int =
    TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, this, resources.displayMetrics).toInt()

// After some rough testing, a bitmap height of 1300 gets us to around 1mb.
// So by dividing 1300 by the current bitmap height we get a percentage as a decimal.
// We can use that to scale height and width proportionally.
private fun Bitmap.compressBitmapForDatabase(): Bitmap {
    val modifier = 1300 / this.height.toDouble()
    val width = (this.width * modifier).toInt()
    val height = (this.height * modifier).toInt()
    return Bitmap.createScaledBitmap(this, width, height, true)
}
