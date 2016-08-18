class AddClosedToJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :closed, :boolean
  end
end
