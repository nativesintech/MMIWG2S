package com.mehequanna.mmiw

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import kotlinx.android.synthetic.main.fragment_stat_slide.*

class StatSlideFragment : Fragment() {

    private var backgroundRes: Int = 0
    private var statString: String = ""
    private var pageNum: Int = 0

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        val view = inflater.inflate(R.layout.fragment_stat_slide, container, false)
        createStatSlide(backgroundRes, statString, pageNum)
        return view
    }

    fun newInstance(backgroundRes: Int, statString: String, pageNum: Int): StatSlideFragment {
        val fragmentFirst = StatSlideFragment()
        val args = Bundle()
        args.putInt(ARG_BACKGROUND_RES, backgroundRes)
        args.putString(ARG_STAT_TEXT, statString)
        args.putInt(ARG_PAGE_NUM, pageNum)
        fragmentFirst.arguments = args
        return fragmentFirst
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (arguments != null) {
            backgroundRes = arguments!!.getInt(ARG_BACKGROUND_RES)
            statString = arguments!!.getString(ARG_STAT_TEXT, "")
            pageNum = arguments!!.getInt(ARG_PAGE_NUM)
        }
    }

    fun createStatSlide(backgroundRes: Int, text: String, pageNum: Int) {
        statImage.setImageResource(backgroundRes)
        statText.text = text
        progressIndicator.setPage(pageNum)
    }

    companion object {
        val ARG_BACKGROUND_RES = "backgroundRes"
        val ARG_STAT_TEXT = "statTextString"
        val ARG_PAGE_NUM = "pageNum"
    }

}