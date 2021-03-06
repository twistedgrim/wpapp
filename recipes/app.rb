node.default['apache']['sites']['example.com']['repository'] = 'https://github.com/mattjbarlow/wordpress_skeleton.git'
node.default['apache']['sites']['example.com']['revision'] = "HEAD"

%w( platformstack::default
    rackops_rolebook::default
    phpstack::application_php
    phpstack::varnish
  ).each do |recipe|
  include_recipe recipe
end

user "nobody" do
  supports :manage_home => true
  password "goodpassword"
end

group 'nogroup' do
  action :create
  members 'nobody'
  append true
end

directory '/var/www/example.com/current/' do
  owner 'nobody'
  group 'nogroup'
  mode '0644'
  recursive true
  action :create
end

template '/var/www/example.com/current/wp-config.php' do
  source 'wp-config.php.erb'
  mode 0644
  owner 'nobody'
  group 'nogroup'
end
