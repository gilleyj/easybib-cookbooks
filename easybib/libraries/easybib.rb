module EasyBib
  def amd64?(node = self.node)
    if node['kernel']['machine'] == 'x86_64'
      return true
    end
    false
  end

  def deploy_crontab?(instance_roles, cronjob_role)
    if cronjob_role.nil?
      return true
    end

    if instance_roles.include?(cronjob_role)
      return true
    end

    false
  end

  def has_env?(app, node = self.node)
    unless node.attribute?(app)
      return false
    end

    if node[app]['env']
      return true
    end

    false
  end

  def allow_deploy(application, requested_application, requested_role = nil, node = self.node)
    unless is_aws(node)
      return false
    end

    instance_roles = get_instance_roles(node)

    Chef::Log.info(
      "deploy #{requested_application} - requested app: #{application}, role: #{instance_roles}"
    )

    if requested_application.is_a?(String)
      if requested_role.nil?
        requested_role = requested_application
      end
      return is_app_configured_for_stack(application, requested_application, requested_role, instance_roles)
    elsif requested_application.is_a?(Array)
      allow = false
      requested_application.each do |current_requested_application|
        if requested_role.nil?
          requested_role = current_requested_application
        end
        allow_current = is_app_configured_for_stack(application, current_requested_application, requested_role, instance_roles)
        # allow if any of requested_applications is allowed, so lets use OR:
        allow ||= allow_current
      end
      return allow
    else
      fail 'Unknown value type supplied for requested_role in allow_deploy'
    end
  end

  def is_app_configured_for_stack(application, requested_application, requested_role, instance_roles)
    case application
    when requested_application
      unless instance_roles.include?(requested_role)
        irs = instance_roles.inspect
        Chef::Log.info("deploy #{requested_application} - skipping: #{requested_role} is not in (#{irs})")
        return false
      end
    else
      Chef::Log.info("deploy #{requested_application} - #{application} skipped")
      return false
    end

    Chef::Log.info("deploy #{requested_application} - allowing deploy")
    true
  end

  def get_cluster_name(node = self.node)
    if node['opsworks'] && node['opsworks']['stack']
      return node['opsworks']['stack']['name']
    end
    if node['easybib'] && node['easybib']['cluster_name']
      return node['easybib']['cluster_name']
    end
    ::Chef::Log.error('Unknown environment. (get_cluster_name)')

    ''
  end

  def get_normalized_cluster_name(node = self.node)
    cluster_name = get_cluster_name(node)
    cluster_name.downcase.gsub(/[^a-z0-9-]/, '_')
  end

  def get_deploy_user(node = self.node)
    if node['opsworks']
      return node['opsworks']['deploy_user']
    end

    ::Chef::Log.debug('Unknown environment. (get_deploy_user)')

    {
      'home' => '',
      'group' => '',
      'user' => ''
    }
  end

  def get_instance_roles(node = self.node)
    if node['opsworks']
      return node['opsworks']['instance']['layers']
    end
    ::Chef::Log.debug('Unknown environment. (get_instance_roles)')
  end

  def get_instance(node = self.node)
    if node['opsworks']
      return node['opsworks']['instance']
    end
    ::Chef::Log.debug('Unknown environment. (get_instance)')
  end

  def is_aws(node = self.node)
    if node['opsworks']
      return true
    end
    false
  end

  def to_php_yaml(obj)
    # This is an ugly quick hack: Ruby Yaml adds object info !map:Chef::Node::ImmutableMash which
    # the Symfony Yaml parser doesnt like. So lets remove it. First Chef 11.4/Ruby 1.8,
    # then Chef 11.10/Ruby 2.0
    yaml    = YAML.dump(obj)
    content = yaml.gsub('!map:Chef::Node::ImmutableMash', '')
    content.gsub('!ruby/hash:Chef::Node::ImmutableMash', '')
  end

  def get_upstream_from_pools(pools, socket_dir)
    php_upstream = []
    pools.each do |pool_name|
      php_upstream << "unix:#{socket_dir}/#{pool_name}"
    end

    php_upstream
  end

  def use_aptly_mirror?(node = self.node)
    is_trusty = (node.fetch('lsb', {})['codename'] == 'trusty')
    enable_trusty_mirror = node.fetch('apt', {})['enable_trusty_mirror']
    is_trusty && enable_trusty_mirror
  end

  def ppa_mirror(node = self.node, standard_repo)
    if use_aptly_mirror?(node)
      return 'http://ppa.ezbib.com/trusty55'
    end
    standard_repo
  end

  extend self
end

class Chef::Recipe
  include EasyBib
end
