class PlansController < ApplicationController
  before_filter :authenticate_user!

  def index
    @branches = current_user.companies[0].branches
    if current_user.companies[0].branches.collect{|x| x.id}.include?(params[:b])
      @branch = Branch.find(params[:b].to_i)
    else 
      @branch = Branch.find(current_user.companies[0].branches[0])
    end
    
    @plans = @branch.plans.find(:all, :conditions => ['id NOT IN (23,24,26) AND UPPER(allow_renewal) = ? AND plan_type in (?)','YES',['B','N','C']], :order => ('plan_type, cnt_books, cnt_magazine')).paginate(:page=>params[:page],:per_page=>3)
    #@plans = Plan.all( :conditions => ['UPPER(public1) = ? AND UPPER(allow_renewal) = ? AND plan_type in (?)','YES','YES',['B','N','W','C']], :order => ('plan_type, cnt_books, cnt_magazine')) 
  end
end
