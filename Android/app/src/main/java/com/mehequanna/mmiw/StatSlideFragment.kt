package com.mehequanna.mmiw

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import kotlinx.android.synthetic.main.fragment_stat_slide.view.*

class StatSlideFragment : Fragment() {

    private var backgroundRes: Int = 0
    private var statString: String = ""
    private var pageIndex: Int = 0

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
            backgroundRes = arguments!!.getInt(ARG_BACKGROUND_RES)
            statString = arguments!!.getString(ARG_STAT_TEXT, "")
            pageIndex = arguments!!.getInt(ARG_PAGE_INDEX)
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        val view = inflater.inflate(R.layout.fragment_stat_slide, container, false)
        createStatSlide(view, backgroundRes, statString)
        return view
    }

    private fun createStatSlide(
        view: View,
        backgroundRes: Int,
        text: String
    ) {
        view.statImage.setImageResource(backgroundRes)
        view.statText.text = text
    }

    companion object {
        const val ARG_BACKGROUND_RES = "backgroundRes"
        const val ARG_STAT_TEXT = "statTextString"
        const val ARG_PAGE_INDEX = "pageIndex"
    }

}
