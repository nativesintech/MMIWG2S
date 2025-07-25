package com.mehequanna.mmiw

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.mehequanna.mmiw.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity(), StatViewPagerFragment.OnStatsCompletedListener,
    TermsFragment.OnTermsAcceptedListener, IntroFragment.OnIntroAnimationCompletedListener {

    private val fragmentManager = supportFragmentManager
    private lateinit var sharedPrefs: SharedPreferences
    private var _binding: ActivityMainBinding? = null
    private val binding get() = _binding!!

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sharedPrefs = getSharedPreferences(SHARED_PREFS_FILE, Context.MODE_PRIVATE)
        _binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        launchIntroFragment()
    }

    private fun launchIntroFragment() {
        binding.hashtagText.visibility = View.GONE
        val introFragment = IntroFragment()
        fragmentManager
            .beginTransaction()
            .add(R.id.introFragmentContainer, introFragment)
            .addToBackStack(null)
            .commit()
    }

    private fun launchStatsFragment() {
        binding.hashtagText.visibility = View.VISIBLE
        val statsFragment = StatViewPagerFragment()
        fragmentManager
            .beginTransaction()
            .add(R.id.statsFragmentContainer, statsFragment)
            .commit()
    }

    private fun launchRespectFragment() {
        val respectFragment = TermsFragment()
        fragmentManager
            .beginTransaction()
            .add(R.id.termsFragmentContainer, respectFragment)
            .commit()
    }

    override fun onBackPressed() {
        val statsFragment = fragmentManager.findFragmentById(R.id.statsFragmentContainer)
        val termsFragment = fragmentManager.findFragmentById(R.id.termsFragmentContainer)
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
        startActivity(
            Intent(
                this,
                MmiwActivity::class.java
            ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
        )
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

    override fun onDestroy() {
        super.onDestroy()
        _binding = null
    }

    companion object {
        private const val SHARED_PREFS_FILE = "MMIWPrefs"
        private const val PREF_TERMS_AGREED_TO = "UserAgreedToTerms"
    }

}
