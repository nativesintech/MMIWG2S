package com.mehequanna.mmiw

import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.ComposeView
import androidx.constraintlayout.compose.MotionLayout
import androidx.constraintlayout.compose.MotionScene
import androidx.fragment.app.Fragment

class IntroFragment : Fragment() {
    var listener: OnIntroAnimationCompletedListener? = null

    override fun onAttach(context: Context) {
        super.onAttach(context)
        listener = context as? OnIntroAnimationCompletedListener
        if (listener == null) {
            throw ClassCastException("$context must implement onIntroAnimationCompletedListener")
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setContent {
//                IntroScreenWithAnimation(onAnimationEnd = {
//                    listener?.onIntroCompleted()
//                })
                MissingAnimationScreen()
            }
        }
    }

    interface OnIntroAnimationCompletedListener {
        fun onIntroCompleted()
    }
}

@Composable
fun IntroScreenWithAnimation(onAnimationEnd: () -> Unit) {
    var progress by remember { mutableStateOf(0f) }
    var stage by remember { mutableStateOf(0) }
    val handler = remember { Handler(Looper.getMainLooper()) }

    // Compose MotionScene as a string resource
    val motionScene = remember {
        // This should be the JSON version of your MotionScene
        IntroMotionScene.composeMotionScene
    }

    // Animate progress using LaunchedEffect and Animatable
    val animatable = remember { androidx.compose.animation.core.Animatable(0f) }

    LaunchedEffect(stage) {
        when (stage) {
            0 -> {
                animatable.animateTo(1f, animationSpec = androidx.compose.animation.core.tween(3000))
                progress = animatable.value
                stage = 1
            }
            1 -> {
                animatable.animateTo(2f, animationSpec = androidx.compose.animation.core.tween(2500))
                progress = animatable.value
                stage = 2
            }
            2 -> {
                handler.postDelayed({ onAnimationEnd() }, 500)
            }
        }
    }

    // Map progress to the correct range for each stage
    val mappedProgress = when (stage) {
        0 -> animatable.value
        1 -> animatable.value - 1f
        2 -> 1f
        else -> 0f
    }

    MotionLayout(
        motionScene = MotionScene(motionScene),
        progress = mappedProgress,
        modifier = Modifier
            .fillMaxSize()
    ) {
        IntroScreenContent()
    }
}
