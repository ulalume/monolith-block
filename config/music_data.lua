return {
  -- シンセサイザー用 arduino USB のポート
  -- 上から 1P, 2P, 3P, 4P
  {
    "/dev/serial/by-path/platform-3f980000.usb-usb-0:1.3.1:1.0-port0",
    "/dev/serial/by-path/platform-3f980000.usb-usb-0:1.3.2:1.0-port0",
    "/dev/serial/by-path/platform-3f980000.usb-usb-0:1.3.3:1.0-port0",
    "/dev/serial/by-path/platform-3f980000.usb-usb-0:1.3.4:1.0-port0",
  },
  -- 音声データ
  {
	  death="assets/sound/death.json",
	  jump="assets/sound/jump.json",
  },
  -- priority
  -- 音が同時に鳴ったときに、数字の大きい方の音を優先
  {
	  death=2,
	  jump=1,
  }
}
