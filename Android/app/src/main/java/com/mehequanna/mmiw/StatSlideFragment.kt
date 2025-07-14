package com.mehequanna.mmiw

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.mehequanna.mmiw.databinding.FragmentStatSlideBinding

class StatSlideFragment : Fragment() {

    private var backgroundRes: Int = 0
    private var statString: String = ""
    private var pageIndex: Int = 0
    private var _binding: FragmentStatSlideBinding? = null
    private val binding get() = _binding!!

    fun newInstance(backgroundRes: Int, statString: String, pageIndex: Int): StatSlideFragment {
        val fragment = StatSlideFragment()
        val args = Bundle()
        args.putInt(ARG_BACKGROUND_RES, backgroundRes)
        args.putString(ARG_STAT_TEXT, statString)
        args.putInt(ARG_PAGE_INDEX, pageIndex)
        fragment.arguments = args
        return fragment
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (arguments != null) {
            backgroundRes = requireArguments().getInt(ARG_BACKGROUND_RES)
            statString = requireArguments().getString(ARG_STAT_TEXT, "")
            pageIndex = requireArguments().getInt(ARG_PAGE_INDEX)
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentStatSlideBinding.inflate(inflater, container, false)
        createStatSlide(backgroundRes, statString)
        return binding.root
    }

    private fun createStatSlide(
        backgroundRes: Int,
        text: String
    ) {
        binding.statImage.setImageResource(backgroundRes)
        binding.statText.text = text
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    companion object {
        const val ARG_BACKGROUND_RES = "backgroundRes"
        const val ARG_STAT_TEXT = "statTextString"
        const val ARG_PAGE_INDEX = "pageIndex"
    }

}
