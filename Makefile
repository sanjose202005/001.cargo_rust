

define EOL


endef

rustSETall:=1.38.0 1.4.4
rustSETnow:=1.38.0

rustVER:=$(shell rustc  --version |awk '{print $$2}')
ifeq (,$(rustVER))
$(info  why no rustVER ? 83819183181)
$(error why no rustVER ? 83819183181)
endif

$(info rustVER : $(rustVER))
#NDKreal:=$(shell realpath NDK)
#NDKreal:=/e/rustNDK
NDKreal:=$(shell realpath NDK.$(rustVER))
$(info NDKreal : $(NDKreal))

apiSET:=22 23 25 27 28 29
ndkARCH:=arm arm64 x86 x86_64
apiNOW?=$(firstword $(apiSET))
ndkNOW?=$(firstword $(ndkARCH))

LLVM:=NDK.$(rustVER)/$(apiNOW)_$(ndkNOW)/bin/llvm
$(info LLVM : $(LLVM))
LLVMstrip:=$(LLVM)-strip
$(info LLVM : $(LLVMstrip))


targetSETso:=\
	x86_64-linux-android      \
	x86_64-unknown-linux-gnu  \
	i686-linux-android        \
	armv7-linux-androideabi   \
	aarch64-linux-android     

targetSETbin:=\
	$(targetSETso)      \
	x86_64-unknown-linux-musl \
	i686-unknown-linux-musl   

#  https://mozilla.github.io/firefox-browser-architecture/experiments/2017-09-21-rust-on-android.html

configCargo:=$(HOME)/.cargo/config 

cargoPATH:=$(HOME)/.cargo/bin
PATH:=$(cargoPATH):$(PATH)
ANDROID_HOME:=$(HOME)/Android/Sdk
ANDROID_AVD_HOME:=$(HOME)/.android/avd
NDK_HOME:=/e/eda5101/src/android-studio-ide-193.6514223-linux/ANDROID_SDK_ROOT/Android/Sdk/ndk/21.2.6472646
NDK_HOME:=/e/eda5101/src/android-studio-ide-193.6514223-linux/ANDROID_SDK_ROOT/Android/Sdk/ndk/19.2.5345600
NDK_HOME:=/e/eda5101/Android/Sdk/ndk/19.2.5345600/
ANDROID_NDK:=$(NDK_HOME)

env01:=\
	PATH=$(PATH) \
	ANDROID_AVD_HOME=$(ANDROID_AVD_HOME) \
	ANDROID_HOME=$(ANDROID_HOME) \
	ANDROID_SDK_ROOT=$(ANDROID_HOME) \
	NDK_HOME=$(NDK_HOME)


apiCMDpy:=$(NDK_HOME)/build/tools/make_standalone_toolchain.py
apiVer01:=26
api26CMDarm64:=$(apiCMDpy)  --api $(apiVer01) --arch arm64  --install-dir NDK/$(apiVer01)_arm64
api26CMDarm:=$(apiCMDpy)    --api $(apiVer01) --arch arm    --install-dir NDK/$(apiVer01)_arm
api26CMDx86:=$(apiCMDpy)    --api $(apiVer01) --arch x86    --install-dir NDK/$(apiVer01)_x86
api26CMDx86_64:=$(apiCMDpy) --api $(apiVer01) --arch x86_64 --install-dir NDK/$(apiVer01)_x86_64


define helpText

1. https://mozilla.github.io/firefox-browser-architecture/experiments/2017-09-21-rust-on-android.html


2. install and download
* Android SDK Tools
* NDK
* CMake
* LLDB

3.
export ANDROID_HOME=$${HOME}/Android/sdk
export NDK_HOME=$${ANDROID_HOME}/ndk-bundle

4.
s1  -->> $(s1) -->> $($(s1))

c1  -->> $(c1) -->> $($(c1))
c2  -->> $(c2) -->> $($(c2))
c3  -->> $(c3) -->> $($(c3))

add  -->> $(add)
list -->> $(listCMD)

n1  -->> new01 -->> $(new01CMD)
n3  -->> new03 -->> $(new03CMD)
n5  -->> new05 -->> $(new05CMD)

b1  ->> $(b1)  -->> $($(b1))
b3  ->> $(b3)  -->> $($(b3))
b5  ->> $(b5)  -->> $($(b5))


endef
export helpText


all:
	@echo "$${helpText}"
	$(env01) echo -n
	@echo

m:
	vim Makefile

c1:=check1
$(c1):=check1_ANDROID_HOME
c1 $(c1): $(ANDROID_HOME)
	@echo
	@echo === checking... ANDROID_HOME,$(ANDROID_HOME) : begin
	[ -d $(ANDROID_HOME)/sources ]
	[ -d $(ANDROID_HOME)/platform-tools ]
	[ -d $(ANDROID_HOME)/platforms ]
	@echo === checking... ANDROID_HOME,$(ANDROID_HOME) : end
	@echo

c2:=check2
$(c2):=check2_rustupPATH
c2 $(c2):
	@echo
	@echo === checking... cargoPATH,$(cargoPATH) : begin
	[ -f $(cargoPATH)/cargo ] || (curl https://sh.rustup.rs -sSf > sh.rustup.rs)
	[ -f $(cargoPATH)/cargo ] || (bash ./sh.rustup.rs -y )
	[ -f $(cargoPATH)/cargo ] 
	[ -f $(cargoPATH)/rustup ] 
	[ -f $(HOME)/.rustup/settings.toml ]
	@echo "=== checking... cargoPATH,$(cargoPATH) : end --> ok"
	@echo

#	[ -f NDK/26_arm/AndroidVersion.txt      ] || $(api26CMDarm)
#	[ -f NDK/26_arm/AndroidVersion.txt      ] 
#	[ -f NDK/26_arm64/AndroidVersion.txt    ] || $(api26CMDarm64)
#	[ -f NDK/26_arm64/AndroidVersion.txt    ] 
#	[ -f NDK/26_x86/AndroidVersion.txt      ] || $(api26CMDx86)
#	[ -f NDK/26_x86/AndroidVersion.txt      ] 
#	[ -f NDK/26_x86_64/AndroidVersion.txt   ] || $(api26CMDx86_64)
#	[ -f NDK/26_x86_64/AndroidVersion.txt   ] 

c3:=check3
$(c3):=check3_NDKapi
c3 $(c3):
	@echo
	@echo === checking... NDKapi : begin
	$(foreach tt0,$(rustSETall),\
		$(foreach tt1,$(apiSET),$(foreach tt2,$(ndkARCH),\
		[ -f NDK.$(tt0)/$(tt1)_$(tt2)/AndroidVersion.txt ] || \
		$(apiCMDpy)  --api $(tt1) --arch $(tt2)  --install-dir NDK.$(tt0)/$(tt1)_$(tt2) $(EOL)\
		)))
	@echo === checking... NDKapi : end : ok
	@echo

define configText

[target.aarch64-linux-android]
ar = "$(NDKreal)/$(apiNOW)_arm64/bin/aarch64-linux-android-ar"
linker = "$(NDKreal)/$(apiNOW)_arm64/bin/aarch64-linux-android-clang"

[target.armv7-linux-androideabi]
ar = "$(NDKreal)/$(apiNOW)_arm/bin/arm-linux-androideabi-ar"
linker = "$(NDKreal)/$(apiNOW)_arm/bin/arm-linux-androideabi-clang"

[target.i686-linux-android]
ar = "$(NDKreal)/$(apiNOW)_x86/bin/i686-linux-android-ar"
linker = "$(NDKreal)/$(apiNOW)_x86/bin/i686-linux-android-clang"

[target.x86_64-linux-android]
ar = "$(NDKreal)/$(apiNOW)_x86_64/bin/x86_64-linux-android-ar"
linker = "$(NDKreal)/$(apiNOW)_x86_64/bin/x86_64-linux-android-clang"

[target.x86_64-unknown-linux-gnu]
ar = "/usr/bin/x86_64-linux-gnu-ar"
linker = "/usr/bin/clang"

[target.x86_64-unknown-linux-musl]
ar = "/usr/bin/x86_64-linux-gnu-ar"
linker = "/usr/bin/clang"

[target.i686-unknown-linux-musl]
ar = "/usr/bin/x86_64-linux-gnu-ar"
linker = "/usr/bin/clang"

endef
export configText

config:
	@echo
	@[ -d NDK ]
	@[ -d $(NDKreal) ]
	@$(foreach tt1,$(apiSET),make -s configX2 apiNOW=$(tt1)$(EOL))
	cp $(foreach tt1,$(apiSET),config-cargo-$(tt1).toml) $(HOME)/.cargo/
	cp config-cargo-$(apiNOW).toml    $(HOME)/.cargo/config
	@echo

configX2:
	echo "$${configText}" > config-cargo-$(apiNOW).toml

add:=add_aarch64_armv7_i686_x64_targets
add:
	@echo
	$(env01) rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android x86_64-unknown-linux-gnu x86_64-unknown-linux-musl i686-unknown-linux-musl
	find $(HOME)/.rustup/ |grep rust-std
	@echo

listCMD:=rustup target list
list:
	@echo
	$(env01) $(listCMD)
	@echo


define new01Text

[target.'cfg(target_os="android")'.dependencies]
jni = { version = "0.5", default-features = false }

[lib]
crate-type = ["dylib"]

endef
export new01Text

new01CMD:=cargo new --lib cargo01
n1:new01
new01:
	@echo
	[ -f cargo01/Cargo.toml ] || $(env01) $(new01CMD)
	[ -f cargo01/Cargo.toml ] 
	grep -q '\[lib\]' cargo01/Cargo.toml || echo "$${new01Text}" >> cargo01/Cargo.toml
	echo "$${new01Text2}" >    cargo01/src/lib.rs
	[ -d android ] || mkdir android
	[ -d android ] 
	@echo

define new01Text2

use std::os::raw::{c_char};
use std::ffi::{CString, CStr};

#[no_mangle]
pub extern fn rust_greeting(to: *const c_char) -> *mut c_char {
    let c_str = unsafe { CStr::from_ptr(to) };
    let recipient = match c_str.to_str() {
        Err(_) => "there",
        Ok(string) => string,
    };

    CString::new("Hello ".to_owned() + recipient).unwrap().into_raw()
}

/// Expose the JNI interface for android below
#[cfg(target_os="android")]
#[allow(non_snake_case)]
pub mod android {
    extern crate jni;

    use super::*;
    use self::jni::JNIEnv;
    use self::jni::objects::{JClass, JString};
    use self::jni::sys::{jstring};

    #[no_mangle]
    pub unsafe extern fn Java_com_mozilla_greetings_RustGreetings_greeting(env: JNIEnv, _: JClass, java_pattern: JString) -> jstring {
        // Our Java companion code might pass-in "world" as a string, hence the name.
        let world = rust_greeting(env.get_string(java_pattern).expect("invalid pattern string").as_ptr());
        // Retake pointer so that we can use it below and allow memory to be freed when it goes out of scope.
        let world_ptr = CString::from_raw(world);
        let output = env.new_string(world_ptr.to_str().unwrap()).expect("Couldn't create java string!");

        output.into_inner()
    }
}


endef
export new01Text2


new03CMD:=cargo new cargo03
n3:new03
new03:
	@echo
	[ -f cargo03/Cargo.toml ] || $(env01) $(new03CMD)
	[ -f cargo03/Cargo.toml ] 
	@echo

define new05Text

use std::io;
use rand::Rng;
use std::cmp::Ordering;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);
    println!("The secret number is: {}", secret_number);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin()
            .read_line(&mut guess)
            .expect("Failed to read line");

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };
        //	.expect("Please type a number!");

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                println!("You win!");
                break;
            },
        }
    }
}


endef
export new05Text

new05CMD:=cargo new cargo05_guessing_game
n5:new05
new05:
	@echo
	[ -f cargo05_guessing_game/Cargo.toml ] || $(env01) $(new05CMD)
	[ -f cargo05_guessing_game/Cargo.toml ] 
	echo "$${new05Text}" > cargo05_guessing_game/src/main.rs
	grep -q ^rand\               cargo05_guessing_game/Cargo.toml || \
		echo 'rand = "0.5.5"' >> cargo05_guessing_game/Cargo.toml
	@echo


b1:=build01
$(b1):=cargo01
b1 $(b1): $(configCargo) 
	@echo 
	@echo ===== $@ : begin
	$(foreach tt1,$(targetSETso),\
		(cd $($(b1)) && $(env01) cargo build --target $(tt1)     --release)$(EOL)\
		)
	@echo
	echo;find $($(b1))/target/ -name "*.so" |grep release/lib |sort|xargs -n 1 $(LLVMstrip)
	echo;find $($(b1))/target/ -name "*.so" |grep release/lib |sort|xargs -n 1 realpath
	@echo ===== $@ : end
	@echo 


define error03Text

error: linking with `cc` failed: exit code: 1
  |
  = note: /usr/bin/ld: cannot find -llog
          collect2: error: ld returned 1 exit status

if you see the abover line, recheck the $(HOME)/.cargo/config

endef


b3:=build03
$(b3):=cargo03
b3 $(b3): $(configCargo) 
	@echo 
	@echo ===== $@ : begin
	$(foreach tt1,$(targetSETbin),\
		(cd $($(b3)) && $(env01) cargo build --target $(tt1)     --release)$(EOL)\
		)
	@echo
	echo;find $($(b3))/target/ -name "$($(b3))" |sort|xargs -n 1 $(LLVMstrip)
	echo;find $($(b3))/target/ -name "$($(b3))" |sort|xargs -n 1 realpath
	@echo ===== $@ : end
	@echo 

b5:=build05
$(b5):=cargo05_guessing_game
b5 $(b5): $(configCargo) 
	@echo 
	@echo ===== $@ : begin
	$(foreach tt1,$(targetSETbin),\
		(cd $($(b5)) && $(env01) cargo build --target $(tt1)     --release)$(EOL)\
		)
	@echo
	echo;find $($(b5))/target/ -name "$($(b5))" |sort|xargs -n 1 $(LLVMstrip)
	echo;find $($(b5))/target/ -name "$($(b5))" |sort|xargs -n 1 realpath
	@echo ===== $@ : end
	@echo 

s1:=show_rust_info
s1 $(s1):
	$(env01) rustup show

gs:
	git status

gc:
	git commit -a 

up:
	git push -u origin master

m:
	vim Makefile
