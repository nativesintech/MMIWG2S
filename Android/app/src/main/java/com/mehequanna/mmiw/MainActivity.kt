package com.mehequanna.mmiw

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity(), StatViewPagerFragment.OnStatsCompletedListener,
    TermsFragment.OnTermsAcceptedListener, IntroFragment.OnIntroAnimationCompletedListener {

    private val fragmentManager = supportFragmentManager
    private lateinit var sharedPrefs: SharedPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sharedPrefs = getSharedPreferences(SHARED_PREFS_FILE, Context.MODE_PRIVATE)
        setContentView(R.layout.activity_main)
        launchIntroFragment()
    }

    private fun launchIntroFragment() {
        hashtag_text.visibility = View.GONE
        val introFragment = IntroFragment()
        fragmentManager
            .beginTransaction()
            .add(R.id.fragment_intro_container, introFragment)
            .addToBackStack(null)
            .commit()
    }

    private fun launchStatsFragment() {
        hashtag_text.visibility = View.VISIBLE
        val statsFragment = StatViewPagerFragment()
        fragmentManager
            .beginTransaction()
            .add(R.id.fragment_stats_container, statsFragment)
            .commit()
    }

    private fun launchRespectFragment() {
        val respectFragment = TermsFragment()
        fragmentManager
            .beginTransaction()
            .add(R.id.fragment_terms_container, respectFragment)
            .addToBackStack(null)
            .commit()
    }

    override fun onBackPressed() {
        val statsFragment = fragmentManager.findFragmentById(R.id.fragment_stats_container)
        val termsFragment = fragmentManager.findFragmentById(R.id.fragment_terms_container)
        when {
            termsFragment != null -> {
                fragmentManager.popBackStackImmediate()
            }
            statsFragment != null -> {
                (statsFragment as StatViewPagerFragment).onBackPressed()
            }
            else -> {
                super.onBackPressed()
            }
        }
    }

    private fun openArActivity() {
        startActivity(Intent(this, MmiwActivity::class.java))
    }

    override fun onStatsCompleted() {
        if (sharedPrefs.getBoolean(PREF_TERMS_AGREED_TO, false)) {
            openArActivity()
        } else {
            launchRespectFragment()
        }
    }

    override fun onBackedOut() {
        super.onBackPressed()
    }

    override fun onIntroCompleted() {
        launchStatsFragment()
    }

    override fun onTermsAccepted() {
        sharedPrefs.edit().putBoolean(PREF_TERMS_AGREED_TO, true).apply()
        openArActivity()
    }

    companion object {
        private const val SHARED_PREFS_FILE = "MMIWPrefs"
        private const val PREF_TERMS_AGREED_TO = "UserAgreedToTerms"
    }

}
