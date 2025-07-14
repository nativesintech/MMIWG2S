package com.mehequanna.mmiw

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.constraintlayout.motion.widget.MotionLayout
import androidx.fragment.app.Fragment
import com.mehequanna.mmiw.databinding.FragmentIntroBinding

class IntroFragment : Fragment() {
    var listener: OnIntroAnimationCompletedListener? = null
    private var _binding: FragmentIntroBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        _binding = FragmentIntroBinding.inflate(inflater, container, false)
        return binding.root
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
        binding.introMotionLayout.addTransitionListener(object : MotionLayout.TransitionListener {
            override fun onTransitionTrigger(p0: MotionLayout?, p1: Int, p2: Boolean, p3: Float) {}
            override fun onTransitionStarted(p0: MotionLayout?, p1: Int, p2: Int) {}
            override fun onTransitionChange(p0: MotionLayout?, p1: Int, p2: Int, p3: Float) {}
            override fun onTransitionCompleted(p0: MotionLayout?, p1: Int) {
                nextState()
            }
        })
        nextState()
    }

    private fun nextState() {
        when (binding.introMotionLayout.currentState) {
            R.id.animation_first -> binding.introMotionLayout.transitionToState(R.id.animation_second)
            R.id.animation_second -> binding.introMotionLayout.transitionToState(R.id.animation_third)
            R.id.animation_third -> {
                binding.root.postDelayed({ listener?.onIntroCompleted() }, 500)
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    interface OnIntroAnimationCompletedListener {
        fun onIntroCompleted()
    }
}
