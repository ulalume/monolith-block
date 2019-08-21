## Requirement for Windows
### software

#### lua
lua-5.1.5_Win32_dllw6_lib.zip
https://sourceforge.net/projects/luabinaries/files/5.1.5/Windows%20Libraries/Dynamic/
lua-5.1.5_Win32_bin.zip
https://sourceforge.net/projects/luabinaries/files/5.1.5/Tools%20Executables/

zip を展開したファイルを全て C:\lua5.1 に移動。

#### luarocks
luarocks-3.1.3-windows-32.zip
https://luarocks.github.io/luarocks/releases/

zip を展開したファイルを全て C:\luarocks に移動。

#### 環境変数
PATH
- C:\lua5.1
- C:\luarocks

LUA_INCDIR
- C:\lua5.1\include

### monolith libraries
```bash
# led matrix
luarocks install https://github.com/hnd2/MONOLITH/releases/download/v0.0.1/monolith-dev-1.rockspec --tree=lua_modules --lua-dir=C:\lua5.1

# music
luarocks install https://github.com/ulalume/monolith-music/releases/download/v0.1/music-dev-1.rockspec --tree=lua_modules --lua-dir=C:\lua5.1

# graphics
luarocks install https://github.com/ulalume/monolith-graphics/releases/download/v0.1/graphics-dev-1.rockspec --tree=lua_modules --lua-dir=C:\lua5.1

# util
luarocks install https://github.com/ulalume/monolith-util/releases/download/v0.1/util-dev-1.rockspec --tree=lua_modules --lua-dir=C:\lua5.1
```

### 3rd party
```bash
# json
luarocks install rxi-json-lua  --tree=lua_modules --lua-dir=C:\lua5.1

# anim8
curl https://raw.githubusercontent.com/kikito/anim8/master/anim8.lua > lua_modules/share/lua/5.1/anim8.lua
```


## Requirement

### monolith libraries
```bash
# led matrix
luarocks install https://github.com/hnd2/MONOLITH/releases/download/v0.0.1/monolith-dev-1.rockspec --tree=lua_modules --lua-dir=/usr/local/opt/lua@5.1

# music
luarocks install https://github.com/ulalume/monolith-music/releases/download/v0.1/music-dev-1.rockspec --tree=lua_modules --lua-dir=/usr/local/opt/lua@5.1

# graphics
luarocks install https://github.com/ulalume/monolith-graphics/releases/download/v0.1/graphics-dev-1.rockspec --tree=lua_modules --lua-dir=/usr/local/opt/lua@5.1

# util
luarocks install https://github.com/ulalume/monolith-util/releases/download/v0.1/util-dev-1.rockspec --tree=lua_modules --lua-dir=/usr/local/opt/lua@5.1
```

### 3rd party
```bash
# json
luarocks install rxi-json-lua  --tree=lua_modules --lua-dir=/usr/local/opt/lua@5.1

# anim8
curl https://raw.githubusercontent.com/kikito/anim8/master/anim8.lua > lua_modules/share/lua/5.1/anim8.lua
```
