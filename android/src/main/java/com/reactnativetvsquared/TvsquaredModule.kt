package com.reactnativetvsquared

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

import com.reactnativetvsquared.TVSquaredCollector;

class TvsquaredModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    private lateinit var traker: TVSquaredCollector;

    override fun getName(): String {
        return "Tvsquared"
    }

    @ReactMethod
    fun initialize(hostname: String, clientKey: String) {
      traker = TVSquaredCollector(currentActivity, hostname, clientKey, true);
    }

    @ReactMethod
    fun trackUser(userId: String) {
      this.ensureTracker();
      traker.setUserId(userId);
      traker.track();
    }

    @ReactMethod
    fun track() {
      this.ensureTracker();
      traker.track();
    }

    @ReactMethod
    fun trackAction(actionName: String, product: String?, actionId: String?, revenue: Float, promoCode: String?) {
      this.ensureTracker();
      traker.setUserId(traker.getUserId());
      traker.track(actionName, product, actionId, revenue, product);
    }

    private fun ensureTracker() {
      if (traker == null) {
        return;
      }
    }

}
