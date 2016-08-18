json.array!(@job_postings) do |job_posting|
  json.extract! job_posting, :id, :description, :user_id, :title, :expiry, :requirements
  json.url job_posting_url(job_posting, format: :json)
end
