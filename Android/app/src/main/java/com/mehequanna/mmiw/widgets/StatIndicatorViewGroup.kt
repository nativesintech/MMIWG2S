package com.mehequanna.mmiw.widgets

import android.content.Context
import android.util.AttributeSet
import android.widget.ImageView
import androidx.constraintlayout.widget.ConstraintLayout
import com.mehequanna.mmiw.R

class StatIndicatorViewGroup(context: Context, attrs: AttributeSet) :
    ConstraintLayout(context, attrs) {

    var indicator1: ImageView = findViewById(R.id.indicator1)
    var indicator2: ImageView = findViewById(R.id.indicator2)
    var indicator3: ImageView = findViewById(R.id.indicator3)
    var indicator4: ImageView = findViewById(R.id.indicator4)

    init {
        inflate(context, R.layout.stat_indicator_group, this)
    }

    fun setPage(pageNum: Int) {
        when (pageNum) {
            1 -> indicator1.setImageResource(R.drawable.stat_indicator_red)
            2 -> indicator2.setImageResource(R.drawable.stat_indicator_red)
            3 -> indicator3.setImageResource(R.drawable.stat_indicator_red)
            4 -> indicator4.setImageResource(R.drawable.stat_indicator_red)
        }
    }
}