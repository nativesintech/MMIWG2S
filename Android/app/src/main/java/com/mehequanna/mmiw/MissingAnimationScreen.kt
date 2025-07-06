package com.mehequanna.mmiw

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/**
 * A Compose screen that displays the word "Missing" with a black background.
 * The text starts off-screen and slides to the top of the screen.
 */
@Composable
fun MissingAnimationScreen() {
    // Create a non-repeating animation
    val animationSpec = tween<Float>(
        durationMillis = 3000,
        easing = EaseOutQuad
    )

    val verticalOffset by animateFloatAsState(
        targetValue = 80f, // End position at top of screen
        animationSpec = animationSpec,
        label = "verticalAnimation"
    )

    // Create the main container with black background
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Black),
        contentAlignment = Alignment.Center
    ) {
        // The "Missing" text that animates from bottom to top
        Text(
            text = "Missing",
            color = Color.White,
            fontSize = 48.sp,
            fontWeight = FontWeight.Bold,
            textAlign = TextAlign.Left,
            modifier = Modifier
                .padding(start = 16.dp, end = 16.dp)
                .align(Alignment.TopStart)
                .padding(top = if (verticalOffset == 80f) verticalOffset.dp else 1200.dp)
        )
    }
}

@Preview(showBackground = true)
@Composable
fun MissingAnimationScreenPreview() {
    MissingAnimationScreen()
}
