package com.mehequanna.mmiw

import android.content.Context
import android.os.Bundle
import android.transition.TransitionInflater
import android.view.HapticFeedbackConstants
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentStatePagerAdapter
import androidx.viewpager.widget.ViewPager
import com.mehequanna.mmiw.databinding.FragmentStatViewpagerBinding

class StatViewPagerFragment : Fragment() {

    private lateinit var pagerAdapter: StatSlidePagerAdapter
    private var _binding: FragmentStatViewpagerBinding? = null
    private val binding get() = _binding!!
    private var listener: OnStatsCompletedListener? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentStatViewpagerBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val inflater = TransitionInflater.from(requireContext())
        exitTransition = inflater.inflateTransition(R.transition.slide_left)
        enterTransition = inflater.inflateTransition(R.transition.slide_right)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        pagerAdapter =
            StatSlidePagerAdapter(fragmentManager ?: requireActivity().supportFragmentManager)
        binding.statPager.adapter = pagerAdapter
        binding.statPager.currentItem = 0
        binding.statPager.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {

            override fun onPageScrollStateChanged(state: Int) {
            }

            override fun onPageScrolled(
                position: Int,
                positionOffset: Float,
                positionOffsetPixels: Int
            ) {

            }

            override fun onPageSelected(position: Int) {
                binding.progressIndicator.setPage(position)
            }

        })
        binding.progressIndicator.setPage(binding.statPager.currentItem)
        binding.nextButton.setOnClickListener {
            it.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            onNextPressed()
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        listener = context as? OnStatsCompletedListener
        if (listener == null) {
            throw ClassCastException("$context must implement OnStatsCompletedListener")
        }
    }

    private fun onNextPressed() {
        val currentPage = binding.statPager.currentItem
        if (currentPage < NUM_PAGES - 1) {
            binding.statPager.currentItem = currentPage + 1
            binding.progressIndicator.setPage(binding.statPager.currentItem)
        } else {
            listener?.onStatsCompleted()
        }
    }

    fun onBackPressed() {
        if (binding.statPager.currentItem == 0) {
            // If the user is currently looking at the first step, allow the system to handle the
            // Back button. This calls finish() on this activity and pops the back stack.
            listener?.onBackedOut()
        } else {
            // Otherwise, select the previous step.
            binding.statPager.currentItem = binding.statPager.currentItem - 1
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
