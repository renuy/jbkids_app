class InquiryMailer < ActionMailer::Base
  default :from => "mc@strataretail.co"
  default :reply_to => "mc@justbooksclc.com"
  def inquiry_confirmation(inquiry)
    @url = 'http://www.justbooksclc.com'
    @inquiry = inquiry
    mail(:to => inquiry.email, :subject => "JustBooks : Corporate Enquiry", :cc=>'manager@justbooksclc.com')    
  end

end
