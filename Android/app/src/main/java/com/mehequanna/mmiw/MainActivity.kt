package com.mehequanna.mmiw

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity(), StatViewPagerFragment.OnStatsCompletedListener,
    TermsFragment.OnTermsAcceptedListener {

    private val fragmentManager = supportFragmentManager
    private lateinit var sharedPrefs: SharedPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sharedPrefs = getSharedPreferences(SHARED_PREFS_FILE, Context.MODE_PRIVATE)
        setContentView(R.layout.activity_main)
        launchStatsFragment()
    }

    private fun launchStatsFragment() {
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
//        if (sharedPrefs.getBoolean(PREF_TERMS_AGREED_TO, false)) {
//            openArActivity()
//        } else {
        launchRespectFragment()
//        }
    }

    override fun onBackedOut() {
        super.onBackPressed()
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
