include_recipe 'easybib::role-phpapp'

include_recipe 'php-gearman'
include_recipe 'php-intl'

include_recipe 'easybib-deploy::easybib'

if is_aws
  include_recipe 'nginx-app::configure'
else
  include_recipe 'memcache'
  include_recipe 'nginx-app::vagrant'
end
