#!/usr/bin/env python3

import sys
import os


if sys.version_info[:3] < (3, 5):
    raise SystemExit("You need Python 3.5+")

script_path = os.path.dirname(os.path.realpath(__file__)) + os.path.sep
print("Script path: " + script_path)

os.environ["PYTHONHASHSEED"] = "1"

python_path = []
for dep in ["litescope", "liteeth", "litevideo", "litedram", "litex", "migen"]:
    python_path.append(script_path + "deps" + os.path.sep + dep)
os.environ["PYTHONPATH"] = os.pathsep.join(python_path)

#os.system(sys.executable + " " + script_path + os.path.sep + "netv2mvp.py video_overlay")
os.system(sys.executable + " -mlitex.soc.tools.remote.litex_server -emain")