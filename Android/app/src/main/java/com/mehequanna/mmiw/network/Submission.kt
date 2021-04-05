package com.mehequanna.mmiw.network

import com.google.gson.annotations.Expose
import com.google.gson.annotations.SerializedName
import java.io.File

class Submission {
    @SerializedName("name")
    @Expose
    var name: String = "Something's Wrong"

    @SerializedName("email")
    @Expose
    var email: String = "somethingwentwrong@test.com"

    @SerializedName("file")
    @Expose
    var image: File? = null
}
