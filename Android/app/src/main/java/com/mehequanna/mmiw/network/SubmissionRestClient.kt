package com.mehequanna.mmiw.network

import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File

class SubmissionRestClient {
    companion object {
        val instance = SubmissionRestClient()
    }

    private var apiSubmission: ApiSubmission? = null

    /**
     * Invoke getUserList via [Call] request.
     * @param retrofitEventListener of RetrofitEventListener.
     */
    fun submitUserInfo(submission: Submission, retrofitEventListener: RetrofitEventListener) {
        val retrofit = NetworkClient.retrofitClient
        apiSubmission = retrofit.create<ApiSubmission>(ApiSubmission::class.java)

        val fileRequestBody = submission.image?.asRequestBody("image/png".toMediaType())
        val email: RequestBody = submission.email.toRequestBody("text/plain".toMediaType())
        val name: RequestBody = submission.name.toRequestBody("text/plain".toMediaType())

        apiSubmission?.submitInfo(name, email, fileRequestBody)?.enqueue(object : Callback<Submission> {
            override fun onResponse(call: Call<Submission>, response: Response<Submission>) {
                // This is the success callback. Though the response type is JSON, with Retrofit we get the response in the form of Response POJO class
                if (response.body() != null) {
                    retrofitEventListener.onSuccess(call, response.body())
                }
            }

            override fun onFailure(call: Call<Submission>, throwable: Throwable) {
                // Error callback
                retrofitEventListener.onError(call, throwable)
            }
        })
    }
}
