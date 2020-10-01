package com.mehequanna.mmiw

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentStatePagerAdapter
import androidx.viewpager.widget.ViewPager
import kotlinx.android.synthetic.main.fragment_stat_viewpager.*

class StatViewPagerFragment : Fragment() {

    private lateinit var pagerAdapter: StatSlidePagerAdapter

    var listener: OnStatsCompletedListener? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_stat_viewpager, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        pagerAdapter =
            StatSlidePagerAdapter(fragmentManager ?: requireActivity().supportFragmentManager)
        stat_pager.adapter = pagerAdapter
        stat_pager.currentItem = 0
        stat_pager.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {

            override fun onPageScrollStateChanged(state: Int) {
            }

            override fun onPageScrolled(
                position: Int,
                positionOffset: Float,
                positionOffsetPixels: Int
            ) {

            }

            override fun onPageSelected(position: Int) {
                progressIndicator.setPage(position)
            }

        })
        progressIndicator.setPage(stat_pager.currentItem)
        nextButton.setOnClickListener {
            onNextPressed()
        }
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        listener = context as? OnStatsCompletedListener
        if (listener == null) {
            throw ClassCastException("$context must implement OnArticleSelectedListener")
        }
    }

    private fun onNextPressed() {
        val currentPage = stat_pager.currentItem
        if (currentPage < NUM_PAGES - 1) {
            stat_pager.currentItem = currentPage + 1
            progressIndicator.setPage(stat_pager.currentItem)
        } else {
            listener?.onStatsCompleted()
        }
    }

    fun onBackPressed() {
        if (stat_pager.currentItem == 0) {
            // If the user is currently looking at the first step, allow the system to handle the
            // Back button. This calls finish() on this activity and pops the back stack.
            listener?.onBackedOut()
        } else {
            // Otherwise, select the previous step.
            stat_pager.currentItem = stat_pager.currentItem - 1
        }
    }

    interface OnStatsCompletedListener {
        fun onStatsCompleted()
        fun onBackedOut()
    }

    /**
     * A simple pager adapter that represents 5 ScreenSlidePageFragment objects, in
     * sequence.
     */
    private inner class StatSlidePagerAdapter(fm: FragmentManager) :
        FragmentStatePagerAdapter(fm, BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT) {
        override fun getCount(): Int = NUM_PAGES

        override fun getItem(position: Int): StatSlideFragment =
            when (position) {
                0 -> StatSlideFragment().newInstance(
                    R.drawable.stat1image,
                    getString(R.string.stat_text_1),
                    0
                )
                1 -> StatSlideFragment().newInstance(
                    R.drawable.stat2image,
                    getString(R.string.stat_text_2),
                    1
                )
                2 -> StatSlideFragment().newInstance(
                    R.drawable.stat3image,
                    getString(R.string.stat_text_3),
                    2
                )
                3 -> StatSlideFragment().newInstance(
                    R.drawable.stat4image,
                    getString(R.string.stat_text_4),
                    3
                )
                else -> StatSlideFragment()
            }
    }

    companion object {
        const val NUM_PAGES = 4
    }
}