#!/usr/bin/env python3

# This script enables easy, cross-platform building without the need
# to install third-party Python modules.

import sys
import os
import subprocess
import argparse


# Obtain the path to this script, plus a trailing separator.  This will
# be used later on to construct various environment variables for paths
# to a variety of support directories.
script_path = os.path.dirname(os.path.realpath(__file__)) + os.path.sep


def fixup_env(script_path, args):
    # Python has no concept of a local dependency path, such as the C `-I``
    # switch, or the nodejs `node_modules` path, or the rust cargo registry.
    # Instead, it relies on an environment variable to append to the search
    # path.
    # Construct this variable by adding each subdirectory under the `deps/`
    # directory to the PYTHONPATH environment variable.
    python_path = []
    for dep in os.listdir(script_path + "deps"):
        dep = script_path + "deps" + os.path.sep + dep
        if os.path.isdir(dep):
            python_path.append(dep)
    os.environ["PYTHONPATH"] = os.pathsep.join(python_path)

    # Set the "LXBUILDENV_REEXEC" variable to prevent the script from continuously
    # reinvoking itself.
    os.environ["LXBUILDENV_REEXEC"] = "1"

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
    if args.lx_verbose:
        os.environ["V"] = "1"

    # If the user just wanted to print the environment variables, do that and quit.
    if args.lx_print_env:
        print("PYTHONPATH={}".format(os.environ["PYTHONPATH"]))
        print("PYTHONHASHSEED={}".format(os.environ["PYTHONHASHSEED"]))
        print("PYTHON={}".format(sys.executable))
        print("LXBUILDENV_REEXEC={}".format(os.environ["LXBUILDENV_REEXEC"]))

        sys.exit(0)


# Validate that the required dependencies (Vivado, compilers, etc.)
# have been installed.
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
        print(
            "python: You need Python 3.5+ (version {} found)".format(sys.version_info[:3]))
    elif args.lx_check_deps:
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
        print("vivado: toolchain not found in your PATH -- download it from https://www.xilinx.com/support/download.html")
        dependency_errors += 1
    elif args.lx_check_deps:
        print("vivado: found at {}".format(vivado_path))

    if make_path == None:
        print("make: GNU Make not found in PATH")
        dependency_errors += 1
    elif args.lx_check_deps:
        print("make: found at {}".format(make_path))

    if riscv64_path == None:
        print("riscv64: toolchain not found in your PATH -- download it from https://www.sifive.com/products/tools/")
        dependency_errors += 1
    elif args.lx_check_deps:
        print("riscv64: found at {}".format(riscv64_path))

    if dependency_errors > 0:
        raise SystemExit(str(dependency_errors) +
                         " missing dependencies were found")

    if args.lx_check_deps:
        sys.exit(0)


# Determine whether we need to invoke "git submodules init --recurse"
def check_submodules(script_path, args):
    need_init = False
    gitmodules = open(script_path + '.gitmodules', 'r')
    for line in gitmodules:
        parts = line.split("=", 2)
        if parts[0].strip() == "path":
            path = parts[1].strip()
            if not os.path.exists(script_path + path + os.path.sep + ".git"):
                need_init = True
                print("Couldn't find {}".format(path + os.path.sep + ".git"))
                break
    if need_init:
        print("Missing submodules -- updating")
        subprocess.Popen(["git", "submodule", "update",
                          "--init", "--recursive"], cwd=script_path).wait()
    elif args.lx_verbose:
        print("Submodule check: Submodules found")


def main(args):

    # Add any environment variables that are used for child scripts
    fixup_env(script_path, args)
    check_dependencies(args)
    check_submodules(script_path, args)

    if args.exec[0].endswith(".py"):
        cmd = [sys.executable] + args.exec
    else:
        cmd = args.exec
    subprocess.Popen(cmd).wait()



# For the main command, parse args and hand it off to main()
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Wrap Python code to enable quickstart",
        add_help=False)
    parser.add_argument(
        "-h", "--help", "--lx-help", help="show this help message and exit", action="help"
    )
    parser.add_argument(
        "-v", "--lx-verbose", help="increase verboseness of make processes", action="store_true")
    parser.add_argument(
        "-p", "--lx-print-env", help="print environment variable listing for pycharm, vscode, or bash", action="store_true"
    )
    parser.add_argument(
        "-c", "--lx-check-deps", help="check build environment for dependencies such as compiler and fpga tools and then exit", action="store_true"
    )
    parser.add_argument('-e', '--exec', '--lx-exec', help="Command to run", required=True,
                        nargs=argparse.REMAINDER)
    args = parser.parse_args()

    main(args)

elif "LXBUILDENV_REEXEC" not in os.environ:
    parser = argparse.ArgumentParser(
        description="Wrap Python code to enable quickstart",
        add_help=False)
    parser.add_argument(
        "--lx-verbose", help="increase verboseness of some processes", action="store_true")
    parser.add_argument(
        "--lx-print-env", help="print environment variable listing for pycharm, vscode, or bash", action="store_true"
    )
    parser.add_argument(
        "--lx-check-deps", help="check build environment for dependencies such as compiler and fpga tools and then exit", action="store_true"
    )
    parser.add_argument(
        "--lx-help", action="help"
    )
    (args, rest) = parser.parse_known_args()

    fixup_env(script_path, args)
    check_dependencies(args)
    check_submodules(script_path, args)

    try:
        sys.exit(subprocess.Popen(
            [sys.executable] + [sys.argv[0]] + rest).wait())
    except:
        sys.exit(1)
else:
    pass
