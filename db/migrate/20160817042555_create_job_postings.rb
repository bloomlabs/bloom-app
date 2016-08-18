class CreateJobPostings < ActiveRecord::Migration
  def change
    create_table :job_postings do |t|
      t.string :description
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.date :expiry
      t.string :requirements

      t.timestamps null: false
    end
  end
end
