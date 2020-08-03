package com.mehequanna.mmiw

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentStatePagerAdapter
import kotlinx.android.synthetic.main.fragment_stat_viewpager.*

private const val NUM_PAGES = 4

class StatViewPagerFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_stat_viewpager, container, false)
    }

    init {
        if (fragmentManager != null) {
            pager.adapter = StatSlidePagerAdapter(fragmentManager!!)
        }
    }

//    override fun onBackPressed() {
//        if (mPager.currentItem == 0) {
//            // If the user is currently looking at the first step, allow the system to handle the
//            // Back button. This calls finish() on this activity and pops the back stack.
//            super.onBackPressed()
//        } else {
//            // Otherwise, select the previous step.
//            mPager.currentItem = mPager.currentItem - 1
//        }
//    }

    /**
     * A simple pager adapter that represents 5 ScreenSlidePageFragment objects, in
     * sequence.
     */
    private inner class StatSlidePagerAdapter(fm: FragmentManager) : FragmentStatePagerAdapter(fm) {
        override fun getCount(): Int = NUM_PAGES

        override fun getItem(position: Int): StatSlideFragment =
            when (position) {
                0 -> StatSlideFragment().newInstance(
                    R.drawable.stat1image,
                    getString(R.string.stat_text_1),
                    1
                )
                1 -> StatSlideFragment().newInstance(
                    R.drawable.stat2image,
                    getString(R.string.stat_text_2),
                    2
                )
                2 -> StatSlideFragment().newInstance(
                    R.drawable.stat3image,
                    getString(R.string.stat_text_3),
                    3
                )
                3 -> StatSlideFragment().newInstance(
                    R.drawable.stat3image,
                    getString(R.string.stat_text_4),
                    4
                )
                else -> StatSlideFragment()
            }
    }

}