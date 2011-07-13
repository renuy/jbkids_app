class Plan < ActiveRecord::Base
  WAIVER_PLAN = 26
  has_and_belongs_to_many :branches
  has_and_belongs_to_many :coupons

  belongs_to :new_plan, :foreign_key => "new_plan_id", :class_name => "Plan"
  def renewable?
    (self.allow_renewal.upcase.eql?('NO') or self.allow_renewal.upcase.eql?('BUL')  or self.frequency.upcase.eql?("N") or  self.expired? or self.id == WAIVER_PLAN) ? false : true
  end
  
  def auto_changeable?
    (self.renewable?  or self.new_plan_id.nil? or self.id == WAIVER_PLAN) ? false : true
  end
  
  def expired?
    (!self.expiry_date.nil? and  self.expiry_date < Time.zone.today )? true : false
  end

  def renewMonthsArr
    renew_for =[]
    
    if !self.renewable? 
      return renew_for
    end
    
    case
      when self.frequency.upcase.eql?("M")
        if self.allow_renewal.upcase.eql?('YES') 
          renew_for << 1
          renew_for << 3
        end
        renew_for << 6
        renew_for << 12
      when self.frequency.upcase.eql?("H")
        renew_for << 6
        renew_for << 12
      when self.frequency.upcase.eql?("Y")
        renew_for << 12
        renew_for << 24
    end
    
    return renew_for
  end
  
  def renewAmount(months)
    renew_amount = 0
    if self.renewable?
        case
          when self.frequency.upcase.eql?('Y')
            case months
              when 12
                renew_amount = self.read_fee
              when 24
                renew_amount = self.read_fee * 2
            end
          when self.frequency.upcase.eql?('M')
            multiplier_months = months
            case months
              when 6
                multiplier_months = 5
              when 7
                multiplier_months = 6
              when 8
                multiplier_months = 7
              when 9
                multiplier_months = 8
              when 10
                multiplier_months = 9
              when 11
                multiplier_months = 10
              when 12
                multiplier_months = 10
              when 24
                multiplier_months = 22
            end
            renew_amount = self.read_fee * multiplier_months
            
          when self.frequency.upcase.eql?('H')
            case months
              when 6
                renew_amount = self.read_fee
              when 12
                renew_amount = self.read_fee * 2
              when 18
                renew_amount = self.read_fee * 3
              when 24
                renew_amount = self.read_fee * 4
            end
        end
    end
    
    return renew_amount
  end
  
  def ppb_books()
    books_cnt = []
    if self.frequency.upcase.eql?("N")
      books_cnt << 1
      books_cnt << 2
      books_cnt << 3
      books_cnt << 4
    end
    
    return books_cnt
  end
  
  def ppb_amount(books_cnt)
    amount = 0
    if self.frequency.upcase.eql?("N")
      amount = (self.sec_dep + self.read_fee) * books_cnt
    end
    return amount
  end
  def ppb_sec_dep(books_cnt)
    amount = 0
    if self.frequency.upcase.eql?("N")
      amount = (self.sec_dep ) * books_cnt
    end
    return amount
  end
  
  def ppb_read_fee(books_cnt)
    amount = 0
    if self.frequency.upcase.eql?("N")
      amount = (self.read_fee) * books_cnt
    end
    return amount
  end
  
  def monthly_amount
    if self.subscription 
      self.renewAmount(self.renewMonthsArr[0])
    else
      self.ppb_read_fee(1)
    end
  end

  
  def subscription
    self.frequency.upcase.eql?("N") ? false : true
  end
  
  def isCorporate?
    self.plan_type.upcase.eql?("C") ? true : false
  end
  
  def hasDiscount?(branch_id)
    self.discount_coupon(branch_id).nil? ? false : true
  end
  
  def discount(branch_id)
    coupon = self.discount_coupon(branch_id)
    coupon.nil? ? 0 : coupon.discount
  end
  
  def discount_coupon(branch_id)
    branch = Branch.find(branch_id)
    coupons = branch.coupons.find(:all, :conditions=>["amount=0 AND discount>0 AND expiry_date>=sysdate and start_date<=sysdate"])&self.coupons.find(:all, :conditions=>["amount=0 AND discount>0 AND expiry_date>=sysdate and start_date<=sysdate"])
    if coupons.size > 0
      coupons[0] 
    else
      nil
    end
  end
end
