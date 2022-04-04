PJob: Paul's (very crude) Job Scheduler
===============================================================================
https://github.com/pcmoore/pjob

*TODO: write proper docs as this README is ... not very helpful :)*

## Overview

This project started as basic, and very crude, job scheduler as I had a need
to automate some background tasks and traditional job schedulers, i.e.
[Jenkins](https://www.jenkins.io), were much more complicated than I wanted,
or needed at the time.  While PJob has grown far more features than I
intended, the core focus remains the same:

- Minimal dependencies
- Wide distro support
- Usable on both single systems as well as more complicated build setups with
  multiple systems

## Installation and Configuration

### Install the PJob Tools

The easiest was to install the PJob tools is to clone this repository onto your
system.  At present the only tested configuration involves installing the tools
into your "/root/sources/pjob" directory, but it is likely that other
directories would work too; I just haven't verified that all the hard coded
path dependencies have been fixed.

```
% git clone https://github.com/pcmoore/pjob.git /root/sources/pjob
```

After the PJob tools have been installed you will need to create the various
working directories for PJob.  These are documented in the "pjob.config" file
in the tools base directory, here is a quick description:

- PJOB_DIR_JOBS (commonly "/srv/pjob/jobs")  
The directory where all of the PJob jobs will be stored.

- PJOB_DIR_GLOBAL (commonly "/srv/pjob/global")  
The directory where all of the global job scripts will be stored, see the
scripts included in the repository's "global.contrib" directory.

- PJOB_DIR_CHROOTS (commonly "/var/lib/pjob/chroots")  
The directory where all of the job chroots are stored.  Generally speaking,
container base images make excellent starting points for a PJob chroot.

- PJOB_DIR_WORK (commonly "/var/cache/pjob/work")  
The directory where the PJob job instances are created and mounted.

### Install the systemd Service (Optional)

If you want to enable the PJob automated job scheduling you should copy the
"pjob.service" file into your "/etc/systemd/system" directory and enable it at
boot using [systemd](https://www.freedesktop.org/wiki/Software/systemd):

```
% cp /root/sources/pjob/pjob.service /etc/systemd/system/pjob.service
% systemctl daemon-reload
% systemctl enable --now pjob
```

### Install the Job Chroots

There are multiple ways to create a usable chroot under Linux, with many
distros providing tools to make it easier.  This task is left as an exercise
for the reader, but in order to use PJob at least one chroot needs to be
installed under "$PJOB_DIR_CHROOTS".

## Examples

There is a separate repository which contains some job examples that might be
helpful as a reference and starting point for your own jobs.

* https://github.com/pcmoore/pjob-jobs
