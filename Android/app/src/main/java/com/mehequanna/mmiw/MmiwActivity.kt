package com.mehequanna.mmiw

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
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
import kotlinx.android.synthetic.main.share_with_us_layout.*
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

    private var imagesObtained = false
    private lateinit var combinedBitmap: Bitmap
    private lateinit var imageFile: File
    private lateinit var databaseImageFile: File

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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SHARE_INTENT_CODE) {
            if (resultCode == RESULT_OK || resultCode == RESULT_CANCELED) {
                resetToCapturing()
            }
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

    // this sets all the views back to how they should be when capturing as if it were the first time
    private fun resetToCapturing() {
        pauseSceneView(false)
        changeButtonVisibility(true)
        statisticsCaptureView.visibility = View.INVISIBLE
        share_button.isEnabled = true
        imagesObtained = false
    }

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
                val bitmap: Bitmap?
                try {
                    val screenElementsBitmap: Bitmap = takeScreenshot()
                    bitmap = combineBitmaps(arViewBitmap, screenElementsBitmap)
                    databaseFile = saveBitmapToDisk(bitmap.compressBitmapForDatabase())
                    file = saveBitmapToDisk(bitmap)
                    saveImageFiles(bitmap, file, databaseFile)
                } catch (e: Exception) {
                    val toast: Toast = Toast.makeText(
                        this, e.toString(),
                        Toast.LENGTH_LONG
                    )
                    toast.show()
                    return@request
                }
            } else {
                val toast = Toast.makeText(
                    this,
                    "Failed to save image: $copyResult", Toast.LENGTH_LONG
                )
                toast.show()
            }

            // Re-enable capture_button even if the PixelCopy fails.
            runOnUiThread {
                if (!imagesObtained) {
                    changeButtonVisibility(true)
                    statisticsCaptureView.visibility = View.INVISIBLE
                    share_button.isEnabled = true
                }
                if (imagesObtained) {
                    showShareWithUs()
                }
            }

            handlerThread.quitSafely()
        }, Handler(handlerThread.looper))
    }

    private fun saveImageFiles(bitmap: Bitmap, file: File, databaseFile: File) {
        combinedBitmap = bitmap
        imageFile = file
        databaseImageFile = databaseFile
        imagesObtained = true
    }

    private fun showShareWithUs() {
        swu_photo.setImageBitmap(combinedBitmap)
        fadeInView(share_with_us_layout)

        swu_skip_button.setOnClickListener {
            fadeOutView(share_with_us_layout) { sharePhoto(imageFile) }
        }
        swu_back_button.setOnClickListener {
            fadeOutView(share_with_us_layout)
            resetToCapturing()
        }
        swu_share_button.setOnClickListener {
            val newSubmission = Submission().apply {
                this.name = swu_name_edit_text.text.toString()
                this.email = swu_email_edit_text.text.toString()
                this.image = databaseImageFile
            }
            sendPhotoToBackend(newSubmission)
            share_with_us_layout.visibility = View.GONE
            sharePhoto(imageFile)
        }
    }

    private fun sharePhoto(file: File) {
        val photoURI = getUriForFile(this, "com.mehequanna.mmiw.fileprovider", file)

        // TODO figure where to share.
        val intent: Intent = ShareCompat.IntentBuilder.from(this)
            .setType("image/png")
            .setSubject("MMIW Support Image") // TODO
            .setStream(photoURI)
            .setChooserTitle(getString(R.string.share_title))
            .createChooserIntent()
            .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

        grantReadUriPermission(intent, photoURI)

        startActivityForResult(intent, 12)
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

    private fun fadeInView(view: View) {
        if (view.visibility != View.VISIBLE) {
            view.alpha = 0f
            view.visibility = View.VISIBLE
            view
                .animate()
                .alpha(1f)
                .setDuration(200)
                .setListener(null)
                .start()
        }
    }

    private fun fadeOutView(view: View?, onAnimationEnd: (() -> Unit)? = null) {
        if (view != null && view.visibility != View.GONE) {
            view
                .animate()
                .alpha(0f)
                .setDuration(200)
                .setListener(object : AnimatorListenerAdapter() {
                    override fun onAnimationEnd(animation: Animator) {
                        view.visibility = View.GONE
                        onAnimationEnd?.invoke()
                    }
                })
                .start()
        }
    }

    companion object {
        const val MIN_OPENGL_VERSION = 3.0
        private const val SHARE_INTENT_CODE = 12
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
