default["hhvm-fcgi"] = {}

## hhvm

default["hhvm-fcgi"]["build"] = "" # -nightly, -dbg

default["hhvm-fcgi"]["apt"] = {}
default["hhvm-fcgi"]["apt"]["repo"] = "http://dl.hhvm.com/ubuntu"
default["hhvm-fcgi"]["apt"]["key"] = "http://dl.hhvm.com/conf/hhvm.gpg.key"

default["hhvm-fcgi"]["boost"] = {}
default["hhvm-fcgi"]["boost"]["ppa"] = "ppa:mapnik/boost"

## config/fcgi

default["hhvm-fcgi"]["prefix"] = ""

default["hhvm-fcgi"]["conf"] = {}
default["hhvm-fcgi"]["conf"]["cli"] = "/etc/hhvm/php.ini"
default["hhvm-fcgi"]["conf"]["fcgi"] = "/etc/hhvm/php-fcgi.ini"
default["hhvm-fcgi"]["conf"]["hhvm"] = "/etc/hhvm/config.hdf"
default["hhvm-fcgi"]["tmpdir"] = "/tmp/hhvm"
default["hhvm-fcgi"]["logfile"] = "/var/log/hhvm/error.log"

default["hhvm-fcgi"]["user"] = "www-data"
default["hhvm-fcgi"]["group"] = "www-data"

default["hhvm-fcgi"]["listen"] = "127.0.0.1:9000"

default["hhvm-fcgi"]["displayerrors"] = false
default["hhvm-fcgi"]["memorylimit"] = "512M"
default["hhvm-fcgi"]["maxexecutiontime"] = 60
