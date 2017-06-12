
class Api::V1::GalleriesController < Api::V1::ApiController
	before_action :authenticate_user!
 
# Gallery show APi
#   Url : http://maropost.dev:3000/api/v1/gallery/181?user_token=9ejBcmTxy-EsxRynAPh1
#   type : get
#   Parameters: none 

  def record
    if params[:id].to_i == 0
        render :xml=>{:code=> 500, :status=>"Failure", :message=>"Id should be numeric"}
    else
      if params[:id].nil?
        render :xml=>{:code=> 500, :status=>"Failure", :message=>"Id not exist in url ? Please append record id in url."}
      else
        @gallery = current_user.galleries.find(params[:id]) rescue nil
        if @gallery.present?
          render :xml=>{:code=> 200, :status=>"Success", :message=>"Record found.", :data => {name: @gallery.try(:title), image_url: @gallery.try(:image).try(:url)}  }
        else
          render :xml=>{:code=> 500, :status=>"Failure", :message=>"Record not exits."}
        end
      end
    end
  end

# Gallery create APi
#   Url : http://maropost.dev:3000/api/v1/gallery_create?user_token=9ejBcmTxy-EsxRynAPh1
#   type : post
#   Parameters: { "title":"ashish", "image":"https://store.storeimages.cdn-apple.com/4974/as-images.apple.com/is/image/AppleInc/aos/published/images/M/AC/MACBOOKPRO/MACBOOKPRO?wid=1200&hei=630&fmt=jpeg&qlt=95&op_sharpen=0&resMode=bicub&op_usm=0.5,0.5,0,0&iccEmbed=0&layer=comp&.v=6xyk9367"}

  def create
    if ((params[:title].nil? || params[:title] == "") || (params[:image].nil? || params[:image] == "") ) 
    render :xml=>{:code=> 500, :status=>"Failure", :message=>"Fields can't be blank !"}
    else
      gallery = Gallery.find_by_title(params[:title].downcase)
      if (gallery.try(:title) != params[:title].downcase) && (gallery.try(:user).try(:id) != current_user.try(:id))
  	  	@gallery = Gallery.new(title: params[:title].downcase) 
        @gallery.remote_image_url = params[:image]
        @gallery.user_id = current_user.id
        if @gallery.save
        	render :xml=>{ :code=>200, :status=>"Success", :message=>"Gallery Created.", :data =>{name: @gallery.try(:title),  Image_URL: @gallery.try(:image).try(:url)}}
          else
        	render :xml=>{ :code=>500,  :status=>"Failure", :message=>"Something went wrong" }
        end
      else
        render :xml=>{ :code=>500,  :status=>"Failure", :message=>"Record exist." }
      end
    end
  end


 
end