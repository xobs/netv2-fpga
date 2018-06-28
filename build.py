#!/usr/bin/env python3

# This script enables easy, cross-platform building without the need
# to install third-party Python modules.

import sys
import os
import subprocess
import argparse


def fixup_env(script_path, args):
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
    # in which Migen generates its output Verilog will change with every run,
    # and the addresses for various modules will change.
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


def check_dependencies(args):
    # Equivalent to the powershell Get-Command, and kinda like `which`
    def get_command(cmd):
        if os.name == 'nt':
            path_ext = os.environ["PATHEXT"].split(os.pathsep)
        else:
            path_ext = [""]
        for ext in path_ext:
            for path in os.environ["PATH"].split(os.pathsep):

                if os.path.exists(path + os.path.sep + cmd + ext):
                    return path + os.path.sep + cmd + ext
        return None

    dependency_errors = 0

    # Litex / Migen require Python 3.5 or newer.  Ensure we're running
    # under a compatible version of Python.
    if sys.version_info[:3] < (3, 5):
        dependency_errors += 1
        print("python: You need Python 3.5+ (version {} found)".format(sys.version_info[:3]))
    elif args.check_deps:
        import platform
        print("python 3.5+: ok (Python {} found)".format(platform.python_version()))

    vivado_path = get_command("vivado")
    make_path = get_command("make")
    riscv64_path = get_command("riscv64-unknown-elf-gcc")

    if vivado_path == None:
        # Look for the default Vivado install directory
        if os.name == 'nt':
            base_dir = r"C:\Xilinx\Vivado"
        else:
            base_dir = "/opt/Xilinx/Vivado"
        for file in os.listdir(base_dir):
            bin_dir = base_dir + os.path.sep + file + os.path.sep + "bin"
            if os.path.exists(bin_dir + os.path.sep + "vivado"):
                os.environ["PATH"] += os.pathsep + bin_dir
                vivado_path = bin_dir
                break

    if vivado_path == None:
        print("vivado: toolchain not found in your PATH")
        dependency_errors += 1
    elif args.check_deps:
        print("vivado: found at {}".format(vivado_path))

    if make_path == None:
        print("make: GNU Make not found in PATH")
        dependency_errors += 1
    elif args.check_deps:
        print("make: found at {}".format(make_path))

    if riscv64_path == None:
        print("riscv64: toolchain not found in your PATH")
        dependency_errors += 1
    elif args.check_deps:
        print("riscv64: found at {}".format(riscv64_path))

    if dependency_errors > 0:
        raise SystemExit(str(dependency_errors) + " missing dependencies were found")

def main(args):

    # Obtain the path to this script, plus a trailing separator.  This will
    # be used later on to construct various environment variables for paths
    # to a variety of support directories.
    script_path = os.path.dirname(os.path.realpath(__file__)) + os.path.sep

    # Add any environment variables that are used for child scripts
    fixup_env(script_path, args)

    # If the user just wanted to print the environment variables, do that and quit.
    if args.print_env:
        print("PYTHONPATH=" + os.environ["PYTHONPATH"])
        print("PYTHONHASHSEED=1")
        print("PYTHON=" + sys.executable)
        return

    check_dependencies(args)
    if args.check_deps:
        return

    # Determine which program to run.  If no program was specified, run
    # the netv2 synthesis program with some defaults args.
    # Note: This can be useful to run a test prompt, e.g. by running this
    # script with "bash" as an argument.
    if args.exec != None:
        if args.exec[0] == "litex_server":
            cmd = [sys.executable,
                   "-mlitex.soc.tools.remote.litex_server"] + args.exec[1:]
        elif args.exec[0] == "litex_term":
            cmd = [sys.executable, "-mlitex.soc.tools.litex_term"] + args.exec[1:]
        elif args.exec[0] == "mkmscimg":
            cmd = [sys.executable, "-mlitex.soc.tools.mkmscimg"] + args.exec[1:]
        elif args.exec[0].endswith(".py"):
            cmd = [sys.executable] + args.exec
        else:
            cmd = args.exec
    elif args.build != None:
        cmd = [sys.executable, script_path + args.build, args.target]
    elif len(args.cmd) == 0:
        cmd = [sys.executable, script_path + "netv2mvp.py", "video_overlay"]

    subprocess.Popen(cmd).wait()


# For the main command, parse args and hand it off to main()
if __name__ == "__main__":
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
    parser.add_argument(
        "-p", "--print-env", help="print environment variable listing for pycharm, vscode, or bash", action="store_true"
    )
    parser.add_argument(
        "-c", "--check-deps", help="check build environment for dependencies such as compiler and fpga tools and then exit", action="store_true"
    )
    parser.add_argument('-e', '--exec', help="Command to run",
                        nargs=argparse.REMAINDER)
    args = parser.parse_args()

    main(args)
