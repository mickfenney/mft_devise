require 'spec_helper'

describe PicturesController, :vcr do

  # This should return the minimal set of attributes required to create a valid
  # Picture. As you add validations to Picture, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "text", "remote_image_url" => "https://www.google.com.au/images/srpr/logo4w.png", "gallery_id" => 1, "user_id" => 1 } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PicturesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  # describe "GET show" do
  #   it "assigns the requested picture as @picture" do
  #     picture = Picture.create! valid_attributes
  #     get :show, {:id => picture.to_param}, valid_session
  #     assigns(:picture).should eq(picture)
  #   end
  # end

  describe "GET new" do
    it "assigns a new picture as @picture" do
      get :new, {}, valid_session
      assigns(:picture).should be_a_new(Picture)
    end
  end

  describe "GET edit" do
    it "assigns the requested picture as @picture" do
      picture = Picture.create! valid_attributes
      get :edit, {:id => picture.to_param}, valid_session
      assigns(:picture).should eq(picture)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested picture as @picture" do
        picture = Picture.create! valid_attributes
        put :update, {:id => picture.to_param, :picture => valid_attributes}, valid_session
        assigns(:picture).should eq(picture)
      end
    end
    describe "with invalid params" do
      it "assigns the picture as @picture" do
        picture = Picture.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Picture.any_instance.stub(:save).and_return(false)
        put :update, {:id => picture.to_param, :picture => { "name" => "invalid value" }}, valid_session
        assigns(:picture).should eq(picture)
      end
    end  
  end

end