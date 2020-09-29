package com.mehequanna.mmiw.widgets

import android.content.Context
import android.util.AttributeSet
import androidx.constraintlayout.widget.ConstraintLayout
import com.mehequanna.mmiw.R
import kotlinx.android.synthetic.main.stat_indicator_group.view.*

class StatIndicatorViewGroup(context: Context, attrs: AttributeSet) :
    ConstraintLayout(context, attrs) {

    init {
        inflate(context, R.layout.stat_indicator_group, this)
    }

    fun setPage(pageIndex: Int) {
        when (pageIndex) {
            0 ->  {
                indicator1.setImageResource(R.drawable.stat_indicator_red)
                indicator2.setImageResource(R.drawable.stat_indicator_white)
                indicator3.setImageResource(R.drawable.stat_indicator_white)
                indicator4.setImageResource(R.drawable.stat_indicator_white)
            }
            1 -> {
                indicator1.setImageResource(R.drawable.stat_indicator_white)
                indicator2.setImageResource(R.drawable.stat_indicator_red)
                indicator3.setImageResource(R.drawable.stat_indicator_white)
                indicator4.setImageResource(R.drawable.stat_indicator_white)
            }
            2 -> {
                indicator1.setImageResource(R.drawable.stat_indicator_white)
                indicator2.setImageResource(R.drawable.stat_indicator_white)
                indicator3.setImageResource(R.drawable.stat_indicator_red)
                indicator4.setImageResource(R.drawable.stat_indicator_white)
            }
            3 -> {
                indicator1.setImageResource(R.drawable.stat_indicator_white)
                indicator2.setImageResource(R.drawable.stat_indicator_white)
                indicator3.setImageResource(R.drawable.stat_indicator_white)
                indicator4.setImageResource(R.drawable.stat_indicator_red)
            }
        }
    }

}