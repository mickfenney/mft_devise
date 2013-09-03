require 'spec_helper'

describe VideosController do

  # This should return the minimal set of attributes required to create a valid
  # Video. As you add validations to Video, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "text", "code" => "12345678", "description" => "MyString", "user_id" => 1 } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VideosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET show" do
    it "assigns the requested video as @video" do
      video = Video.create! valid_attributes
      get :show, {:id => video.to_param}, valid_session
      assigns(:video).should eq(video)
    end
  end

  describe "GET new" do
    it "assigns a new video as @video" do
      get :new, {}, valid_session
      assigns(:video).should be_a_new(Video)
    end
  end

  describe "GET edit" do
    it "assigns the requested video as @video" do
      video = Video.create! valid_attributes
      get :edit, {:id => video.to_param}, valid_session
      assigns(:video).should eq(video)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested video as @video" do
        video = Video.create! valid_attributes
        put :update, {:id => video.to_param, :video => valid_attributes}, valid_session
        assigns(:video).should eq(video)
      end
    end
    describe "with invalid params" do
      it "assigns the video as @video" do
        video = Video.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Video.any_instance.stub(:save).and_return(false)
        put :update, {:id => video.to_param, :video => { "name" => "invalid value" }}, valid_session
        assigns(:video).should eq(video)
      end
    end  
  end

end