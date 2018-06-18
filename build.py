#!/usr/bin/env python3

# This script enables easy, cross-platform building

import sys
import os
import subprocess

if sys.version_info[:3] < (3, 5):
    raise SystemExit("You need Python 3.5+")

script_path = os.path.dirname(os.path.realpath(__file__)) + os.path.sep

os.environ["PYTHONHASHSEED"] = "1"

python_path = []
for dep in ["litescope", "liteeth", "litevideo", "litedram", "litex", "migen", "pyserial"]:
    python_path.append(script_path + "deps" + os.path.sep + dep)
os.environ["PYTHONPATH"] = os.pathsep.join(python_path)
#os.environ["V"] = "1" # Use to debug Makefiles
os.environ["PYTHON"] = sys.executable

# Build the bitstream

# Start the litex_server script
if len(sys.argv) > 1 and sys.argv[1] == "litex_server":
    subprocess.Popen([sys.executable, "-mlitex.soc.tools.remote.litex_server"] + sys.argv[2:]).wait()
if len(sys.argv) > 1 and sys.argv[1] == "litex_term":
    subprocess.Popen([sys.executable, "-mlitex.soc.tools.litex_term"] + sys.argv[2:]).wait()
else:
    if len(sys.argv) > 1:
        args = sys.argv[1:]
    else:
        args = ["video_overlay"]
    subprocess.Popen([sys.executable, script_path + os.path.sep + "netv2mvp.py"] + args).wait()

# Debug environment using bash
#os.execl("/bin/bash", "bash")
