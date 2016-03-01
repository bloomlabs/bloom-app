# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_staff(firstname, lastname, email)
  User.create(
    firstname: firstname,
    lastname: lastname,
    email: email,
    staff: true,
    password: Devise.friendly_token[0, 20]
  )
end

create_staff('Ash', 'Tyndall', 'ash@bloom.org.au')
create_staff('Harry', 'Smallbone', 'harry@bloom.org.au')
create_staff('Mark', 'Shelton', 'mark@bloom.org.au')
create_staff('Julian', 'Coleman', 'julian@bloom.org.au')
create_staff('Lucy', 'Sharp', 'lucy.sharp@bloom.org.au')
create_staff('Alexandra', 'O\'Brien', 'alexandra@bloom.org.au')
create_staff('Shannon', 'Ziegelaar', 'shannon@bloom.org.au')

# WARNING: Don't change membership names, currently hard-coded in some places

# Recurring memberships have a stripe ID but no price (pricing is stored in the stripe subscription information)
MembershipType.create(name: 'Full-Time Member', stripe_id: 'full-time', recurring: true, autoapprove: false)
MembershipType.create(name: 'Part-Time Member', stripe_id: 'part-time', recurring: true, autoapprove: false)

# Once-off memberships have a price but no stripe ID
MembershipType.create(name: 'Community Member', price: 2500, recurring: false, autoapprove: true)
