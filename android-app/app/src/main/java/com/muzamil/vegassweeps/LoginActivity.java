package com.muzamil.vegassweeps;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class LoginActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        EditText username = findViewById(R.id.username);
        EditText password = findViewById(R.id.password);
        Button login = findViewById(R.id.login);

        View.OnClickListener invalid = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String user = username.getText().toString().trim();
                String pass = password.getText().toString();
                String msg = (user.length() == 0 || pass.length() == 0)
                        ? getString(R.string.error_empty)
                        : getString(R.string.error_invalid);
                new AlertDialog.Builder(LoginActivity.this)
                        .setMessage(msg)
                        .setPositiveButton("Confirm", null)
                        .show();
            }
        };

        login.setOnClickListener(invalid);
        findViewById(R.id.register).setOnClickListener(invalid);
        findViewById(R.id.forgot).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new AlertDialog.Builder(LoginActivity.this)
                        .setMessage(R.string.error_invalid)
                        .setPositiveButton("Confirm", null)
                        .show();
            }
        });
    }
}
