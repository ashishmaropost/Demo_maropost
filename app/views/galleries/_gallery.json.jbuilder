json.extract! gallery, :id, :title, :image, :user_id, :created_at, :updated_at
json.url gallery_url(gallery, format: :json)
