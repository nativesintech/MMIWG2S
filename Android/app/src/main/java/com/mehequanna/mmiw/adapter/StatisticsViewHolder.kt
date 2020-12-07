package com.mehequanna.mmiw.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mehequanna.mmiw.R
import kotlinx.android.synthetic.main.statistics_item.view.*

class StatisticsViewHolder constructor(itemView: View) : RecyclerView.ViewHolder(itemView) {
    constructor(parent: ViewGroup) :
            this(
                LayoutInflater.from(parent.context).inflate(R.layout.statistics_item, parent, false)
            )

    fun bind(boxText: String) {
        itemView.statisticsTextView.text = boxText
    }
}
