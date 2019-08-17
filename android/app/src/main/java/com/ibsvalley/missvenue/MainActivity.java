package com.ibsvalley.missvenue;

import android.os.Bundle;
import android.util.Base64;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
//    byte[] sha1 = {
//            (byte)0x11, (byte)0xE4, (byte)0x96, (byte)0xA3, (byte)0xBB,
//            0x7B, 0x23, 0x2F, 0x48, (byte)0xFA, 0x0C, (byte)0xC6,
//            (byte)0x4C, (byte)0x3B, 0x43, 0x4A, (byte)0x09, (byte)0x7A,
//            (byte)0xE0, (byte)0xAB
//    };
//    Log.e("keyhash", Base64.encodeToString(sha1, Base64.NO_WRAP));

  }
}
