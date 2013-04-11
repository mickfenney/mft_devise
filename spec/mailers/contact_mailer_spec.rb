require "spec_helper"

describe ContactMailer do

  describe "send_contact_message" do
    let(:mail) { ContactMailer.send_contact_message }

    # it "renders the headers" do
    #   send_to ENV["ADMIN_EMAIL"]
    #   mail.subject.should eq("Send contact message")
    #   mail.to.should eq(send_to)
    #   mail.from.should eq(["from@example.com"])
    # end

    # it "renders the body" do
    #   mail.body.encoded.should match("This is a test message for mfTechnology")
    # end
  end

end
