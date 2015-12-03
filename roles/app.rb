# Default attributes
node.reverse_merge!(
  {
    'rbenv' =>
    {
      'global' => '2.2.3',
      'versions' => ['2.2.3'],
      'rbenv_root' => '/usr/local/rbenv',
      'scheme' => 'https'
    },
    'rbenv-default-gems' =>
    {
      'default-gems' => ['bundler']
    }
  }
)

include_recipe '../cookbooks/ruby/default.rb'
