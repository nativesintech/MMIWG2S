package com.mehequanna.mmiw.adapter

import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView

class StatisticsAdapter : RecyclerView.Adapter<StatisticsViewHolder>() {
    var list: List<String> = listOf()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): StatisticsViewHolder =
        StatisticsViewHolder(parent)

    override fun onBindViewHolder(holder: StatisticsViewHolder, position: Int) {
        holder.bind(list[position])
    }

    fun setStatisticsAdapterData(list: List<String>) {
        this.list = list
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int = list.size

    fun getCurrentItemText(position: Int): String = list[position]
}
