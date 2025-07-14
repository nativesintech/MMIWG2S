package com.mehequanna.mmiw

import android.content.Context
import android.os.Bundle
import android.transition.TransitionInflater
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.mehequanna.mmiw.databinding.FragmentRespectPageBinding

class TermsFragment : Fragment() {
    var listener: OnTermsAcceptedListener? = null
    private var _binding: FragmentRespectPageBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentRespectPageBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val inflater = TransitionInflater.from(requireContext())
        exitTransition = inflater.inflateTransition(R.transition.slide_left)
        enterTransition = inflater.inflateTransition(R.transition.slide_right)
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        listener = context as? OnTermsAcceptedListener
        if (listener == null) {
            throw ClassCastException("$context must implement OnTermsAcceptedListener")
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.acceptButton.setOnClickListener {
            listener?.onTermsAccepted()
        }
        binding.termsMotionLayout.transitionToEnd()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    interface OnTermsAcceptedListener {
        fun onTermsAccepted()
    }
}
