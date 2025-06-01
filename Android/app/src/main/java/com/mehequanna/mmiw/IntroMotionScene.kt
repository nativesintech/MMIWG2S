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
          "m_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["parent", "bottom"],
            "alpha": 0,
            "translationX": -120
          },
          "issing_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text", "end"],
            "top": ["m_text", "top"],
            "bottom": ["m_text", "bottom"],
            "alpha": 0,
            "translationX": 120
          },
          "m_text_2": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["m_text", "bottom", 36],
            "alpha": 0,
            "translationX": -120
          },
          "urdered_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text_2", "end"],
            "top": ["m_text_2", "top"],
            "bottom": ["m_text_2", "bottom"],
            "alpha": 0,
            "translationX": 120
          },
          "i_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["m_text_2", "bottom", 36],
            "alpha": 0,
            "translationX": -120
          },
          "ndigenous_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["i_text", "end"],
            "top": ["i_text", "top"],
            "bottom": ["i_text", "bottom"],
            "alpha": 0,
            "translationX": 120
          },
          "w_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["i_text", "bottom", 36],
            "alpha": 0,
            "translationX": -120
          },
          "omen_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["w_text", "end"],
            "top": ["w_text", "top"],
            "bottom": ["w_text", "bottom"],
            "alpha": 0,
            "translationX": 120
          }
        },
        "animation_first": {
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
          "m_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["parent", "top", 48],
            "alpha": 1,
            "translationX": 0
          },
          "issing_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text", "end"],
            "top": ["m_text", "top"],
            "bottom": ["m_text", "bottom"],
            "alpha": 1,
            "translationX": 0
          },
          "m_text_2": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["m_text", "bottom", 36],
            "alpha": 0,
            "translationX": -120
          },
          "urdered_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text_2", "end"],
            "top": ["m_text_2", "top"],
            "bottom": ["m_text_2", "bottom"],
            "alpha": 0,
            "translationX": 120
          },
          "i_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["m_text_2", "bottom", 36],
            "alpha": 0,
            "translationX": -120
          },
          "ndigenous_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["i_text", "end"],
            "top": ["i_text", "top"],
            "bottom": ["i_text", "bottom"],
            "alpha": 0,
            "translationX": 120
          },
          "w_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["i_text", "bottom", 36],
            "alpha": 0,
            "translationX": -120
          },
          "omen_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["w_text", "end"],
            "top": ["w_text", "top"],
            "bottom": ["w_text", "bottom"],
            "alpha": 0,
            "translationX": 120
          }
        },
        "animation_second": {
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
            "start": ["parent", "start"],
            "end": ["m_text", "start"],
            "alpha": 1
          },
          "m_text": {
            "width": "wrap",
            "height": "wrap",
            "top": ["parent", "top", 48],
            "start": ["hashtag", "end"],
            "alpha": 1,
            "translationX": 0
          },
          "issing_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text", "end"],
            "top": ["m_text", "top"],
            "bottom": ["m_text", "bottom"],
            "alpha": 1,
            "translationX": 0
          },
          "m_text_2": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["m_text", "bottom", 36],
            "alpha": 1,
            "translationX": 0
          },
          "urdered_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text_2", "end"],
            "top": ["m_text_2", "top"],
            "bottom": ["m_text_2", "bottom"],
            "alpha": 1,
            "translationX": 0
          },
          "i_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["m_text_2", "bottom", 36],
            "alpha": 0,
            "translationX": -120
          },
          "ndigenous_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["i_text", "end"],
            "top": ["i_text", "top"],
            "bottom": ["i_text", "bottom"],
            "alpha": 0,
            "translationX": 120
          },
          "w_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["parent", "start", 36],
            "top": ["i_text", "bottom", 36],
            "alpha": 0,
            "translationX": -120
          },
          "omen_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["w_text", "end"],
            "top": ["w_text", "top"],
            "bottom": ["w_text", "bottom"],
            "alpha": 0,
            "translationX": 120
          }
        },
        "animation_third": {
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
            "top": ["parent", "top", 32],
            "start": ["parent", "start"],
            "end": ["m_text", "start"],
            "horizontalChainStyle": "packed",
            "alpha": 1
          },
          "m_text": {
            "width": "wrap",
            "height": "wrap",
            "baseline": ["hashtag", "baseline"],
            "start": ["hashtag", "end"],
            "end": ["m_text_2", "start"],
            "alpha": 1,
            "translationX": 0
          },
          "issing_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text", "end"],
            "top": ["m_text", "top"],
            "bottom": ["m_text", "bottom"],
            "alpha": 0,
            "translationX": 0
          },
          "m_text_2": {
            "width": "wrap",
            "height": "wrap",
            "baseline": ["m_text", "baseline"],
            "start": ["m_text", "end"],
            "end": ["i_text", "start"],
            "alpha": 1,
            "translationX": 0
          },
          "urdered_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["m_text_2", "end"],
            "top": ["m_text_2", "top"],
            "bottom": ["m_text_2", "bottom"],
            "alpha": 0,
            "translationX": 0
          },
          "i_text": {
            "width": "wrap",
            "height": "wrap",
            "baseline": ["m_text_2", "baseline"],
            "start": ["m_text_2", "end"],
            "end": ["w_text", "start"],
            "alpha": 1,
            "translationX": 0
          },
          "ndigenous_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["i_text", "end"],
            "top": ["i_text", "top"],
            "bottom": ["i_text", "bottom"],
            "alpha": 0,
            "translationX": 0
          },
          "w_text": {
            "width": "wrap",
            "height": "wrap",
            "baseline": ["i_text", "baseline"],
            "start": ["i_text", "end"],
            "end": ["parent", "end"],
            "alpha": 1,
            "translationX": 0
          },
          "omen_text": {
            "width": "wrap",
            "height": "wrap",
            "start": ["w_text", "end"],
            "top": ["w_text", "top"],
            "bottom": ["w_text", "bottom"],
            "alpha": 0,
            "translationX": 0
          }
        }
      },
      "Transitions": {
        "default": {
          "from": "start",
          "to": "animation_first",
          "pathMotionArc": "startHorizontal",
          "duration": 3000,
          "interpolator": "easeInOut"
        },
        "animation_first_to_second": {
          "from": "animation_first",
          "to": "animation_second",
          "pathMotionArc": "startHorizontal",
          "duration": 3000,
          "interpolator": "easeInOut" 
        },
        "animation_second_to_third": {
          "from": "animation_second", 
          "to": "animation_third",
          "pathMotionArc": "startHorizontal",
          "duration": 2500,
          "interpolator": "easeInOut"
        }
      }
    }
    """.trimIndent()
}
