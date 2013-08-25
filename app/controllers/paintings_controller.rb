class PaintingsController < ApplicationController

  load_and_authorize_resource
  
  def new
    @painting = Painting.new(:gallery_id => params[:gallery_id])
  end

  def create
    @painting = Painting.new(params[:painting])
    @painting.user_id = current_user.id
    if @painting.save
      flash[:notice] = "Successfully created picture."
      redirect_to @painting.gallery
    else
      render :action => 'new'
    end
  end

  def edit
    @painting = Painting.find(params[:id])
  end

  def update
    @painting = Painting.find(params[:id])
    if @painting.update_attributes(params[:painting])
      flash[:notice] = "Successfully updated picture."
      redirect_to @painting.gallery
    else
      render :action => 'edit'
    end
  end

  def destroy
    @painting = Painting.find(params[:id])
    @painting.destroy
    flash[:notice] = "Successfully destroyed picture."
    redirect_to @painting.gallery
  end
end
