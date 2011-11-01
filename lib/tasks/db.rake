# rake db:drop && rake db:create && rake db:migrate && rake db:seed

namespace :db do
  desc 'Recreate database'
  task :recreate => 'db:migrate:reset' do
    Rake::Task['db:seed'].invoke unless RAILS_ENV == 'test'
    #if RAILS_ENV == 'development'
    #  ENV['position'] = 'before'
    #  Rake::Task['annotate_models'].invoke
    #end
  end
end