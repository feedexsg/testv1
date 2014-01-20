# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["Main", "Side"].each {|cat| Category.find_or_create_by(name: cat)}
location = Location.find_or_create_by(name: "Singapore")

admin = User.find_or_initialize_by(email: 'admin@feedex.com')
admin.attributes = {name: "Admin", location: location, password: "f33d3x", password_confirmation: "f33d3x". is_admin: true}
admin.save
