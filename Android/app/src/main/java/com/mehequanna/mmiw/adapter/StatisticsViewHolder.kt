package com.mehequanna.mmiw.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mehequanna.mmiw.databinding.StatisticsItemBinding

class StatisticsViewHolder private constructor(private val binding: StatisticsItemBinding) : RecyclerView.ViewHolder(binding.root) {
    constructor(parent: ViewGroup) :
            this(StatisticsItemBinding.inflate(LayoutInflater.from(parent.context), parent, false))

    fun bind(boxText: String) {
        binding.statisticsTextView.text = boxText
    }
}
