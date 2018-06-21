#!/usr/bin/env python3

# This script enables easy, cross-platform building without the need
# to install third-party Python modules.

import sys
import os
import subprocess
import argparse

# Parse script arguments into a tuple.  Known arguments go into the
# "args" dict, with the command-to-run stored in args.cmd
parser = argparse.ArgumentParser(
    description="Wrap Python code to enable quickstart")
parser.add_argument(
    "-v", "--verbose", help="increase verboseness of make processes", action="store_true")
parser.add_argument(
    "-b", "--build", help="script target to build", default="netv2mvp.py"
)
parser.add_argument(
    "-t", "--target", help="target to build in the script", default="video_overlay"
)
parser.add_argument('-e', '--exec', help="Command to run", nargs=argparse.REMAINDER)
args = parser.parse_args()

# Litex / Migen require Python 3.5 or newer.  Ensure we're running
# under a compatible version of Python.
if sys.version_info[:3] < (3, 5):
    raise SystemExit("You need Python 3.5+")

# On Windows, ensure we can run Vivado, and advise the user to add it
# to their PATH if not.
if os.name == 'nt':
    vivado_found = False
    for path in os.environ["PATH"].split(os.pathsep):
        if os.path.exists(path + os.path.sep + "vivado"):
            vivado_found = True
    if vivado_found == False:
        raise SystemExit("Vivado not found.  Please add Vivado to your PATH.")

# Obtain the path to this script, plus a trailing separator.  This will
# be used later on to construct various environment variables for paths
# to a variety of support directories.
script_path = os.path.dirname(os.path.realpath(__file__)) + os.path.sep

# Python has no concept of a local dependency path, such as the C `-I``
# switch, or the nodejs `node_modules` path, or the rust cargo registry.
# Instead, it relies on an environment variable to append to the search
# path.
# Construct this variable by adding each subdirectory under the `deps/`
# directory to the PYTHONPATH environment variable.
python_path = []
for dep in os.listdir("deps"):
    dep = "deps" + os.path.sep + dep
    if os.path.isdir(dep):
        python_path.append(script_path + dep)
os.environ["PYTHONPATH"] = os.pathsep.join(python_path)

# Python randomizes the order in which it traverses hashes, and Migen uses
# hashes an awful lot when bringing together modules.  As such, the order
# in which Migen generates its output Verilog will change with every run.
# Make builds deterministic so that the generated Verilog code won't change
# across runs.
os.environ["PYTHONHASHSEED"] = "1"

# Some Makefiles are invoked as part of the build process, and those Makefiles
# occasionally have calls to Python.  Ensure those Makefiles use the same
# interpreter that this script is using.
os.environ["PYTHON"] = sys.executable

# Set the environment variable "V" to 1.  This causes Makefiles to print
# the commands they run, which makes them easier to debug.
if args.verbose:
    os.environ["V"] = "1"

# Determine which program to run.  If no program was specified, run
# the netv2 synthesis program with some defaults args.
# Note: This can be useful to run a test prompt, e.g. by running this
# script with "bash" as an argument.
if args.exec != None:
    if args.exec[0] == "litex_server":
        cmd = [sys.executable, "-mlitex.soc.tools.remote.litex_server"] + args.exec[1:]
    elif args.exec[0] == "litex_term":
        cmd = [sys.executable, "-mlitex.soc.tools.litex_term"] + args.exec[1:]
    elif args.exec[0] == "mkmscimg":
        cmd = [sys.executable, "-mlitex.soc.tools.mkmscimg"] + args.exec[1:]
    elif args.exec[0].endswith(".py"):
        cmd = [sys.executable] + args
    else:
        cmd = args.exec
elif args.build != None:
    cmd = [sys.executable, script_path + args.build, args.target]
elif len(args.cmd) == 0:
    cmd = [sys.executable, script_path + "netv2mvp.py", "video_overlay"]

subprocess.Popen(cmd).wait()