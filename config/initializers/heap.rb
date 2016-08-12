if Rails.env.production?
  Heap.app_id = '4070855641'
else
  Heap.app_id = '3186370438'
end