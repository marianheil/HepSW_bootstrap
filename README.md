# hepsw install scripts

This directory includes scripts to install various HEP programs & their
dependencies. This is intended to setup `/mt/hepsw` on the IPPP Durham batch
system. However the script should also work for different systems, but this
might require slight modification on the [`config`](config) file. These scripts
can also be used to build dockers, see the
[hepsw/docker](https://gitlab.dur.scotgrid.ac.uk/hepsw/docker) project.

## Running the scripts

Each program has its own installation script named
`ProgramName/ProgramName-Installer.sh`. Pleas always run the script in their
respective folders. For example to install FastJet run:

```sh
cd FastJet
./FastJet-Installer.sh
```

Please make sure that your system environment (i.e. `~/.bashrc`) is as clean as
possible before installations. Otherwise some install scripts could pick up
wrong (locally) installed dependencies, which wouldn't work for other users.

> All required dependencies have to be installed (manually) before running
> `ProgramName-Installer.sh`.

To also download optional features, like PDF sets for LHAPDF or progress
libraries for OpenLoops, execute the additional scripts in the corresponding
folders.

## Settings

The general install parameters are set in the common file [`config`](config),
which are then read by each `ProgramName/ProgramName-Installer.sh` script.
Beside some general definitions, like `HEPSW_HOME` being the base directory on
the `hepsw` (i.e. `/mt/hepsw/el7/x86_64`), the [`config`](config) also defines
all parameters for all programs. Each program requires at least three
parameters:

```sh
HEPSW_PROGRAM_VERSION # version, should be updated when newer versions available
HEPSW_PROGRAM_NAME    # name
HEPSW_PROGRAM_DIR     # install directory, set to ${HEPSW_HOME}/NAME-VERSION by default
HEPSW_PROGRAM_DEPENDENCIES # A list of dependencies required for this program (can be empty)
```

These parameters are uses by both the installation script itself as also the
installation for dependent packages.

## Output

Each program is installed into `HEPSW_PROGRAM_DIR`. Additionally an environment
(`NAMEenv.sh`) and a dependencies (`NAMEdependencies.sh`) file are created.
Sourcing the environment file sets all program specific system environment
variables for that package. To also set the variables from program dependencies
you can either source `NAMEdependencies.sh` directly or source each package
specified in in `NAMEdependencies.sh` manually. The latter is preferred to keep
your environment clean and to ensure that you are only using one version of the
same package. For a full example of a possible `~/.bashrc` see
[`bashrc_example`](bashrc_example).

# Design overview

In the following we will describe the general design of this project on the
example of `LHAPDF`. The specific scripts are in the [`LHAPDF`](LHAPDF) folder.
We first take a look at the main installation script
([`LHAPDF-Installer.sh`](LHAPDF/LHAPDF-Installer.sh)).

## Read configuration

First we read the configuration from the general configuration
[`config`](config). This is a `shell` file which sets the different variables
described above. Next we select the package we want to install, by setting the
`name`, `dependencies` and `InstallDir` variable, i.e.
```sh
name=${HEPSW_LHAPDF_NAME}
package_name=${name}-${HEPSW_LHAPDF_VERSION} # this is not strictly required
dependencies=${HEPSW_LHAPDF_DEPENDENCIES[@]}
InstallDir=${HEPSW_LHAPDF_DIR}
```

## Setup environment

These variables are then read in the [`init.sh`](init.sh) script, which creates
a temporary working directory (`WORKING_DIR` set in [`config`](config)), the
installation folder (`InstallDir`) and initialised the `LHAPDFdependencies.sh`.
`LHAPDFdependencies.sh` is then sourced to ensure the correct environment.
Furthermore we copy some general informations for the users (see
[`UserInfo`](UserInfo/README.md)).

## Download & installation

With all the generic setup out of the way we can download and install our
package. This is the central part of each installation script and is unique for
each program. For `LHAPDF` we have a typical combination of `./configure` and a
`make install`, without any optional setting. The other common build tool is
[`cmake`](https://cmake.org/) (see e.g. [`HepMC3`](HepMC3/HepMC3-Installer.sh)),
which is given by the `CMAKE` variable in [`config`](config). This section might
include some logic to also work with optional dependencies, or specific tweaks
of the program.

## Exporting the environment

After installation we are left with cleaning up the build folder (`rm -rf
${WORKING_DIR}/${package_name}`) and generating the `NAMEenv.sh`, which can be
sourced by the user. As a template for the environment file we use the
[`TEMPLATEenv.sh`](TEMPLATEenv.sh), which includes the most common variable
exports. In there we use the `TEMPLATE` key as a place holder for the specific
`${name}`. Again the exact for of the resulting file depends on the specific
installation. For `LHAPDF` the important exports are:

- `PATH`- adding the executable to runnable commands
- `LD_LIBRARY_PATH` - search path for dynamically linking to this library
- `PYTHONPATH` - python equivalent of `LD_LIBRARY_PATH`
- `PKG_CONFIG_PATH` - making sure
  [`pkg-config`](https://people.freedesktop.org/~dbn/pkg-config-guide.html) finds
  the installation, not all packages support this

For `cmake` sometimes one also has to set `CMAKE_PREFIX_PATH`, which can help
[`find_package`](https://cmake.org/cmake/help/latest/command/find_package.html#search-procedure)
in `cmake` (similar to `PKG_CONFIG_PATH`).

# Getting access

To get access to this git directly ask one of the authors, or folk this project
and submit merge request. For write access to `hepsw` in Durham ask Adam or
Paul.
