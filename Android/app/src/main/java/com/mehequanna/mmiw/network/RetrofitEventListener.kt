package com.mehequanna.mmiw.network

import retrofit2.Call

interface RetrofitEventListener {
    fun onSuccess(call: Call<*>?, response: Any?)
    fun onError(call: Call<*>?, t: Throwable?)
}
