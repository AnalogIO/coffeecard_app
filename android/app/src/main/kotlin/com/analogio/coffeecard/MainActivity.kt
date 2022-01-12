package com.analogio.coffeecard

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Bundle
import android.os.PersistableBundle

import dk.mobilepay.sdk.Country
import dk.mobilepay.sdk.MobilePay
import dk.mobilepay.sdk.ResultCallback
import dk.mobilepay.sdk.model.FailureResult
import dk.mobilepay.sdk.model.Payment
import dk.mobilepay.sdk.model.SuccessResult
import java.math.BigDecimal


class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev"
    val MOBILEPAY_PAYMENT_REQUEST_CODE = 1337

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MobilePay.getInstance().init("APPDK0000000000", Country.DENMARK)

    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "foo") {
                // Check if the MobilePay app is installed on the device.
                val isMobilePayInstalled = MobilePay.getInstance().isMobilePayInstalled(
                    applicationContext
                )

                if (isMobilePayInstalled) {
                    // MobilePay is present on the system. Create a Payment object.
                    val payment = Payment()
                    payment.setProductPrice(BigDecimal.valueOf(10.0))
                    payment.setOrderId("86715c57-8840-4a6f-af5f-07ee89107ece")

                    // Create a payment Intent using the Payment object from above.
                    val paymentIntent = MobilePay.getInstance().createPaymentIntent(payment)

                    // We now jump to MobilePay to complete the transaction. Start MobilePay and wait for the result using an unique result code of your choice.
                    startActivityForResult(paymentIntent, MOBILEPAY_PAYMENT_REQUEST_CODE)
                } else {
                    // MobilePay is not installed. Use the SDK to create an Intent to take the user to Google Play and download MobilePay.
                    val intent = MobilePay.getInstance().createDownloadMobilePayIntent(
                        applicationContext
                    )
                    startActivity(intent)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == MOBILEPAY_PAYMENT_REQUEST_CODE) {
            // The request code matches our MobilePay Intent
            MobilePay.getInstance().handleResult(resultCode, data, object: ResultCallback {
                override fun onSuccess(result: SuccessResult?) {
                    // The payment succeeded - you can deliver the product.
                }

                override fun onFailure(result: FailureResult?) {
                    // The payment failed - show an appropriate error message to the user. Consult the MobilePay class documentation for possible error codes.
                }

                override fun onCancel(orderId: String?) {
                    // The payment was cancelled.
                }
            })
        }
    }


}