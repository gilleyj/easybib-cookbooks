default["hhvm-fcgi"] = {}

default["hhvm-fcgi"]["build"] = "" # -nightly, -dbg

default["hhvm-fcgi"]["apt"] = {
  "repo" => "http://dl.hhvm.com/ubuntu",
  "key" => "http://dl.hhvm.com/conf/hhvm.gpg.key"
}

default["hhvm-fcgi"]["boost"] = {
  "ppa" => "ppa:mapnik/boost"
}

default["hhvm-fcgi"]["prefix"] = ""

default["hhvm-fcgi"]["tmpdir"] = "/tmp/hhvm"
default["hhvm-fcgi"]["logfile"] = "/var/log/hhvm/error.log"

default["hhvm-fcgi"]["user"] = "www-data"
default["hhvm-fcgi"]["group"] = "www-data"

default["hhvm-fcgi"]["listen"] = "127.0.0.1:9000"

default["hhvm-fcgi"]["config"] = {}

default["hhvm-fcgi"]["config"]["hhvm"] = {
  "file" => "/etc/hhvm/config.hdf",
  "display_errors" => "On"
}

default["hhvm-fcgi"]["config"]["fcgi"] = {
  "file" => "/etc/hhvm/php-fcgi.ini",
  "enable_dl" => "Off",
  "display_errors" => "Off",
  "memory_limit" => "512M",
  "max_execution_time" => 60
}

default["hhvm-fcgi"]["config"]["cli"] = {
  "file" => "/etc/hhvm/php.ini",
  "enable_dl" => "On",
  "display_errors" => "On",
  "memory_limit" => "1G",
  "max_execution_time" => "-1"
}
