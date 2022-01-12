package com.analogio.coffeecard

import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import dk.mobilepay.sdk.Country
import dk.mobilepay.sdk.MobilePay
import dk.mobilepay.sdk.ResultCallback
import dk.mobilepay.sdk.model.FailureResult
import dk.mobilepay.sdk.model.Payment
import dk.mobilepay.sdk.model.SuccessResult
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.math.BigDecimal

class MainActivity: FlutterActivity() {
    private val CHANNEL = "analog.mobilepay"
    val MOBILEPAY_PAYMENT_REQUEST_CODE = 1337


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MobilePay.getInstance().init("APPDK0000000000", Country.DENMARK)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when(call.method) {
                "openMobilepay" -> {
                    // Check if the MobilePay app is installed on the device.
                    val isMobilePayInstalled = MobilePay.getInstance().isMobilePayInstalled(
                            applicationContext
                    )

                    if (isMobilePayInstalled) {
                        //FIXME: potentially unsafe, handle case where its not given
                        val price = call.argument<Double>("price")!!
                        val orderId = call.argument<String>("orderId")!!

                        // MobilePay is present on the system. Create a Payment object.
                        val payment = Payment()

                        payment.productPrice = BigDecimal.valueOf(price)
                        payment.orderId = orderId

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
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == MOBILEPAY_PAYMENT_REQUEST_CODE) {
            val channel = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL)

            // The request code matches our MobilePay Intent
            MobilePay.getInstance().handleResult(resultCode, data, object: ResultCallback {
                override fun onSuccess(result: SuccessResult?) {
                    // The payment succeeded - you can deliver the product.
                    channel.invokeMethod("onSuccess", "")
                }

                override fun onFailure(result: FailureResult?) {
                    // The payment failed - show an appropriate error message to the user. Consult the MobilePay class documentation for possible error codes.
                    channel.invokeMethod("onFailure", "")
                }

                override fun onCancel(orderId: String?) {
                    // The payment was cancelled.
                    channel.invokeMethod("onCancel", "")
                }
            })
        }
    }


}