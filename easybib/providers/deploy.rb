action :deploy do
  app = new_resource.app
  deploy_data = new_resource.deploy_data
  application_root_dir = "#{deploy_data['deploy_to']}/current"
  document_root_dir = "#{application_root_dir}/#{deploy_data['document_root']}/"

  opsworks_deploy_user do
    deploy_data deploy_data
    app app
  end

  opsworks_deploy_dir do
    user  deploy_data['user']
    group deploy_data['group']
    path  deploy_data['deploy_to']
  end

  opsworks_deploy do
    deploy_data deploy_data
    app app
  end

  easybib_crontab "#{app}_#{new_resource.cronjob_role}" do
    crontab_file "#{application_root_dir}/deploy/crontab"
    app app
    only_if do
      ::EasyBib.deploy_crontab?(
        new_resource.instance_roles,
        new_resource.cronjob_role
      )
    end
  end

  easybib_gearmanw application_root_dir do
    envvar_json_source new_resource.envvar_json_source
  end

  cookbook_file "#{document_root_dir}/robots.txt" do
    mode   '0644'
    cookbook 'easybib'
    source 'robots.txt'
    not_if { node['easybib_deploy']['envtype'] == 'production' }
  end

  easybib_envconfig app

  new_resource.updated_by_last_action(true)

end
