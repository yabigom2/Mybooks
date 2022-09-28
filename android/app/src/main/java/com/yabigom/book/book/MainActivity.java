package com.yabigom.book.book;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import java.io.Serializable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.yabigom.book.book/userInfo";

    public static final String EXTRA_ACTIVITY_INFO = "EXTRA_ACTIVITY_INFO";

    private String userName = null;

    public static class ArgInfo implements Serializable {
        public String userName;               // 사용자 이름
    }

    public static void start(Activity activity, ArgInfo argInfo) {
        Intent intent = new Intent(activity, MainActivity.class);
        intent.putExtra(EXTRA_ACTIVITY_INFO, argInfo);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ArgInfo argInfo = (ArgInfo) getIntent().getSerializableExtra(EXTRA_ACTIVITY_INFO);
        if (argInfo != null) {
            userName = argInfo.userName;
        }
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        final MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL);
        channel.setMethodCallHandler(handler);
    }

    private MethodChannel.MethodCallHandler handler = (methodCall, result) -> {
        if (methodCall.method.equals("getUserInfo")) {
            result.success(getUserName());
        } else {
            result.notImplemented();
        }
    };

    private String getUserName() {
        Log.i("yabigom", "getUserName() : " + userName);
        return userName;
    }
}
