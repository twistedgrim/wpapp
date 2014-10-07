node.default['apache']['sites']['example.com']['repository'] = 'https://github.com/mattjbarlow/wordpress_skeleton.git'
node.default['apache']['sites']['example.com'][revision'] =  "HEAD"

%w( phpstack::application_php
),each do |recipe|
  include_recipe recipe
end

template "/var/www/example.com/current/wp-config.php" do
  source "wp-config.php.erb
  mode 0644
  owner "nobody"
  group "nogroup"
end 
