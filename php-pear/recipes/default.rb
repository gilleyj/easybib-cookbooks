#
# Cookbook Name:: php-fpm
# Recipe:: default
#
# Copyright 2010-2012, Till Klampaeckel
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this list
#   of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or other
#   materials provided with the distribution.
# * The names of its contributors may not be used to endorse or promote products
#   derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

pears = ["/usr/local/bin/pear", "/usr/bin/pear"]

pears.each do |pear|
  link pear do
    to "#{node["php-fpm"]["prefix"]}/bin/pear"
  end
end

# fucking hack. remove when pear is newer than 1.9.4
# see https://github.com/pear/pear-core/commit/8d569263eac91ad9484b45acb3a6381759138f3c#diff-b0dfa4abcb5cde685dae6b352ae38a17
remote_file '/opt/easybib/pear/PEAR/REST.php' do
  source 'https://github.com/pear/pear-core/blob/v1.9.5/PEAR.php'
  mode 0644
end

if !node["php-pear"]["packages"].empty?
  include_recipe "php-pear::packages"
end
