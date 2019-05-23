This folder contains typical HEP programs and their dependences.
For further information see https://gitlab.dur.scotgrid.ac.uk/hepsw/install

# Using a package

To use a package add the following to you ~/.bashrc

  source HEPSW_HOME/NAME-VERSION/NAMEenv.sh

where NAME and VERSION should be replaces by the respective package name and
version.

Some packages are dependent on others, e.g. rivet depends on FastJet & HepMC2.
The specific dependences are listed in NAME-VERSION/NAMEdependences.sh. Add
everything listed in there to you ~/.bashrc.

# Missing dependences, e.g. GLIBCXX 3.4.20

A common problem in using these packages are missing system dependences, mostly
GLIBCXX. They are in /usr/local/lib64 and /usr/lib64. Please source them as
well, i.e. by adding

  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib64:/usr/lib64

to your .bashrc.

# Adding new or updating packages

To add new packages or update old once please create an "Issue" or "Merge
Request" on https://gitlab.dur.scotgrid.ac.uk/hepsw/install
