package com.mehequanna.mmiw

/**
 * JSON representation of the intro_motion_scene.xml for use with Compose MotionLayout
 */
object IntroMotionScene {
    val composeMotionScene = """
    {
      "ConstraintSets": {
        "start": {
          "hand_watermark": {
            "width": "spread",
            "height": "wrap",
            "start": ["parent", "start"],
            "end": ["parent", "end"],
            "bottom": ["parent", "bottom"],
            "alpha": 0.3,
            "scaleX": 0.5,
            "scaleY": 0.5,
            "custom": {
              "ColorFilter": "#272727"
            }
          },
          "hashtag": {
            "width": "wrap",
            "height": "wrap",
            "top": ["parent", "top", 48],
            "end": ["parent", "start"],
            "alpha": 0
          },
          "full_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 24],
            "end": ["parent", "end", 24],
            "top": ["parent", "bottom"],
            "alpha": 0
          },
          "m_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 16],
            "end": ["parent", "end"],
            "top": ["parent", "bottom"],
            "alpha": 0
          },
          "i_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text", "end", 8],
            "top": ["m_text", "top"],
            "alpha": 0
          },
          "w_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["i_text", "end", 8],
            "top": ["m_text", "top"],
            "alpha": 0
          }
        },
        "middle": {
          "hand_watermark": {
            "width": "spread",
            "height": "wrap",
            "start": ["parent", "start"],
            "end": ["parent", "end"],
            "bottom": ["parent", "bottom"],
            "alpha": 0.5,
            "custom": {
              "ColorFilter": "#272727"
            }
          },
          "hashtag": {
            "width": "wrap",
            "height": "wrap",
            "top": ["parent", "top", 48],
            "end": ["parent", "start"],
            "alpha": 0
          },
          "full_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 24],
            "end": ["parent", "end", 24],
            "top": ["parent", "top", 300],
            "alpha": 1
          },
          "m_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 16],
            "end": ["parent", "end"],
            "top": ["parent", "bottom"],
            "alpha": 0
          },
          "i_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text", "end", 8],
            "top": ["m_text", "top"],
            "alpha": 0
          },
          "w_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["i_text", "end", 8],
            "top": ["m_text", "top"],
            "alpha": 0
          }
        },
        "end": {
          "hand_watermark": {
            "width": "spread",
            "height": "wrap",
            "start": ["parent", "start"],
            "end": ["parent", "end"],
            "bottom": ["parent", "bottom"],
            "alpha": 0.5,
            "custom": {
              "ColorFilter": "#81170E"
            }
          },
          "hashtag": {
            "width": "wrap",
            "height": "wrap",
            "top": ["parent", "top", 48],
            "start": ["parent", "start", 24],
            "alpha": 1
          },
          "full_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 24],
            "end": ["parent", "end", 24],
            "top": ["parent", "top", 48],
            "alpha": 0
          },
          "m_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["hashtag", "end", 8],
            "baseline": ["hashtag", "baseline"],
            "alpha": 1
          },
          "i_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text", "end", 8],
            "baseline": ["m_text", "baseline"],
            "alpha": 1
          },
          "w_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["i_text", "end", 8],
            "baseline": ["i_text", "baseline"],
            "alpha": 1
          }
        }
      },
      "Transitions": {
        "default": {
          "from": "start",
          "to": "middle",
          "pathMotionArc": "none",
          "duration": 3000,
          "interpolator": "easeInOut"
        },
        "morph_to_hashtag": {
          "from": "middle",
          "to": "end",
          "pathMotionArc": "startHorizontal",
          "duration": 2000,
          "interpolator": "easeInOut"
        }
      }
    }
    """.trimIndent()
}
