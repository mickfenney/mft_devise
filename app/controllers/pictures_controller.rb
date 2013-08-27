class PicturesController < ApplicationController

  load_and_authorize_resource
  
  def new
    @picture = Picture.new(:gallery_id => params[:gallery_id])
  end

  def create
    @picture = Picture.new(params[:picture])
    @picture.user_id = current_user.id
    if @picture.save
      flash[:notice] = "Successfully created picture."
      redirect_to @picture.gallery
    else
      render :action => 'new'
    end
  end

  def edit
    @picture = Picture.find(params[:id])
  end

  def update
    @picture = Picture.find(params[:id])
    if @picture.update_attributes(params[:picture])
      flash[:notice] = "Successfully updated picture."
      redirect_to @picture.gallery
    else
      render :action => 'edit'
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    flash[:notice] = "Successfully destroyed picture."
    redirect_to @picture.gallery
  end
end
