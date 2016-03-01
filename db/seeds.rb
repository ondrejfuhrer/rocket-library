# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.new do |u|
  u.first_name = 'First'
  u.last_name = 'Last'
  u.email = 'first@last.com'
end

User.new do |u|
  u.first_name = 'Second'
  u.last_name = 'Family'
  u.email = 'second@family.com'
end



