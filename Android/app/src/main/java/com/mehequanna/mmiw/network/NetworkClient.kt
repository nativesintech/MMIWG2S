package com.mehequanna.mmiw.network

import okhttp3.OkHttpClient
import okhttp3.Protocol
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.*
import java.util.concurrent.TimeUnit

object NetworkClient {
    private const val BASE_URL = "https://mmiw.mehequanna.com"
    private const val TIMEOUT = 10
    var retrofit: Retrofit? = null

    /*
    This public static method will return Retrofit client
    anywhere in the application
    */
    val retrofitClient: Retrofit
        get() {
            if (retrofit == null) {
                val okHttpClientBuilder = OkHttpClient.Builder()
                okHttpClientBuilder.connectTimeout(TIMEOUT.toLong(), TimeUnit.SECONDS)
                okHttpClientBuilder.protocols(Collections.singletonList(Protocol.HTTP_1_1))
                retrofit = Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .addConverterFactory(GsonConverterFactory.create())
                    .client(okHttpClientBuilder.build())
                    .build()
            }
            return retrofit!!  // TODO Figure out if this is a good idea....
        }
}
