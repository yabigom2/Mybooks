package com.yabigom.book.book;

import com.yabigom.book.book.R;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class IntroActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        findViewById(R.id.sw_layout).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MainActivity.ArgInfo argInfo = new MainActivity.ArgInfo();
                argInfo.userName = "시원";
                MainActivity.start(IntroActivity.this, argInfo);
            }
        });

        findViewById(R.id.sh_layout).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MainActivity.ArgInfo argInfo = new MainActivity.ArgInfo();
                argInfo.userName = "시혁";
                MainActivity.start(IntroActivity.this, argInfo);
            }
        });
    }
}
