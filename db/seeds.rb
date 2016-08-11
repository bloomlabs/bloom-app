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

def create_resource(name, full_name, google_calendar_id, pricing_dollars, pricing_member_dollars, resource_group)
  Resource.create(name: name,
                  full_name: full_name,
                  google_calendar_id: google_calendar_id,
                  pricing_cents: pricing_dollars * 100,
                  pricing_cents_member: pricing_member_dollars * 100,
                  group: resource_group)
end

create_superuser('Ash', 'Tyndall', 'ash@bloom.org.au')
create_superuser('Harry', 'Smallbone', 'harry@bloom.org.au')
create_superuser('Mark', 'Shelton', 'mark@bloom.org.au')
create_managers('Julian', 'Coleman', 'julian@bloom.org.au')
create_managers('Lucy', 'Sharp', 'lucy.sharp@bloom.org.au')
create_managers('Alexandra', 'O\'Brien', 'alexandra@bloom.org.au')
create_managers('Shannon', 'Ziegelaar', 'shannon@bloom.org.au')

create_resource("fun", "Fun Room", "bloom.org.au_2d34323031373634322d373530@resource.calendar.google.com", 30, 10, 'meeting_room')
create_resource("serious", "Serious Room", "bloom.org.au_3931313239303239343537@resource.calendar.google.com", 30, 10, 'meeting_room')
create_resource("main", "Main Room", "bloom.org.au_39343634313833322d383137@resource.calendar.google.com", 50, 30, 'main_room')

# WARNING: Don't change membership names, currently hard-coded in some places

# Recurring memberships have a stripe ID but no price (pricing is stored in the stripe subscription information)
MembershipType.create(name: 'Full-Time Member', stripe_id: 'full-time', recurring: true, autoapprove: false, status_email: 'status.coworker@bloom.org.au', success_email: 'new.coworker@bloom.org.au', wifi_access: true)
MembershipType.create(name: 'Part-Time Member', stripe_id: 'part-time', recurring: true, autoapprove: false, status_email: 'status.coworker@bloom.org.au', success_email: 'new.coworker@bloom.org.au', wifi_access: true)
MembershipType.create(name: 'Dedicated Workspace', stripe_id: 'dedicated', recurring: true, autoapprove: false, status_email: 'status.coworker@bloom.org.au', success_email: 'new.coworker@bloom.org.au', wifi_access: true)
MembershipType.create(name: 'Coworking Membership', stripe_id: 'coworking', recurring: true, autoapprove: false, status_email: 'status.coworker@bloom.org.au', success_email: 'new.coworker@bloom.org.au', wifi_access: true)
MembershipType.create(name: 'Freelancer Pass', stripe_id: 'freelancer', recurring: true, autoapprove: false, status_email: 'status.coworker@bloom.org.au', success_email: 'new.coworker@bloom.org.au', wifi_access: true)
MembershipType.create(name: 'Community Membership', stripe_id: 'community', recurring: true, autoapprove: false, status_email: 'status.coworker@bloom.org.au', success_email: 'new.coworker@bloom.org.au', wifi_access: true)
MembershipType.create(name: 'St Cat\'s Community Membership', stripe_id: '', recurring: false, autoapprove: false, status_email: 'status.coworker@bloom.org.au', success_email: 'new.coworker@bloom.org.au', wifi_access: true)

