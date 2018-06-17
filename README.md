# NeTV2 Quickstart

These instructions can be used to quickly start devleopment.

1. Check out this repo with `git clone --recursive [path]`.
1. Ensure you have Python 3.5 or newer installed.
1. Download the Risc-V toolchain from https://www.sifive.com/products/tools/ and put it in your PATH.
1. Go to https://www.xilinx.com/support/download.html and download `All OS installer Single-File Download`
1. Do a minimal Xilinx install to /opt/Xilinx/, and untick everything except `Design Tools / Vivado Design Suite / Vivado` and `Devices / Production Devices / 7 Series`
1. Go to https://www.xilinx.com/member/forms/license-form.html, get a license, and place it in ~/.Xilinx/Xilinx.lic
1. Run `./build.py`
