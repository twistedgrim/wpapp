include_recipe 'phpstack::mysql_base'

mysql_database 'wordpress' do
  connection(
    :host     => 'localhost',
    :username => 'root',
    :password => node['mysql']['server_root_password']
  )
  action :create
end

mysql_database_user 'phpuser' do
  connection(
    :host     => 'localhost',
    :username => 'root',
    :password => node['mysql']['server_root_password']
  )
  password node['wordpress']['db_passwd']
  database_name 'wordpress'
  privileges [:select, :update, :insert, :drop]
  action :grant
end

db = File.join(Chef::Config[:file_cache_path], 'wordpress.sql')

remote_file db do
  source 'http://5f8981e76f355afba706-4f938954db59b7e824997e62ff19ce4f.r83.cf1.rackcdn.com/wordpress.sql'
  action :create_if_missing
  notifies :run, 'execute[import]', :immediately
end

execute 'import' do
  command "mysql -u root -p\"#{node['mysql']['server_root_password']}\" wordpress < #{db}"
  action :nothing
end

