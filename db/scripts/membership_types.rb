# rails c 
# load './db/scripts/membership_types.rb'

MembershipType.create name: "test_type1", price: 500, recurring: false
MembershipType.create name: "test_type2", price: 1000, recurring: true
MembershipType.create name: "test_type3", price: 2000, recurring: false
