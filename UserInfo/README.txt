# High Energy Physics Software collection

This folder contains typical HEP programs and their dependencies.
For further information see https://gitlab.dur.scotgrid.ac.uk/hepsw/install

To use the software read the following small guide. Additionally an example
~/.bashrc is provided on

  https://gitlab.dur.scotgrid.ac.uk/hepsw/install/blob/master/bashrc_example


## Using a package

To use a package add the following to your ~/.bashrc

  source HEPSW_HOME/NAME-VERSION/NAMEenv.sh

where NAME and VERSION should be replaces by the respective package name and
version.

Some packages are dependent on others, e.g. rivet depends on FastJet & HepMC2.
The specific dependencies are listed in NAME-VERSION/NAMEdependencies.sh. Either
explicitly append all packages from NAME-VERSION/NAMEdependencies.sh to your
~/.bashrc or add

  source HEPSW_HOME/NAME-VERSION/NAMEdependencies.sh

Explicitly loading in recommended to avoid conflicting dependencies.

> Note: Loading NAME-VERSION/NAMEdependencies.sh will _not_ load secondary
> dependencies! E.g. Sherpa-X.Y.Z/Sherpadependencies.sh does not source
> rivet-X.Y.Z/rivetdependencies.sh, you have to add rivet's dependencies
> manually.


## Common Problems

### System dependencies missing, e.g. GLIBCXX 3.4.20

Some system dependencies are installed in non-standard locations and might be
missing, typically GLIBCXX. They are in /usr/local/lib64 and /usr/lib64. Please
source them as well, i.e. by adding

  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib64:/usr/lib64

to your ~/.bashrc.


### Missing MPI

Some programs are compiled with OpenMPI, e.g. Sherpa. For these programs you
have to load MPI in your ~/.bashrc via

  module load mpi/openmpi-x86_64


## Adding new or updating packages

Since it is quite hard too keep track of the newest software versions, help is
always welcome. This is easiest through done by creating an "Issue" or (even
better) "Merge Request" on https://gitlab.dur.scotgrid.ac.uk/hepsw/install. If
you require software which is not yet in this collection please ask on GitLab.
