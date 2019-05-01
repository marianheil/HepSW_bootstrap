# hepsw install scripts

This directory includes scripts to install various HEP programs & their
dependences. This is intended to setup `/mt/hepsw` on the IPPP Durham batch
system. However the script should also work for different systems, but this
might require slight modification on the `config` file.

## Running the scripts

Each program has its own installation script named
`ProgramName/ProgramName-Installer.sh`. Pleas always run the script in their
respective folders. For example to install FastJet run:

```
cd FastJet
./FastJet-Installer.sh
```

Please make sure that your system environment (i.e. `~/.bashrc`) is as clean as
possible before installations. Otherwise some install scripts could pick up
wrong (locally) installed dependences, which wouldn't work for other users.

To also download optional features, like PDF sets for LHAPDF or progress
libraries for OpenLoops, execute the additional scripts in the corresponding
folders.

## Settings

The general install parameters are set in the common file `config`, which are
then read by each `ProgramName/ProgramName-Installer.sh` script. Beside some
general definitions, like `HEPSW_HOME` being the base directory on the `hepsw`
(i.e. `/mt/hepsw/el7/x86_64`), the `config` also defines all parameters for all
programs. Each program requires at least three parameters:

```
HEPSW_PROGRAM_VERSION # version, should be updated when newer versions available
HEPSW_PROGRAM_NAME    # name
HEPSW_PROGRAM_DIR     # install directory, set to ${HEPSW_HOME}/NAME-VERSION by default
```

These parameters are uses by both the installation script itself as also the
installation for dependent packages.

## Output

Each program is installed into `HEPSW_PROGRAM_DIR`. Additionally an environment
(`NAMEenv.sh`) and (potentially) a dependences (`NAMEdependences.sh`) file are
created. Sourcing the environment file sets all program specific system
environment variables for that package. To also set the variables from program
dependences you can either source `NAMEdependences.sh` directly or source each
package specified in in `NAMEdependences.sh` manually. The latter is preferred
to keep your environment clean and to ensure that you are only using one version
of the same package.

## Getting access

To get access to this git ask one of the authors. For write access to `hepsw`
ask Adam or Paul.
