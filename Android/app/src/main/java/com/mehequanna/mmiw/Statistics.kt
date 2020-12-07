package com.mehequanna.mmiw

import android.content.Context

data class Statistics(val context: Context) {
    val statisticsList = listOf(
        context.getString(R.string.stat_text_1),
        context.getString(R.string.stat_text_2),
        context.getString(R.string.stat_text_3),
        context.getString(R.string.stat_text_4),
        context.getString(R.string.stat_text_5)
    )
}
