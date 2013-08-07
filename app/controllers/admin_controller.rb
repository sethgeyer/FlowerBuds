class AdminController < ApplicationController
use Rack::Session::Cookie, secret: SecureRandom.hex 


######### FLORISTS

### GET Handler for link on homegage.erb  
  def florists
    if Florist.where(id: session["found_florist_id"]).first.company_id == "centerpiece"
      @florists = Florist.order("status", "name")
      render(:florists) and return    
    else
      redirect_to "/login" and return
    end
  end

### POST Handler from florists.erb
  def florists_post
    if params["new"] 
      redirect_to "/florists/new" and return
    else
      redirect_to "/florists/#{params["edit"]}" and return
    end
  end

### GET Handler from florists_post function (see above)
  def florist
    if Florist.where(id: session["found_florist_id"]).first.company_id == "centerpiece"
      id = params["florist_id"]
      if id == "new"
        @florist = Florist.new
        @employee = Employee.new
      else
        @florist = Florist.where(id: id).first
        if @employee = Employee.where(florist_id: @florist.id).where(primary_poc: "yes").first != nil
          @employee = Employee.where(florist_id: @florist.id).where(primary_poc: "yes").first
        else
          @employee = Employee.new
        end
      end
      render(:florist_updates) and return
    else
      redirect_to "/" and return
    end
  end

### POST Handler for florist_updates.erb
  def florist_updates
    if params["florist_id"] == "new"
      @florist = Florist.new
      @employee = Employee.new      
    else
      @florist = Florist.where(id: params["florist_id"]).first
      if @employee = Employee.where(florist_id: @florist.id).where(primary_poc: "yes").first != nil
        @employee = Employee.where(florist_id: @florist.id).where(primary_poc: "yes").first
      else
        @employee = Employee.new
      end
    end
    @florist.name= params["name"]
    if @florist.company_id != "centerpiece"
      @florist.company_id = params["company_id"]
      @florist.status = params["status"]
    else
    end
    @florist.city = params["city"]
    @florist.state = params["state"]
    @florist.zip = params["zip"]
    
    @florist.updated_by = Employee.where(id: session["found_user_id"]).first.name
    if @florist.save &&  @florist.company_id != "centerpiece"
      @employee.florist_id = @florist.id
      @employee.name = params["primary_poc"]
      @employee.email = params["poc_email"]
      @employee.c_phone = params["poc_phone_c"]
      @employee.w_phone = params["poc_phone_w"]
      @employee.status = "Active"
      @employee.username = params["username"]
      @employee.admin_rights = params["admin_rights"]
      @employee.password = params["password"]
      @employee.password_confirmation = params["password_confirmation"]
      @employee.primary_poc = "yes"
      @employee.q_and_a = params["q_and_a"]
      @employee.view_pref = "all"
      @employee.save
      if @employee.save
        redirect_to "/florists/#{@florist.id}" and return
      else
        render(:florist_updates) and return
      end
    else
      render(:florist_updates) and return
    end    
  end
  
end