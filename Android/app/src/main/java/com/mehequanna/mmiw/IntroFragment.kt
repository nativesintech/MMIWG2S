package com.mehequanna.mmiw

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.constraintlayout.motion.widget.MotionLayout
import androidx.fragment.app.Fragment
import kotlinx.android.synthetic.main.fragment_intro.*
import java.lang.ClassCastException

class IntroFragment : Fragment() {
    var listener: OnIntroAnimationCompletedListener? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_intro, container, false)
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        listener = context as? OnIntroAnimationCompletedListener
        if (listener == null) {
            throw ClassCastException("$context must implement onIntroAnimationCompletedListener")
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        intro_motion_layout.addTransitionListener(object : MotionLayout.TransitionListener {
            override fun onTransitionTrigger(p0: MotionLayout?, p1: Int, p2: Boolean, p3: Float) {
            }

            override fun onTransitionStarted(p0: MotionLayout?, p1: Int, p2: Int) {
            }

            override fun onTransitionChange(p0: MotionLayout?, p1: Int, p2: Int, p3: Float) {
            }

            override fun onTransitionCompleted(p0: MotionLayout?, p1: Int) {
                view.postDelayed( { listener?.onIntroCompleted() }, 500)
            }
        })
        view.postDelayed( { intro_motion_layout.transitionToEnd() }, 1500)
    }

    interface OnIntroAnimationCompletedListener {
        fun onIntroCompleted()
    }
}
