# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


def create_admin_user
  User.create(
      :email => 'admin@admin.com',
      :password => 'admin',
      :role_id  => Role::MANAGER.id,
      :company_name => 'admin'
  )
end

create_admin_user
