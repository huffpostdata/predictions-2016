# Senate forecast model

Run this to set up the senate forecast spreadsheets.

It reads from `../data/sheets/input/senate-*` and writes to
`../data/sheets/output/senate-*`. See `../README.md` for the data schema.

# Setup

## Mac OS X

Using [Homebrew](http://brew.sh/):

```sh
brew tap homebrew/science
brew install r
brew install jags
brew install curl
R --vanilla -e 'install.packages(c("rjags", "truncnorm", "coda", "httr"), repos=c("https://cloud.r-project.org/"))'
```

## Windows

No.

## Linux: CentOS

```bash
wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
(cd /etc/yum.repos.d && sudo wget 'http://download.opensuse.org/repositories/home:/cornell_vrdc/CentOS_CentOS-6/home:cornell_vrdc.repo')
sudo rpm -ivh epel-release-6-8.noarch.rpm
sudo yum install R R-devel jags4-devel curl-devel
R --vanilla -e 'install.packages(c("rjags", "truncnorm", "coda", "httr", "Matrix"), repos=c("https://cloud.r-project.org/"))'
```

# Usage

```sh
cd R/senate
Rscript --vanilla ./main.R
```

## Authors

* Adam Hooper <adam.hooper@huffingtonpost.com>
* Natalie Jackson <natalie.jackson@huffingtonpost.com>
* Simon Jackman <jackman@stanford.edu>
* Jay Boice <jay.boice@huffingtonpost.com>
