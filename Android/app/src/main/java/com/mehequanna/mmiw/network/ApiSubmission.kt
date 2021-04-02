package com.mehequanna.mmiw.network

import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.http.Multipart
import retrofit2.http.POST
import retrofit2.http.Part

interface ApiSubmission {
    @Multipart
    @POST("/submissions")
    fun submitInfo(
        @Part("name") name: RequestBody,
        @Part("email") email: RequestBody,
        @Part("image\"; filename=\"mmiw_photo.png\" ") file: RequestBody?
    ): Call<Submission>
}
