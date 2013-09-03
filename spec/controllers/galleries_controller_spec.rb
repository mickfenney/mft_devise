require 'spec_helper'

describe GalleriesController do

  # This should return the minimal set of attributes required to create a valid
  # Gallery. As you add validations to Gallery, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "text", "user_id" => 1 } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GalleriesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET show" do
    it "assigns the requested gallery as @gallery" do
      gallery = Gallery.create! valid_attributes
      get :show, {:id => gallery.to_param}, valid_session
      assigns(:gallery).should eq(gallery)
    end
  end

  describe "GET new" do
    it "assigns a new gallery as @gallery" do
      get :new, {}, valid_session
      assigns(:gallery).should be_a_new(Gallery)
    end
  end

  describe "GET edit" do
    it "assigns the requested gallery as @gallery" do
      gallery = Gallery.create! valid_attributes
      get :edit, {:id => gallery.to_param}, valid_session
      assigns(:gallery).should eq(gallery)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested gallery as @gallery" do
        gallery = Gallery.create! valid_attributes
        put :update, {:id => gallery.to_param, :gallery => valid_attributes}, valid_session
        assigns(:gallery).should eq(gallery)
      end
    end
    describe "with invalid params" do
      it "assigns the gallery as @gallery" do
        gallery = Gallery.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Gallery.any_instance.stub(:save).and_return(false)
        put :update, {:id => gallery.to_param, :gallery => { "name" => "invalid value" }}, valid_session
        assigns(:gallery).should eq(gallery)
      end
    end  
  end

end