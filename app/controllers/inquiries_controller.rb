class InquiriesController < ApplicationController
  before_filter :authenticate_user!, :only => [:destroy, :edit, :index, :show, :update]
  before_filter :authenticate_strata_user!, :only => [:destroy, :edit, :index, :show, :update]
  # GET /inquiries
  # GET /inquiries.xml
  def index
    
    @inquiries = Inquiry.all(:order => 'id desc').paginate(:page => params[:page], :per_page=>15)

    respond_to do |format|
      format.html { render 'index' }
      format.xml  { render :xml => @inquiries }
    end
  end

  # GET /inquiries/1
  # GET /inquiries/1.xml
  def show
    @inquiry = Inquiry.find(params[:id])

    respond_to do |format|
      format.html { render 'show'}
      format.xml  { render :xml => @inquiry }
    end
  end

  # GET /inquiries/new
  # GET /inquiries/new.xml
  def new
    @inquiry = Inquiry.new

    respond_to do |format|
      format.html { render 'new', :layout=>'corp'}# new.html.erb
      format.xml  { render :xml => @inquiry}
    end
  end

  # GET /inquiries/1/edit
  def edit
    @inquiry = Inquiry.find(params[:id])
    render 'edit' , :layout=>'corp'
  end

  # POST /inquiries
  # POST /inquiries.xml
  def create
    @inquiry = Inquiry.new(params[:inquiry])

    respond_to do |format|
      if @inquiry.save
        InquiryMailer.inquiry_confirmation(@inquiry).deliver
        format.html { redirect_to(new_inquiry_path, :notice => 'Inquiry was successfully created.') }
        format.xml  { render :xml => @inquiry, :status => :created, :location => @inquiry }
      else
        format.html { render :action => "new",:layout=>'corp' }
        format.xml  { render :xml => @inquiry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /inquiries/1
  # PUT /inquiries/1.xml
  def update
    @inquiry = Inquiry.find(params[:id])

    respond_to do |format|
      if @inquiry.update_attributes(params[:inquiry])
        format.html { redirect_to(@inquiry, :notice => 'Inquiry was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @inquiry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /inquiries/1
  # DELETE /inquiries/1.xml
  def destroy
    @inquiry = Inquiry.find(params[:id])
    @inquiry.destroy

    respond_to do |format|
      format.html { redirect_to(inquiries_url) }
      format.xml  { head :ok }
    end
  end
  
    def authenticate_strata_user!
    if  !current_user.strata_employee? 
      flash[:error] = "Not authorized to view or update"
      respond_to do |format|
        format.html {redirect_to root_path}# new.html.erb
        format.xml  
        
      end
    end
  end

end
