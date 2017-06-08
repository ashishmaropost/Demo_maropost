class GalleriesController < ApplicationController
  before_action :set_gallery, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /galleries
  # GET /galleries.json
  def index
    @galleries = current_user.galleries.page(params[:page]).per(12)
    respond_to do |format|
      format.html
      #Download or export csv and spreadsheet
      format.csv { send_data @galleries.to_csv }
      format.xls { send_data @galleries.to_csv(col_sep: "\t") }
    end
  end

  # GET /galleries/1
  # GET /galleries/1.json
  def show
  end

  # GET /galleries/new
  def new
    @gallery = Gallery.new
  end

  # GET /galleries/1/edit
  def edit
  end

  # POST /galleries
  # POST /galleries.json
  def create 
    if params[:gallery][:title].present? && params[:gallery][:image].present?
      @gal_title = Gallery.find_by_title(params[:gallery][:title])
      @img = @gal_title.try(:image).try(:url).split("#{@gal_title.try(:id)}/").last rescue nil
      @gal_user_id = @gal_title.try(:user).try(:id)
      if ((@gal_title.try(:title) == params[:gallery][:title]) && (@img == params[:gallery][:image].original_filename) && (current_user.try(:id) == @gal_user_id))
         flash[:danger] = "Record already exits."
      else
        @gallery = Gallery.new(gallery_params)
        @gallery.user_id = current_user.id
      end
    end
    if !@gallery.nil?
      respond_to do |format|
        if @gallery.save!
          format.html { redirect_to '/galleries', notice: 'Gallery was successfully created.' }
          format.json { render :show, status: :created, location: @gallery }
        else
          format.html { render :new }
          format.json { render json: @gallery.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to '/galleries/new'
    end

  end

  # PATCH/PUT /galleries/1
  # PATCH/PUT /galleries/1.json
  def update
    respond_to do |format|
      if @gallery.update(gallery_params)
        format.html { redirect_to @gallery, notice: 'Gallery was successfully updated.' }
        format.json { render :show, status: :ok, location: @gallery }
      else
        format.html { render :edit }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.json
  def destroy
    @gallery.destroy
    respond_to do |format|
      format.html { redirect_to galleries_url, notice: 'Gallery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_profile_image
    if params[:avatar].present?
      @gallery = Gallery.find(params[:gallery_id])
      @img_name = params[:avatar].original_filename 
      @origin_img = @gallery.try(:image).try(:url).split("#{@gallery.try(:id)}/").last rescue nil
      if @img_name == @origin_img
        flash[:danger]= "Image was already exits."
      else
        @gallery.image = params[:avatar]
        @gallery.save
        flash[:notice]= "image updated successfully"
      end
    elsif params[:title].present?
      @gallery = Gallery.find(params[:gallery_id])
      @gallery.title = params[:title]
      @gallery.save
      flash[:notice]= "title updated successfully"
    end
    respond_to do |format|
      format.html { redirect_to galleries_url }
    end
  end

   def import
    Gallery.import(params[:file],current_user)
    redirect_to '/galleries', notice: "Gallery imported."
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gallery
      @gallery = Gallery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gallery_params
      params.require(:gallery).permit(:title, :image, :user_id)
    end
end
