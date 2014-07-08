# Edit these values to point to the right Lua
LUA ?= /usr/local/brew/Cellar/lua/5.1.5
LUA_LIB ?= ${LUA}/lib
LUA_INC ?= ${LUA}/include
LUA_MINOR ?= 1# 1 = Lua 5.1
LUAROCKS_VERSION ?= 2.1.2
# Stop editing

LUAROCKS_PREFIX := $(shell pwd)/locallua
LUA_MODULE_PATH := ${LUAROCKS_PREFIX}/lib/lua/5.${LUA_MINOR}
LUA_SHARE_PATH := ${LUAROCKS_PREFIX}/share/lua/5.${LUA_MINOR}

all: ${LUA_MODULE_PATH}/sluift.so ${LUA_MODULE_PATH}/socket ${LUA_SHARE_PATH}/json ${LUA_SHARE_PATH}/ssl

locallua/lib:
	mkdir -p locallua/lib

deps/swift:
	mkdir -p deps
	cd deps;git clone git://swift.im/swift

deps/swift/config.py: deps/swift
	echo "# Please populate this file correctly for your system\nlua_libdir='${LUA_LIB}'\nlua_includedir='${LUA_INC}'" > deps/swift/config.py
	vim deps/swift/config.py

deps/swift/Sluift/dll/sluift.so: deps/swift | deps/swift/config.py
	cd deps/swift;scons Sluift

${LUA_MODULE_PATH}/sluift.so: deps/swift/Sluift/dll/sluift.so
	mkdir -p ${LUA_MODULE_PATH}
	cp deps/swift/Sluift/dll/sluift.so ${LUA_MODULE_PATH}/

deps/luarocks-${LUAROCKS_VERSION}.tar.gz:
	mkdir -p deps
	cd deps;wget http://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz

deps/luarocks-${LUAROCKS_VERSION}: deps/luarocks-${LUAROCKS_VERSION}.tar.gz
	cd deps;tar xf luarocks-${LUAROCKS_VERSION}.tar.gz

locallua/bin/luarocks: deps/luarocks-${LUAROCKS_VERSION}
	echo "Installing luarocks into ${LUAROCKS_PREFIX}"
	mkdir -p locallua/bin
	mkdir -p locallua/lib
	cd deps/luarocks-${LUAROCKS_VERSION}; ./configure --prefix=${LUAROCKS_PREFIX} --with-lua=${LUA}
	cd deps/luarocks-${LUAROCKS_VERSION}; make
	cd deps/luarocks-${LUAROCKS_VERSION}; make build
	cd deps/luarocks-${LUAROCKS_VERSION}; make install

${LUA_MODULE_PATH}/socket: locallua/bin/luarocks
	echo "Missing luasockets from ${LUA_MODULE_PATH}/socket, installing"
	locallua/bin/luarocks install luasocket

${LUA_SHARE_PATH}/json: locallua/bin/luarocks
	locallua/bin/luarocks install luajson

${LUA_SHARE_PATH}/ssl: locallua/bin/luarocks
	locallua/bin/luarocks install luasec
