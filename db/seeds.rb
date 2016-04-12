# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_managers(firstname, lastname, email)
  u = User.new(
    firstname: firstname,
    lastname: lastname,
    email: email,
    access_level: 100,
    password: Devise.friendly_token[0, 20]
  )
  u.skip_confirmation!
  u.save
end

def create_superuser(firstname, lastname, email)
  u = User.new(
    firstname: firstname,
    lastname: lastname,
    email: email,
    access_level: 255,
    password: Devise.friendly_token[0, 20]
  )
  u.skip_confirmation!
  u.save
end

create_superuser('Ash', 'Tyndall', 'ash@bloom.org.au')
create_superuser('Harry', 'Smallbone', 'harry@bloom.org.au')
create_superuser('Mark', 'Shelton', 'mark@bloom.org.au')
create_managers('Julian', 'Coleman', 'julian@bloom.org.au')
create_managers('Lucy', 'Sharp', 'lucy.sharp@bloom.org.au')
create_managers('Alexandra', 'O\'Brien', 'alexandra@bloom.org.au')
create_managers('Shannon', 'Ziegelaar', 'shannon@bloom.org.au')

# WARNING: Don't change membership names, currently hard-coded in some places

# Recurring memberships have a stripe ID but no price (pricing is stored in the stripe subscription information)
MembershipType.create(name: 'Full-Time Member', stripe_id: 'full-time', recurring: true, autoapprove: false, status_email: 'status.coworker@bloom.org.au', success_email: 'new.coworker@bloom.org.au', wifi_access: true)
MembershipType.create(name: 'Part-Time Member', stripe_id: 'part-time', recurring: true, autoapprove: false, status_email: 'status.coworker@bloom.org.au', success_email: 'new.coworker@bloom.org.au', wifi_access: true)
