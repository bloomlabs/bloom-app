# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create example users
User.create(firstname: 'Staff', lastname: 'User', email: 'staff@example.com', staff: true, password: '12345678', password_confirmation: '12345678')
User.create(firstname: 'Normal', lastname: 'User', email: 'user@example.com', staff: false, password: '12345678', password_confirmation: '12345678')

# Recurring memberships have a stripe ID but no price (pricing is stored in the stripe subscription information)
MembershipType.create(name: 'Reviewed Member', stripe_id: '1', recurring: true, autoapprove: false)

# Once-off memberships have a price but no stripe ID
MembershipType.create(name: 'Community Member', price: 1000, recurring: false, autoapprove: true)