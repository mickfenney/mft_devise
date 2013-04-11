class InvitationsController < Devise::InvitationsController

  def new
    @page_title = 'Send Invitation'
  	super
  end

  def edit
    @page_title = 'Edit Invitation'
  	super
  end 

end
