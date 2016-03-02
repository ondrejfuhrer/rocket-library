# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create do |u|
  u.first_name = 'First'
  u.last_name = 'Last'
  u.email = 'first@last.com'
  u.state = :active
end

User.create do |u|
  u.first_name = 'Second'
  u.last_name = 'Family'
  u.email = 'second@family.com'
  u.state = :active
end

Book.create do |b|
  b.name = 'To Kill a Mockingbird'
  b.author = 'Harper Lee'
  b.sku = '12345'
  b.state = :active
end

Book.create do |b|
  b.name = 'How to learn Chinese in 135 years'
  b.author = 'John Smith'
  b.sku = '12346'
  b.state = :active
end

Book.create do |b|
  b.name = 'Whatever'
  b.author = 'Harper Lee Johnson'
  b.sku = '12347'
  b.state = :active
end

Book.create do |b|
  b.name = 'Hunting and Fishing'
  b.author = 'Elvis Thomson'
  b.sku = '12348'
  b.state = :active
end

b = Book.create do |b|
  b.name = 'Software Engineering for newbies'
  b.author = 'Georgios Katsanos'
  b.sku = '12349'
  b.state = :active
end

Book.create do |b|
  b.name = 'Ruby for beginners'
  b.author = 'Dmitry Filatov'
  b.sku = '12350'
  b.state = :active
end

Book.create do |b|
  b.name = 'C++ for advanced users'
  b.author = 'John Anderson'
  b.sku = '12351'
  b.state = :active
end

Book.create do |b|
  b.name = 'Fates and Furies Very long title here for experimenting with the layout'
  b.author = 'Lauren Groff Van Thomson Pierson Writerson'
  b.sku = '12352'
  b.state = :active
end

# r = Rental.new
# r.book = b
# r.user = u
# r.save


