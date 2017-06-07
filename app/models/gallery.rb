class Gallery < ApplicationRecord
	mount_uploader :image, AvatarUploader
	belongs_to :user

	 # Import spread and csv file
   def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = find_by_id(row["id"]) || new
      product.attributes = row.to_hash.slice(*row.to_hash.keys)
      product.save!
      product.update(image: File.open("#{Rails.root}/public/#{row['image']}", 'rb'))
    end
  end

 

   def self.open_spreadsheet(file)
       # xlsx = Roo::Excelx.new(file.path)
      case File.extname(file.original_filename)
       when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
     end
   end

 # Download or export CSV and Spreadsheet
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |gallery|
        csv << [gallery.id,gallery.title, gallery.image.url, gallery.user.id, gallery.created_at, gallery.updated_at]
      end
    end
  end

  
end
