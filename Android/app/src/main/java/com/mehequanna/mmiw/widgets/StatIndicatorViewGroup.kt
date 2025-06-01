package com.mehequanna.mmiw.widgets

import android.content.Context
import android.util.AttributeSet
import androidx.constraintlayout.widget.ConstraintLayout
import com.mehequanna.mmiw.R
import android.view.LayoutInflater
import com.mehequanna.mmiw.databinding.StatIndicatorGroupBinding

class StatIndicatorViewGroup(context: Context, attrs: AttributeSet) :
    ConstraintLayout(context, attrs) {

    private val binding: StatIndicatorGroupBinding

    init {
        val inflater = LayoutInflater.from(context)
        binding = StatIndicatorGroupBinding.inflate(inflater, this, true)
    }

    fun setPage(pageIndex: Int) {
        when (pageIndex) {
            0 ->  {
                binding.indicator1.setImageResource(R.drawable.stat_indicator_red)
                binding.indicator2.setImageResource(R.drawable.stat_indicator_white)
                binding.indicator3.setImageResource(R.drawable.stat_indicator_white)
                binding.indicator4.setImageResource(R.drawable.stat_indicator_white)
            }
            1 -> {
                binding.indicator1.setImageResource(R.drawable.stat_indicator_white)
                binding.indicator2.setImageResource(R.drawable.stat_indicator_red)
                binding.indicator3.setImageResource(R.drawable.stat_indicator_white)
                binding.indicator4.setImageResource(R.drawable.stat_indicator_white)
            }
            2 -> {
                binding.indicator1.setImageResource(R.drawable.stat_indicator_white)
                binding.indicator2.setImageResource(R.drawable.stat_indicator_white)
                binding.indicator3.setImageResource(R.drawable.stat_indicator_red)
                binding.indicator4.setImageResource(R.drawable.stat_indicator_white)
            }
            3 -> {
                binding.indicator1.setImageResource(R.drawable.stat_indicator_white)
                binding.indicator2.setImageResource(R.drawable.stat_indicator_white)
                binding.indicator3.setImageResource(R.drawable.stat_indicator_white)
                binding.indicator4.setImageResource(R.drawable.stat_indicator_red)
            }
        }
    }
}
