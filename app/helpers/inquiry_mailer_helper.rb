module InquiryMailerHelper
  def get_shop(inquiry)
    case inquiry.shop_choice
      when 'InPremise' then  " an in-premise setup with stock swap"
      when 'NoInPremise' then " no in-premise setup, but periodic delivery at office"
      when 'CorpPlan' then " a special corporate plans"
    end
  end
  def get_access(inquiry)
    case inquiry.access_points
      when 'All' then  "The members signing up at the corporate want to have access to other libraries of JustBooks"
      when 'Restricted' then "The members signing up at the corporate would have a restricted access to only a corporate membership"
    end
  end
  
    def get_pay(inquiry)
    case inquiry.pay_options
      when 'Member' then  "the members paying for the service"
      when 'Corporate' then "the corporate paying for the service"
    end
  end
  
    
  
end
