class UserProfile < ActiveRecord::Base
  has_paper_trail
  belongs_to :user

  def name
    "#{user.name} @ #{created_at}"
  end

  rails_admin do
    list do
      sort_by :user
      field :user do
        sortable :firstname, :lastname
      end
      field :created_at
    end
    show do
      field :user
      field :created_at
      field :telephone_number
      field :signup_reason
      field :date_of_birth
      field :gender
      field :education_status
      field :university
      field :university_degree
      field :university_student_number
      field :nationality
      field :created_at
    end
  end
end
