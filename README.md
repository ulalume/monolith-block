## Requirement (Windows)
### software のインストール

#### lua
[ここ](https://sourceforge.net/projects/luabinaries/files/5.1.5/Windows%20Libraries/Dynamic/)から lua-5.1.5_Win32_dllw6_lib.zip をダウンロード。

[ここ](https://sourceforge.net/projects/luabinaries/files/5.1.5/Tools%20Executables/)から lua-5.1.5_Win32_bin.zip をダウンロード。

展開したファイルを全て C:\lua5.1 に移動。

#### luarocks
[ここ](https://luarocks.github.io/luarocks/releases/)から luarocks-3.1.3-windows-32.zip をダウンロード。

展開したファイルを全て C:\luarocks に移動。

#### 環境変数に追加
- PATH
    - C:\lua5.1
    - C:\luarocks
- LUA_INCDIR
    - C:\lua5.1\include

### love2d のライブラリをインストール
Windows PowerShell の管理者モードでできました。
```bash
cd monolith-block

# monolith

# led matrix
luarocks install https://github.com/hnd2/MONOLITH/releases/download/v0.0.1/monolith-dev-1.rockspec --tree=lua_modules --lua-dir=C:\lua5.1

# music
luarocks install https://github.com/ulalume/monolith-music/releases/download/v0.1/music-dev-1.rockspec --tree=lua_modules --lua-dir=C:\lua5.1

# graphics
luarocks install https://github.com/ulalume/monolith-graphics/releases/download/v0.1/graphics-dev-1.rockspec --tree=lua_modules --lua-dir=C:\lua5.1

# util
luarocks install https://github.com/ulalume/monolith-util/releases/download/v0.1/util-dev-1.rockspec --tree=lua_modules --lua-dir=C:\lua5.1

# 3rd party

# json
luarocks install rxi-json-lua  --tree=lua_modules --lua-dir=C:\lua5.1
```


## Requirement (Mac, Linux)

### love2d のライブラリをインストール
```bash

# monolith

# led matrix
luarocks install https://github.com/hnd2/MONOLITH/releases/download/v0.0.1/monolith-dev-1.rockspec --tree=lua_modules --lua-dir=/usr/local/opt/lua@5.1

# music
luarocks install https://github.com/ulalume/monolith-music/releases/download/v0.1/music-dev-1.rockspec --tree=lua_modules --lua-dir=/usr/local/opt/lua@5.1

# graphics
luarocks install https://github.com/ulalume/monolith-graphics/releases/download/v0.1/graphics-dev-1.rockspec --tree=lua_modules --lua-dir=/usr/local/opt/lua@5.1

# util
luarocks install https://github.com/ulalume/monolith-util/releases/download/v0.1/util-dev-1.rockspec --tree=lua_modules --lua-dir=/usr/local/opt/lua@5.1

# 3rd party

# json
luarocks install rxi-json-lua  --tree=lua_modules --lua-dir=C:\lua5.1
```
