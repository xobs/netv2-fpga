# NeTV2 Quickstart

These instructions can be used to quickly start devleopment.

1. Check out this repo with `git clone --recursive [path]`.
1. Ensure you have Python 3.5 or newer installed.
1. Ensure you have `make` installed.
1. Download the Risc-V toolchain from https://www.sifive.com/products/tools/ and put it in your PATH.
1. Go to https://www.xilinx.com/support/download.html and download `All OS installer Single-File Download`
1. Do a minimal Xilinx install to /opt/Xilinx/, and untick everything except `Design Tools / Vivado Design Suite / Vivado` and `Devices / Production Devices / 7 Series`
1. Go to https://www.xilinx.com/member/forms/license-form.html, get a license, and place it in ~/.Xilinx/Xilinx.lic
1. Run `./build.py`

There is a wrapper script in this repo to run litex_server and litex_term as well.  These may be invoked either with python (`python litex_server udp`) or on Unix-type systems they may be executed directly (`./litex_server udp`).

On Windows, you must ensure `vivado.bat` is in your PATH.  If you're running 2018.1, this can be done as follows:

cmd.exe:
````bat
C:\>PATH=%PATH%;C:\Xilinx\Vivado\2018.1\bin
````

powershell:
````powershell
[6:33:42 PM] ~> $env:Path += ";C:\Xilinx\Vivado\2018.1\bin"
````