class AlbumsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :new, :update, :edit, :destroy]
  before_filter :find_user
  before_filter :find_album, only: [:edit, :update, :destroy]
  before_filter :add_breadcrumbs
  before_filter :ensure_proper_user, only: [:edit, :new, :create, :update, :destroy]


  # GET /albums
  # GET /albums.json
  def index
    @albums = @user.albums.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    redirect_to album_pictures_path(params[:id])
  end

  # GET /albums/new
  # GET /albums/new.json
  def new
    @album = current_user.albums.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/1/edit
  def edit
    add_breadcrumb "Editing Album"
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = current_user.albums.new(params[:album])

    respond_to do |format|
      if @album.save
        current_user.create_activity @album, 'created'
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render json: @album, status: :created, location: @album }
      else
        format.html { render action: "new" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update_attributes(params[:album])
        current_user.create_activity @album, 'updated'
        format.html { redirect_to album_pictures_path(@album), notice: 'Album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    current_user.create_activity @album, 'deleted'
    
    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end

  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end

  private
  def ensure_proper_user
    if current_user != @user
      flash[:error] = "You don't have permission to do that."
      redirect_to albums_path
    end
  end

  def add_breadcrumbs
    add_breadcrumb @user, profile_path(@user)
    add_breadcrumb "Albums", albums_path
  end

  def find_user
    @user = User.find_by_profile_name(params[:profile_name])
  end

  def find_album
    @album = current_user.albums.find(params[:id])
  end
end
