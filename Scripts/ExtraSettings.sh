#!/bin/bash

#Use kernel 6.1
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=6.1/' target/linux/x86/Makefile

#Use kernel 5.10
#sed -i 's/KERNEL_PATCHVER:=5.4/KERNEL_PATCHVER:=5.10/' target/linux/ramips/Makefile

# Modify default theme
sed -i 's/bootstrap/argon/' feeds/luci/modules/luci-base/root/etc/config/luci
sed -i 's/bootstrap/argon/' feeds/luci/collections/luci/Makefile
sed -i 's/bootstrap/argon/' feeds/luci/collections/luci-light/Makefile


##Openwrt-Passwall
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages

rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/Openwrt-Passwall/openwrt-passwall package/passwall-luci
##End of Openwrt-Passwall

##golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang -b 1.27 feeds/packages/lang/golang
## End of golang

##dae/honk
rm -rf feeds/luci/applications/luci-app-dae
rm -rf feeds/luci/applications/luci-app-honk
rm -rf feeds/packages/net/dae
rm -rf feeds/packages/net/honk
git clone https://github.com/daeuniverse/openwrt-packages package/dae-packages
git clone --recurse-submodules https://github.com/daeuniverse/dae package/dae-packages/dae/src
git clone --recurse-submodules https://github.com/daeuniverse/honk package/dae-packages/honk/src
# Prepare host Rust from the checked-out honk source requirements.
# Isolate strict error handling and upstream pins from the rest of this script.
(
  set -euo pipefail
  src="$(realpath package/dae-packages/honk/src)"
  # The pinned bpf-linker checksum describes the x86_64 Linux host asset.
  [[ "$(uname -s)" == Linux && "$(uname -m)" == x86_64 ]] || {
    echo 'This script requires an x86_64 Linux build host' >&2; exit 1;
  }
  # Install every Rust userspace target declared by the OpenWrt honk recipe.
  # Several OpenWrt CPU variants can share the same Rust target.
  target_text="$(python3 - package/dae-packages/honk/build.sh <<'PY_TARGETS'
import pathlib, re, sys
text = pathlib.Path(sys.argv[1]).read_text()
section = re.search(r'case[^\n]*HONK_ARCH_PACKAGES[^\n]*\bin\s*\n(.*?)\besac\b', text, re.S)
if section is None:
    sys.exit("Cannot locate the honk architecture mapping in build.sh")
targets = sorted(set(re.findall(r"\btarget\s*=\s*[\"']?([A-Za-z0-9_]+(?:-[A-Za-z0-9_.]+){2,})", section.group(1))))
if not targets:
    sys.exit("No literal Rust targets found; review the upstream honk architecture mapping")
print("\n".join(targets))
PY_TARGETS
  )"
  mapfile -t targets <<< "$target_text"
  printf 'Preparing honk Rust target: %s\n' "${targets[@]}"
  # Must run as the same ordinary user that runs OpenWrt make.
  export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
  export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"
  export PATH="$CARGO_HOME/bin:$PATH"
  if ! command -v rustup >/dev/null 2>&1; then
    installer="$(mktemp)"
    curl --proto '=https' --tlsv1.2 -fLsS --retry 3 https://sh.rustup.rs -o "$installer"
    sh "$installer" -y --profile minimal --default-toolchain none --no-modify-path
    rm -f "$installer"
  fi
  stable="$(python3 -c 'import sys,tomllib;print(tomllib.load(open(sys.argv[1],"rb"))["toolchain"]["channel"])' "$src/rust-toolchain.toml")"
  nightly="$(python3 -c 'import sys,tomllib;print(tomllib.load(open(sys.argv[1],"rb"))["toolchain"]["channel"])' "$src/crates/honk-ebpf/rust-toolchain.toml")"
  rustup toolchain install "$stable" --profile minimal --component rustfmt,clippy
  rustup target add --toolchain "$stable" "${targets[@]}"
  rustup toolchain install "$nightly" --profile minimal --component rust-src,llvm-tools
  # Same trusted pins file and same host binary as the upstream package workflow.
  source "$src/.github/ci/pins.env"
  archive="$(mktemp --suffix=.tar.zst)"
  curl -fLsS --retry 3 -o "$archive" \
    "https://github.com/aya-rs/bpf-linker/releases/download/v${BPF_LINKER_VERSION}/bpf-linker-x86_64-unknown-linux-musl.tar.zst"
  printf '%s  %s\n' "$BPF_LINKER_SHA256" "$archive" | sha256sum -c -
  mkdir -p "$CARGO_HOME/bin"
  tar --zstd -xf "$archive" -C "$CARGO_HOME/bin"
  rm -f "$archive"
  (cd "$src"; cargo --version; rustc --version; bpf-linker --version)
  rustup target list --installed --toolchain "$stable"
  # GitHub Actions starts a new shell for every step.
  if [[ -n "${GITHUB_ENV:-}" && -n "${GITHUB_PATH:-}" ]]; then
    printf 'CARGO_HOME=%s\nRUSTUP_HOME=%s\n' "$CARGO_HOME" "$RUSTUP_HOME" >> "$GITHUB_ENV"
    printf '%s\n' "$CARGO_HOME/bin" >> "$GITHUB_PATH"
  fi
)
honk_rust_status=$?
if [ "$honk_rust_status" -ne 0 ]; then
  echo "honk Rust environment preparation failed" >&2
  exit "$honk_rust_status"
fi

##End of dae/honk

##Add x550 2.5G
git clone https://github.com/shenlijun/openwrt-x550-nbase-t package/openwrt-x550-nbase-t  

##packages from the master branch
wget https://github.com/immortalwrt/packages/archive/refs/heads/master.tar.gz

#Rust
#tar -xzf master.tar.gz -C feeds/packages/lang/ --strip=2 "packages-master/lang/rust"
#sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile

#Xray
#tar -xzf master.tar.gz -C feeds/packages/net/ --strip=2 "packages-master/net/xray-core"
#rm -rf ./feeds/packages/lang/golang
#tar -xzf master.tar.gz -C feeds/packages/lang/ --strip=2 "packages-master/lang/golang"
#sed -i 's/^PKG_VERSION.*/PKG_VERSION:=26.3.27/' feeds/packages/net/xray-core/Makefile
#sed -i 's/^PKG_HASH.*/PKG_HASH:=992a4997e6bb846d11469435d687f99ef812fcde1e0a009bb8e95189ea20331d/' feeds/packages/net/xray-core/Makefile

#OpenVPN
#rm -rf ./feeds/packages/net/openvpn
#tar -xzf master.tar.gz -C feeds/packages/net/ --strip=2 "packages-master/net/openvpn"

rm master.tar.gz
##End of packages from the master branch

##kernel from the master branch
#wget https://github.com/immortalwrt/immortalwrt/archive/refs/heads/master.tar.gz
#rm -rf target
#tar -xzf master.tar.gz -C ./ --strip=1 "immortalwrt-master/target"
#rm master.tar.gz
##End of kernel from the master branch

#mkdir -p staging_dir/host/bin
#ln -sf /usr/bin/go staging_dir/host/bin/go
#ln -sf /usr/bin/gofmt staging_dir/host/bin/gofmt
