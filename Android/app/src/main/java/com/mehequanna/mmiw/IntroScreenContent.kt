package com.mehequanna.mmiw

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.layout.layoutId
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight

@Composable
fun IntroScreenContent() {
    Box(modifier = Modifier.fillMaxSize().background(Color.Black)) {
        // Hand watermark image
        Image(
            painter = painterResource(id = R.drawable.hand_watermark),
            contentDescription = null,
            modifier = Modifier
                .layoutId("hand_watermark")
                .fillMaxWidth()
                .wrapContentHeight(),
            contentScale = ContentScale.FillWidth
        )

        // Hashtag text
        Text(
            text = stringResource(id = R.string.hashtag_only),
            style = MaterialTheme.typography.h5.copy(
                color = Color.White,
                fontWeight = FontWeight.Bold
            ),
            modifier = Modifier.layoutId("hashtag")
        )

        // "Missing Murdered" text components
        Text(
            text = stringResource(id = R.string.m_only),
            style = MaterialTheme.typography.h5.copy(
                color = Color.White,
                fontWeight = FontWeight.Bold
            ),
            modifier = Modifier.layoutId("m_text")
        )

        Text(
            text = stringResource(id = R.string.issing),
            style = MaterialTheme.typography.h5.copy(
                color = Color.White,
                fontWeight = FontWeight.Bold
            ),
            modifier = Modifier.layoutId("issing_text")
        )

        Text(
            text = stringResource(id = R.string.m_only),
            style = MaterialTheme.typography.h5.copy(
                color = Color.White,
                fontWeight = FontWeight.Bold
            ),
            modifier = Modifier.layoutId("m_text_2")
        )

        Text(
            text = stringResource(id = R.string.urdered),
            style = MaterialTheme.typography.h5.copy(
                color = Color.White,
                fontWeight = FontWeight.Bold
            ),
            modifier = Modifier.layoutId("urdered_text")
        )

        // "Indigenous Women" text components
        Text(
            text = stringResource(id = R.string.i_only),
            style = MaterialTheme.typography.h5.copy(
                color = Color.White,
                fontWeight = FontWeight.Bold
            ),
            modifier = Modifier.layoutId("i_text")
        )

        Text(
            text = stringResource(id = R.string.ndigenous),
            style = MaterialTheme.typography.h5.copy(
                color = Color.White,
                fontWeight = FontWeight.Bold
            ),
            modifier = Modifier.layoutId("ndigenous_text")
        )

        Text(
            text = stringResource(id = R.string.w_only),
            style = MaterialTheme.typography.h5.copy(
                color = Color.White,
                fontWeight = FontWeight.Bold
            ),
            modifier = Modifier.layoutId("w_text")
        )

        Text(
            text = stringResource(id = R.string.omen),
            style = MaterialTheme.typography.h5.copy(
                color = Color.White,
                fontWeight = FontWeight.Bold
            ),
            modifier = Modifier.layoutId("omen_text")
        )
    }
}
