package com.mehequanna.mmiw.widgets

import android.content.Context
import android.util.AttributeSet
import android.widget.ImageView
import androidx.constraintlayout.widget.ConstraintLayout
import com.mehequanna.mmiw.R

class StatIndicatorViewGroup(context: Context, attrs: AttributeSet) :
    ConstraintLayout(context, attrs) {

    private val indicator1: ImageView
    private val indicator2: ImageView
    private val indicator3: ImageView
    private val indicator4: ImageView

    init {
        inflate(context, R.layout.stat_indicator_group, this)
        indicator1 = findViewById(R.id.indicator1)
        indicator2 = findViewById(R.id.indicator2)
        indicator3 = findViewById(R.id.indicator3)
        indicator4 = findViewById(R.id.indicator4)
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
