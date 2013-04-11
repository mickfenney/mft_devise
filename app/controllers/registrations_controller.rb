class RegistrationsController < Devise::RegistrationsController

  def new
    @page_title = 'Sign up'
  	super
  end

  def edit
    @page_title = 'Edit User'
  	super
  end

end
