class MainController < ApplicationController
use Rack::Session::Cookie, secret: SecureRandom.hex 

######### SESSION SECURITY

  OPEN_PAGES = ["/", "/login", "/logout", "/about_us", "/marketing"]
  before_filter do
    if !OPEN_PAGES.include?(request.path_info) && session["found_florist_id"] == nil && session["found_user_id"] == nil
      render(:login, layout:false) and return
    elsif !OPEN_PAGES.include?(request.path_info) && ((Employee.where(id: session["found_user_id"]).first.status == "Inactive" || Employee.where(id: session["found_user_id"]).first.admin_rights == "None") || Florist.where(id: session["found_florist_id"]).first.status == "Inactive")
      render(:login, layout:false) and return
    end 
  end

=begin     ** More appropriate Rails convention; however, struggling to get this to work like "OPEN PAGES"
  before_filter(except: ["/", "/login", "/logout", "/about_us"]) do
    if session["found_florist_id"] == nil && session["found_user_id"] == nil
      render(:login, layout:false) and return
    elsif Employee.where(id: session["found_user_id"]).first.status == "Inactive" || Florist.where(id: session["found_florist_id"]).first.status == "Inactive"
     render(:login, layout:false) and return
    end
  end
=end



######### PAGE_VIEW_PERMISSIONS & OTHER CONSTANTS
  ADMIN_RIGHTS = ["None", "User", "Product Edit Rights", "All Admin Rights"]
  EMPLOYEES_VIEW_MUST_HAVE = ["All Admin Rights"]
  PRODUCT_UPDATE_MUST_HAVE = ["All Admin Rights", "Product Edit Rights"]
  SETUP_UPDATE_MUST_HAVE = ["All Admin Rights"]
  DEFAULT_QUOTE_LANGUAGE = "I agree to the terms and conditions of the contract.  This quote once executed will serve as my order form. 
    \n\n\n Customer Name: ___________________________
    \n\n\n Signature: ______________________ 
    \n\n\n Date:  __________________________"

######### WEBPAGE aka: the landing page for someone searching for centerpiece on the internet

### GET handler from "/"
  def webpage
    render(:webpage, layout:false) and return
  end



######### MARKETING - This will contain the marketing fluff for the landing page.

### GET handler from the links on webpage.erb
  def marketing
    render(:marketing_data, layout:false) and return
  end



######### LOGIN

### GET handler from link on webpage.erb
  def login
    render(:login, layout:false) and return    
  end

### POST handler from login.erb
  def logged_in
    found_florist = Florist.where(status: "Active").where(company_id: params["company_id"]).first    
    if found_florist != nil
      found_user = Employee.where(status: "Active").where(florist_id: found_florist.id).where(username: params["username"]).first
      if found_user && found_user.authenticate(params["password"])
        session["found_user_id"] = found_user.id
        session["found_florist_id"] = found_florist.id
        redirect_to home_path and return
      else # do nothing
      end
    end
    render(:login, layout:false) and return
  end
  
 
 
############ ABOUT US


### Get handler from link on webpage.erb
 def about_us
  render(:about_us, layout:false) and return
 end 
  
  

######### DISPLAY HOMEPAGE - This is the logged in users homepage.  Different than the landing page (aka: webpage.erb)
  def home
    if Employee.where(id: session["found_user_id"]).first.status == "Inactive" || Florist.where(id: session["found_florist_id"]).first.status == "Inactive"
      redirect_to "/login" and return
    else # do nothing
    end  
    if Employee.where(id: session["found_user_id"]).first.view_pref == "all" ||
      Employee.where(florist_id: session["found_florist_id"]).where(username: Employee.where(id: session["found_user_id"]).first.view_pref).first  == nil
      @events = Event.where(florist_id: session["found_florist_id"]).where("event_status not like 'Lost'").where("event_status not like 'Completed'").order("date_of_event").paginate(:page => params[:page], :per_page => 25)
    else
      view_pref = Employee.where(id: session["found_user_id"]).first.view_pref
      employee_id = Employee.where(florist_id: session["found_florist_id"]).where(username: view_pref).first.id
      @events = Event.where(florist_id: session["found_florist_id"]).where(employee_id: employee_id).where("event_status not like 'Lost'").where("event_status not like 'Completed'").order("date_of_event").paginate(:page => params[:page], :per_page => 25)
    end
    @view_prefs = ["all"] + Employee.where(florist_id: session["found_florist_id"]).where(status: "Active").uniq.pluck(:username)
    render(:homepage) and return
  end
  
######### SETUP

### GET Handler for SETUP on navigation bar
  def setup
      @SETUP_UPDATE_MUST_HAVE = SETUP_UPDATE_MUST_HAVE
      @florist = Florist.where(id: session["found_florist_id"]).first
      @default_quote_language = DEFAULT_QUOTE_LANGUAGE
      render(:setup) and return
  end  

### POST Handler from SETUP
  def setup_update
    if params["save"]
    update_florist = Florist.where(id: session["found_florist_id"]).first
    update_florist.quote_language = params["quote_language"]
    update_florist.quote_style_pref = params["quote_style"]
    update_florist.show_product_image_pref = params["show_product_image_pref"]
    update_florist.save
    
    else # do nothing
    end
    redirect_to "/setup" and return
  end

######### BUTTONS ON HOMEPAGE

### POST handler for buttons on homepage.erb (admittedly, a poorly named function for what its actually doing)
  def homepage
    if params["search"] #if they push the customer search button
      if params["search_field"] != ""
        customer = params["search_field"].gsub(" ", "_")
      else
        customer = "add_new_customer"
      end
      redirect_to "/search/#{customer}" and return
    elsif params["florists_access"]
      redirect_to "/florists" and return
    elsif params["plans_access"]
      redirect_to "/plans" and return
    elsif params["update_view"]
      emp_update = Employee.where(id: session["found_user_id"]).first
      emp_update.view_pref = params["view"]
      emp_update.save!
      redirect_to home_path and return
    elsif params["clear"]
        redirect_to home_path and return
    elsif params["date_range"]
      if params["beg_date"] == ""
        redirect_to home_path and return
      else
        @view_prefs = ["all"] + Employee.where(florist_id: session["found_florist_id"]).where(status: "Active").uniq.pluck(:username)
        @date = params["beg_date"]
        redirect_to "/home/#{@date}" and return
      end
    end
  end
  
  
  

### GET Handler from post above on the "beg_date search".  (Necessary because pagination doesn't work right w/ search criteria)
  def homepage_search_results
      if Employee.where(id: session["found_user_id"]).first.view_pref == "all" ||
          Employee.where(florist_id: session["found_florist_id"]).where(username: Employee.where(id: session["found_user_id"]).first.view_pref).first  == nil
          @events = Event.where(florist_id: session["found_florist_id"]).where("event_status not like 'Lost'").where("event_status not like 'Completed'").where("date_of_event" => params["beg_date"].."2099-08-23").order("date_of_event").paginate(:page => params[:page], :per_page => 25)
        else
          view_pref = Employee.where(id: session["found_user_id"]).first.view_pref
          employee_id = Employee.where(florist_id: session["found_florist_id"]).where(username: view_pref).first.id
          @events = Event.where(florist_id: session["found_florist_id"]).where(employee_id: employee_id).where("event_status not like 'Lost'").where("event_status not like 'Completed'").where("date_of_event" => params["beg_date"].."2099-08-23").order("date_of_event").paginate(:page => params[:page], :per_page => 25)
        end
        @view_prefs = ["all"] + Employee.where(florist_id: session["found_florist_id"]).where(status: "Active").uniq.pluck(:username)
        @date = params["beg_date"]
      render(:homepage_search_results) and return
  end 

  

### GET handler for logging out (in the header section)
  def logout
    session.clear
    render(:login, layout:false) and return
  end  
  
  
  
######### SEARCH RESULTS  

### POST handler for customer search on homepage.erb
  def search_results
    search_name = params["customer"]
    @customers = Customer.where(florist_id: session["found_florist_id"]).where("name ilike ?","%#{params["customer"]}%") 
    render(:search_results) and return
  end  


######### NEW CUSTOMER

### GET handler for link on search_results.erb
  def cust_new   
    @new_customer =Customer.new
    render(:cust_new) and return  
  end

###POST Handler from cust_new.erb 
  def create_new_customer   
    @new_customer = Customer.new
    @new_customer.name = params["new_contact_name"]
    @new_customer.email = params["contact_email"]
    @new_customer.florist_id = session["found_florist_id"]
    if @new_customer.save
      redirect_to "/cust_edit/#{@new_customer.id}" and return
    else
      render(:cust_new) and return
    end
  end


######### EDIT CUSTOMER

###GET Handler from links on cust_new.erb, search_results.erb, or homepage.erb
  def edit_customer          
      cust_id = params["customer_id"]
      @customer = Customer.where(florist_id: session["found_florist_id"]).where(id: cust_id).first
      render(:cust_edit) and return
  end
  
###POST Handler from cust_edit.erb  
  def cust_edit             
    cust_id = params["customer_id"]
    if params["save"]
      @customer = Customer.where(id: cust_id).first  #NEEDS TO BE TIED TO LOGIN INFO
      @customer.name = params["contact_name"]
      @customer.company_name = params["company_name"]
      @customer.phone1 = params["phone1"]
      @customer.phone2 = params["phone2"]
      @customer.email = params["contact_email"]
      @customer.groom_name = params["groom_name"]
      @customer.groom_phone = params["groom_phone"]
      @customer.groom_email = params["groom_email"]
      @customer.address = params["address"]
      @customer.city = params["city"]
      @customer.state = params["state"]
      @customer.zip = params["zip"]
      @customer.notes = params["notes"]
      if @customer.save
      else
        render(:cust_edit) and return
      end
    elsif params["delete"]
      event = Event.where(id: params["delete"]).first
      event.destroy
      for each in DesignedProduct.where(event_id: params["delete"])
        each.destroy
      end  
      for specification in Specification.where(event_id: params["delete"])
        specification.destroy
        for image in specification.images
          image.destroy
        end    
      end
      deleted_quote = Quote.where(event_id: params["delete"]).first
      if deleted_quote != nil
        deleted_quote.destroy
      else # do nothing
      end    
    end
    redirect_to "/cust_edit/#{cust_id}" and return
  end
  
######### EVENT NEW

### GET Handler link on cust_edit.erb
  def event_new
    cust_id = params["cust_id"]
    @customer = Customer.where(florist_id: session["found_florist_id"]).where(id: cust_id).first
    @event = Event.new
    @employee_list = [""] + Employee.where(florist_id: session["found_florist_id"]).where(status: "Active").uniq.pluck(:name)
    render(:event_new) and return
  end


### POST Handler from event_new.erb
  def create_new_event
    @event = Event.new
    @event.name = params["event_name"]
#   @event.random_number = rand(100000)
    @event.date_of_event = params["event_date"]
    @event.show_product_image =  Florist.find(session["found_florist_id"]).show_product_image_pref
    @event.show_display_name = 1
    if params["lead_designer"] != ""
      @event.employee_id = Employee.where(name: params["lead_designer"]).where(florist_id: session["found_florist_id"]).first.id                                                   
    else
      @event.employee_id = nil
    end
    @event.florist_id = session["found_florist_id"]                                                                        
    @event.customer_id = params["customer_id"]
    @event.event_status = "Open Proposal"
    if @event.save
      redirect_to "/event_edit/#{@event.id}" and return
    else
      @customer = Customer.where(id: params["customer_id"]).first
      @employee_list = [""] + Employee.where(florist_id: session["found_florist_id"]).where(status: "Active").uniq.pluck(:name)
      render(:event_new) and return
    end
  end



########## EDIT EVENT

###GET Handler from event_new.erb
  def event_edit
    event_id = params["event_id"]
    @event = Event.where(florist_id: session["found_florist_id"]).where(id: event_id).first
    @specifications = @event.specifications.where("item_name not like 'X1Z2-PlaCeHoldEr'").order("id")
    @employee_list = [Employee.where(florist_id: session["found_florist_id"]).where(status: "Active").where(primary_poc: "yes").uniq.pluck(:name)] + Employee.where(florist_id: session["found_florist_id"]).where(status: "Active").where("primary_poc is null").uniq.pluck(:name)
    render(:event_edit) and return
  end
  
###POST Handler from event_edit.erb
  def event_and_specs_edit
  #Updates to Event Section
    @event = Event.where(id: params["event_id"]).first
    @event.name = params["event_name"]
    @event.date_of_event = params["event_date"]
    @event.time = params["event_time"]
    @event.delivery_setup_time = params["setup_time"]
    @event.feel_of_day = params["feel_of_day"]
    @event.color_palette = params["color_palette"]
    @event.flower_types = params["flower_types"]
    @event.attire = params["attire"]
    @event.photographer = params["photographer"]
    @event.coordinator = params["coordinator"]
    @event.locations = params["locations"]
    @event.employee_id = Employee.where(name: params["lead_designer"]).where(florist_id: session["found_florist_id"]).first.id                                                   
    @event.notes = params["notes"]
    @event.other_notes = params["other_notes"]
    @event.budget = params["budget"]
    @event.quote_message = params["quote_message"]
    @event.customer_id = params["customer_id"]
    @event.show_display_name = params["display_name"]
    @event.show_product_image = params["show_product_image"]  
    if @event.save == false
      @employee_list = Employee.where(florist_id: session["found_florist_id"]).where(status: "Active").uniq.pluck(:name)
      @specifications = @event.specifications.where("item_name not like 'X1Z2-PlaCeHoldEr'").order("id")
      render(:event_edit) and return
    else # do nothing
    end
  #Updates to Event Specifications Section
    for each in Specification.where(event_id: params["event_id"]).where("item_name not like 'X1Z2-PlaCeHoldEr'")  
      each.item_name = params["spec_item-#{each.id}"]
      each.item_quantity = params["spec_qty-#{each.id}"].to_i * 100.0
      each.item_specs = params["spec_notes-#{each.id}"]
      each.exclude_from_quote = params["exclude-#{each.id}"]
      each.updated_by = Employee.where(florist_id: session["found_florist_id"]).where(id: session["found_user_id"]).first.username
      each.save      
    end
    if params["vs"]
     redirect_to "/vs_spec_update/#{params["vs"]}" and return
    
    elsif params["delete"]
      spec_id = params["delete"]
      spec = Specification.where(id: spec_id).first
      spec.destroy
      designed_products = DesignedProduct.where(specification_id: spec_id)
      for each in designed_products
        each.destroy
      end  
      for image in spec.images
        image.destroy
      end    
    elsif params["add"]
      # Create a "spec" placeholder for the list of products if one hasn't already been created.
      if Specification.where(event_id: params["event_id"]).where(item_name: "X1Z2-PlaCeHoldEr").first == nil
        new_spec = Specification.new
        new_spec.event_id = params["event_id"]
        new_spec.item_quantity = 100000
        new_spec.item_name = "X1Z2-PlaCeHoldEr"
        new_spec.florist_id = session["found_florist_id"]
        new_spec.exclude_from_quote = 1 
        new_spec.save!
      end
      new_spec = Specification.new
      new_spec.event_id = params["ev_id"]
      new_spec.item_quantity = 1 * 100.0
      new_spec.item_name = ""
      new_spec.updated_by = Employee.where(florist_id: session["found_florist_id"]).where(id: session["found_user_id"]).first.username
      new_spec.florist_id = session["found_florist_id"] 
      new_spec.save!
    elsif params["add_image"]
      redirect_to "/images/#{params["add_image"]}" and return
    else #do nothing
    end
      redirect_to "/event_edit/#{params["event_id"]}" and return
  end
  
######### ADD IMAGES TO SPECIFICATION
  def add_images
  @specification = Specification.where(florist_id: session["found_florist_id"]).where(id: params["specification_id"]).first 
  render(:images) and return
  end

  def upload
    upload = params[:file]
    image = Image.new
    image.data = upload.read
    image.content_type = upload.content_type
    image.extens = upload.original_filename.downcase.split(".").last
   
    if params["spec_id"] == "florist"
    image.image_type = "florist"
    image.florist_id =  params["fl_id"]
    image.save!
    respond_to do |format|
      format.html { redirect_to "/florists/#{params["fl_id"]}" and return }
      format.json { render :json => image.id and return }
    end
    
    elsif params["spec_id"] == "employee"
    image.image_type = "employee"
    image.employee_id = params["emp_id"]
    image.save!
    respond_to do |format|
      format.html { redirect_to "/employee/#{params["emp_id"]}" and return }
      format.json { render :json => image.id and return }
    end
    
    elsif params["spec_id"] == "product"
      image.image_type = "product"
      image.product_id = params["p_id"]
      product = Product.where(id: params["p_id"]).first
      product.updated_at = Time.now
      product.updated_by = Employee.where(id: session["found_user_id"]).first.name
      product.save!
      image.save!
      respond_to do |format|
        format.html { redirect_to "/product/#{params["p_id"]}" and return }
        format.json { render :json => image.id and return }
      end
    else
      image.specification_id = params["spec_id"]
      image.florist_id = session["found_florist_id"]
      image.save!
      respond_to do |format|
        format.html { redirect_to "/images/#{params["spec_id"]}" and return}
        format.json { render :json => image.id and return }
      end
    end
  end

  def image_data
    image = Image.find(params[:id])
    send_data image.data, type: image.content_type, disposition: "inline"
  end




  def update_image
    if params["delete"]
      deleted_image = Image.where(id: params["delete"]).first
      deleted_image.destroy
    else
      specification = Specification.where(id: params["spec_id"]).first
      for image in specification.images
      image.on_quote_cover = params["on_cover-#{image.id}"]
      image.display_name = params["display_name-#{image.id}"]
      image.save!
      end
      for designed_product in specification.designed_products
      designed_product.image_on_cover = params["on_cover-#{designed_product.id}"]
      designed_product.image_in_quote = params["in_quote-#{designed_product.id}"]
      designed_product.save!
      end
    end
    
    if params["spec_id"] == "florist"
    redirect_to "/florists/#{params["fl_id"]}" and return
    elsif params["spec_id"] == "employee"
      redirect_to "/employee/#{params["emp_id"]}" and return
    elsif params["spec_id"] == "product"
      redirect_to "/product/#{params["p_id"]}" and return  
        else
    redirect_to "/images/#{params["spec_id"]}" and return
    end

  end

######### VIRTUAL STUDIO

###GET Handler from link on event_edit.erb
  def virtual_studio
    event_id = params["event_id"]    
    @event= Event.where(florist_id: session["found_florist_id"]).where(id: event_id).first  
    @specifications = @event.specifications.where("item_name not like 'X1Z2-PlaCeHoldEr'").order("id")
    if @specifications == []
      flash[:error] = "A. You need to create arrangements below before designing them in Virtual Studio."
      redirect_to "/event_edit/#{params["event_id"]}" and return     
    else
    end  
    
  #Creates a list of used products for the arrangement 
    @products = Product.joins(:designed_products).where("designed_products.florist_id" => session["found_florist_id"]).where("designed_products.event_id" => event_id).uniq
    @used_products = @products.order("name")
    @list_of_product_types = @products.uniq.pluck(:product_type).sort
    @list_of_product_ids = @products.uniq.pluck(:id)
    
=begin    
    used_products = []
    list_of_product_types = []
    list_of_product_ids = []
    
    for each in @products
      used_products << each.name
      list_of_product_types << each.product_type
      list_of_product_ids << each.id
    end
    
      @used_products = used_products.uniq.sort
      @list_of_product_types = list_of_product_types.uniq.sort
      @list_of_product_ids = list_of_product_ids.uniq.sort
=end
=begin
  #Creates a new designed_product for each arrangement for each product identified in the virtual studio
  #This addresses the issue associated with arrangements added at the end of the design process.
   for each in @products
      for specification in @specifications
          x = DesignedProduct.where(product_id: each.id).where(specification_id: specification.id).first
          if x == nil
            new_dp = DesignedProduct.new
            new_dp.specification_id = specification.id
            new_dp.product_id = id
            new_dp.event_id = @event.id
            new_dp.product_qty = 0
            new_dp.florist_id = session["found_florist_id"]
            new_dp.image_in_quote = 1
            #new_dp.product_type = Product.where(name: each).where(florist_id: session["found_florist_id"]).first.product_type
            new_dp.save!
          else
          end
      end
    end
=end

  #Generate dropdown list for adding new products to the Virtual Studio Page
    @products = Product.joins(:designed_products).where("designed_products.florist_id" => session["found_florist_id"]).where("designed_products.event_id" => event_id).uniq
    products = Product.where(status: "Active").where(florist_id: session["found_florist_id"]).order("name")
    dropdown = []
    for product in products
      dropdown << product.name
    end
    for item in @products
      dropdown = dropdown - [item.name]
    end
    @dropdown = dropdown
    render(:virtual_studio) and return
  end

  
### POST Handler from virtual_studio.erb
  # Updates Virtual Studio Page based on updates made by user. 
  def virtual_studio_update
    event_id = params["event_id"] 
    # Create a DP for the product assigned to the placeholder specification.
    if params["add"]
      new_item = params["new_item"]
      specification = Specification.where(event_id: event_id).where(item_name: "X1Z2-PlaCeHoldEr").first
      new_dp = DesignedProduct.new
      new_dp.specification_id = specification.id
      new_dp.product_qty = 0
      new_dp.florist_id = session["found_florist_id"]
      new_dp.product_id = Product.where(name: new_item).where(florist_id: session["found_florist_id"]).first.id
      new_dp.event_id = event_id
      new_dp.image_in_quote = 1
      new_dp.save!         
      redirect_to "/virtual_studio/#{event_id}" and return
    
    elsif params["remove"]
      removed_product_id = params["remove"]
      removed_items = DesignedProduct.where(event_id: event_id).where(product_id: removed_product_id)
      for each_item in removed_items
        each_item.destroy
      end
      redirect_to "/virtual_studio/#{event_id}" and return

    elsif params["update"]
      spec_id = params["update"]
      redirect_to "/vs_spec_update/#{spec_id}" and return
    end
  end
  
  
### GET Handler from virtual studio.erb
  # Pulls counts for the specification identified.
  def vs_spec_update
    
    @spec = Specification.where(florist_id: session["found_florist_id"]).where(id: params["spec_id"]).first
    @products = Product.joins(:designed_products).where("designed_products.florist_id" => session["found_florist_id"]).where("designed_products.event_id" => @spec.event.id).uniq
    @used_products = @products.order("name")
    @list_of_product_types = @products.uniq.pluck(:product_type).sort
    @list_of_product_ids = @products.uniq.pluck(:id) 
    
    
    
    
  #Generate dropdown list for adding new products to the Virtual Studio Page
    products = Product.where(status: "Active").where(florist_id: session["found_florist_id"]).order("name")
    dropdown = []
    for product in products
      dropdown << product.name
    end
    for item in @products
      dropdown = dropdown - [item.name]
    end
    @dropdown = dropdown
    render (:vs_spec_update) and return
  end
  
### POST Handler from the vs_spec_update.erb
  # Processes the product.quantity counts for each individual arrangement.
  def vs_spec_save
    event_id = params["event_id"]
    products = Product.joins(:designed_products).where("designed_products.florist_id" => session["found_florist_id"]).where("designed_products.event_id" => event_id).uniq.order("name")
    for product in products 
      designed_product = DesignedProduct.where(product_id: product.id).where(specification_id: params["spec_id"]).first
      if designed_product != nil && params["stemcount_#{product.id}"].to_f > 0
        if params["stemcount_#{product.id}"].to_f * 100 != designed_product.product_qty
          designed_product.product_qty = params["stemcount_#{product.id}"].to_f * 100.round(2)
          designed_product.save!
        else # don't save
        end
      elsif designed_product != nil && params["stemcount_#{product.id}"].to_f <= 0
        designed_product.destroy
      elsif designed_product == nil && params["stemcount_#{product.id}"].to_f > 0
        new_dp = DesignedProduct.new
        new_dp.specification_id = params["spec_id"]
        new_dp.product_id = product.id
        new_dp.event_id = event_id
        new_dp.product_qty = params["stemcount_#{product.id}"].to_f * 100.round(2)
        new_dp.florist_id = session["found_florist_id"]
        new_dp.image_in_quote = 1
        new_dp.save!
      end
    end
    
  # Create a DP for the product assigned to the placeholder specification.
    if params["add"]
      new_item = params["new_item"]
      specification = Specification.where(event_id: event_id).where(item_name: "X1Z2-PlaCeHoldEr").first
      new_dp = DesignedProduct.new
      new_dp.specification_id = specification.id
      new_dp.product_qty = 0
      new_dp.florist_id = session["found_florist_id"]
      new_dp.product_id = Product.where(name: new_item).where(florist_id: session["found_florist_id"]).first.id
      new_dp.event_id = event_id
      new_dp.image_in_quote = 1
      new_dp.save!         
      redirect_to "/vs_spec_update/#{params["spec_id"]}" and return
    end
    
 
    if params["save"]
      redirect_to "/virtual_studio/#{event_id}" and return
    end
    specifications = Specification.where(florist_id: session["found_florist_id"]).where(event_id: params["event_id"]).where("item_name not like 'X1Z2-PlaCeHoldEr'").order("id")
    spec_list = []
    for specification in specifications
      spec_list << specification.id
    end
    last_items_index = spec_list.index(Specification.where(id: params["spec_id"]).first.id)
    if params["save_previous"]
      if last_items_index - 1 >= 0 
        @spec =  Specification.where(id: spec_list[last_items_index - 1]).first
        redirect_to "/vs_spec_update/#{@spec.id}" and return
      else
        redirect_to "/virtual_studio/#{event_id}" and return
      end
    elsif params["save_next"]
      if last_items_index + 1 < spec_list.size
        @spec =  Specification.where(id: spec_list[last_items_index + 1]).first
        
        redirect_to "/vs_spec_update/#{@spec.id}" and return
      else
        redirect_to "/virtual_studio/#{event_id}" and return
      end  
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
### GET Handler from link on virtual_studio.erb 
  def popup_specs
    event_id = params["event_id"]
    @event_id = event_id
    @specifications = Specification.where(florist_id: session["found_florist_id"]).where(event_id: event_id).where("item_name not like 'X1Z2-PlaCeHoldEr'").order("id")
    render(:popup_specs, layout:false) and return
  end 















=begin MASS UPDATE FOR VIRTUAL STUDIO
######### VIRTUAL STUDIO

###GET Handler from link on event_edit.erb
  def virtual_studio
    event_id = params["event_id"]    
    @event= Event.where(florist_id: session["found_florist_id"]).where(id: event_id).first  
    @specifications = @event.specifications.order("id")
    if @specifications == []
      flash[:error] = "A. You need to create arrangements below before designing them in Virtual Studio."
      redirect_to "/event_edit/#{params["event_id"]}" and return     
    else
    end  
    
  #Creates a list of used products for the arrangement 
    designedproducts = DesignedProduct.where(florist_id: session["found_florist_id"]).where(event_id: event_id)
    used_products = []
    for each in designedproducts
      used_products << each.product.name
    end
    @list_of_products = used_products.uniq.sort
    list_of_product_types = []
    for each in @list_of_products
    product = Product.where(florist_id: session["found_florist_id"]).where(name: each).first
    list_of_product_types << product.product_type
    end
    @list_of_product_types = list_of_product_types.uniq.sort
  #Creates a new designed_product for each arrangement for each product identified in the virtual studio
  #This addresses the issue associated with arrangements added at the end of the design process.
   for each in @list_of_products
      id = Product.where(name: each).where(florist_id: session["found_florist_id"]).first.id
      for specification in @specifications
          x = DesignedProduct.where(product_id: id).where(specification_id: specification.id).first
          if x == nil
            new_dp = DesignedProduct.new
            new_dp.specification_id = specification.id
            new_dp.product_id = id
            new_dp.event_id = @event.id
            new_dp.product_qty = 0
            new_dp.florist_id = session["found_florist_id"]
            new_dp.image_in_quote = 1
            #new_dp.product_type = Product.where(name: each).where(florist_id: session["found_florist_id"]).first.product_type
            new_dp.save!
          else
          end
      end
    end
  
  #Generate dropdown list for adding new products to the Virtual Studio Page
    products = Product.where(status: "Active").where(florist_id: session["found_florist_id"]).order("name")
    dropdown = []
    for product in products
      dropdown << product.name
    end
    for item in @list_of_products
      dropdown = dropdown - [item]
    end
    @dropdown = dropdown
    render(:virtual_studio) and return
  end

  
### POST Handler from virtual_studio.erb
  # Updates Virtual Studio Page based on updates made by user. 
  def virtual_studio_update
    event_id = params["event_id"]
    specifications = Specification.where(event_id: event_id).order("id")
    designedproducts = DesignedProduct.where(event_id: event_id)
    for each in designedproducts
      for specification in specifications
        if params["stemcount_#{each.id}"].to_f*100 != each.product_qty
          each.product_qty = params["stemcount_#{each.id}"].to_f * 100.round(2)
          each.save!
        end
      end
    end  
    
    if params["add"]
      new_item = params["new_item"]
      specifications = Specification.where(event_id: event_id)
      for specification in specifications
        new_dp = DesignedProduct.new
        new_dp.specification_id = specification.id
        new_dp.product_qty = 0
        new_dp.florist_id = session["found_florist_id"]
        new_dp.product_id = Product.where(name: new_item).where(florist_id: session["found_florist_id"]).first.id
        new_dp.event_id = event_id
        new_dp.image_in_quote = 1
        new_dp.save!
      end         
    elsif params["remove"]
      removed_product_id = params["remove"]
      removed_items = DesignedProduct.where(event_id: event_id).where(product_id: removed_product_id)
      for each_item in removed_items
        each_item.destroy
      end
    else # do nothing
    end
      redirect_to "/virtual_studio/#{event_id}" and return
  end
  
  
### GET Handler from link on virtual_studio.erb 
  def popup_specs
    event_id = params["event_id"]
    @event_id = event_id
    @specifications = Specification.where(florist_id: session["found_florist_id"]).where(event_id: event_id).order("id")
    render(:popup_specs, layout:false) and return
  end 
=end  
  
  
######### QUOTE GENERATION

### GET handler from event_edit.erb
  def quote_generation
    event_id = params["event_id"]
    @event = Event.where(florist_id: session["found_florist_id"]).where(id: event_id).first
    @specifications = @event.specifications.where(exclude_from_quote: nil).order("id")
    count = 0
    for each in DesignedProduct.where(florist_id: session["found_florist_id"]).where(event_id: event_id)
      count = count + (each.product_qty / 100.0)
    end
    if DesignedProduct.where(florist_id: session["found_florist_id"]).where(event_id: event_id).first == nil || count <= 0  
      flash[:error] = "B. You need to create arrangements below and then design them in the Virtual Studio before viewing the Quote or Design Day Details."
      redirect_to "/event_edit/#{params["event_id"]}" and return
    else # do nothing
    end
    if Quote.where(florist_id: session["found_florist_id"]).where(event_id: event_id).first == nil
      new_quote = Quote.new
      new_quote.quote_name = @event.name
      new_quote.event_id = event_id
      new_quote.status = "Open Proposal"
      new_quote.florist_id = session["found_florist_id"] 
      new_quote.total_price = 0
      new_quote.total_cost = 0
      if Florist.find(session["found_florist_id"]).quote_style_pref  == nil
        default_choice = 1
      else 
        default_choice = Florist.find(session["found_florist_id"]).quote_style_pref
      end
      new_quote.quote_style = default_choice
      new_quote.markup = 0
      new_quote.save!
      event = Event.where(florist_id: session["found_florist_id"]).where(id: event_id).first
      event.event_status = "Open Proposal"
      event.save!
    else # do nothing
    end
    @quote = Quote.where(florist_id: session["found_florist_id"]).where(event_id: event_id).first 
    
    render(:gen_quote) and return
  end

### POST handler from gen_quote.erb
  def save_quote
    event_id = params["event_id"]
    for each in Specification.where(event_id: event_id).where(exclude_from_quote: nil)
      if params["quoted_price-#{each.id}"] == nil
        each.quoted_price = 0
      else
        each.quoted_price = (params["quoted_price-#{each.id}"].gsub("," , "").to_f * 100).round(2)
      end
      items_cost = params["per_item_cost-#{each.id}"].to_f * 100.0
      each.per_item_cost = items_cost.round(2)
      each.per_item_list_price = (params["per_item_list_price-#{each.id}"].to_f * 100).round(2)
      each.extended_list_price = (params["extended_list_price-#{each.id}"].to_f * 100).round(2)
      each.save!
    end
    quote = Quote.where(event_id: event_id).first
    quote.quote_name = params["quote_name"]
    quote.quote_style = params["quote_style"]
    quoted_total_price = 0
    quoted_total_cost = 0
    for each in Specification.where(event_id: event_id).where(exclude_from_quote: nil)
      if each.quoted_price == nil
        each.quoted_price = 0
      else # do nothing
      end
      quoted_total_price = quoted_total_price + each.quoted_price
      quoted_total_cost = quoted_total_cost + (((each.per_item_cost / 100.0) * (each.item_quantity / 100.0)).round(2) * 100.0).round(2)
    end 
    quote.total_price = quoted_total_price
    quote.total_cost = quoted_total_cost
    if quoted_total_cost != 0
      quote.markup = (quoted_total_price / quoted_total_cost) * 100
    else # do nothing
    end
    quote.status = params["status"]
    if params["status"] != "Completed"  && params["status"] != "Ordered"
      quote.wholesale_order_date = nil
    else # do nothing
    end
    quote.save!
    event = Event.where(id: event_id).first
    event.event_status = params["status"]
    event.quote_message = params["quote_message"]
    event.save!
    redirect_to "/generate_quote/#{event_id}" and return
  end

### GET Handler from link on gen_quote.erb
  def generate_cust_facing_quote
    event_id = params["event_id"]
    @event = Event.where(id: event_id).where(florist_id: session["found_florist_id"]).first
    @specifications = @event.specifications.where(exclude_from_quote: nil).order("id")
    render("cust_facing_quote#{@event.quote.quote_style}", layout:false) and return
  end
  
  
  
######### WHOLESALE ORDERS & DESIGN DAY DETAILS

###GET Handler from link on homepage.erb
  def schedule_order_date
    @booked_quotes = Quote.where(florist_id: session["found_florist_id"]).where(status: "Ordered").where(wholesale_order_date: nil) + Quote.where(florist_id: session["found_florist_id"]).where(status: "Booked").where(wholesale_order_date: nil)
    render(:schedule_order_date) and return
  end
  
###POST Handler from schedule_order_date.erb
  def assign_order_date
    @booked_quotes = Quote.where(florist_id: session["found_florist_id"]).where(status: "Ordered").where(wholesale_order_date: nil) + Quote.where(florist_id: session["found_florist_id"]).where(status: "Booked").where(wholesale_order_date: nil)
    for booked_quote in @booked_quotes
      if params["place_order-#{booked_quote.id}"]
        booked_quote.status = "Ordered"
        #booked_quote.wholesale_order_date = Date.civil(params[:place_order_on]["element(1i)"].to_i, params[:place_order_on]["element(2i)"].to_i, params[:place_order_on]["element(3i)"].to_i)
        booked_quote.wholesale_order_date = params["place_order_on"]
        booked_quote.save!
      else
      end
    end
    redirect_to "/wholesale_order_list/#{params["place_order_on"]}" and return
  end

###GET Handler from schedule_order_date.erb
  #Creates a "grocery list" of all products, etc. that will need to be ordered from the wholesaler.
  def wholesale_order_list
    @orders = Quote.where(florist_id: session["found_florist_id"]).where(status: "Ordered").where(wholesale_order_date: params["place_order_on"])
    @list_of_event_ids = @orders.uniq.pluck(:event_id)
    list_of_product_ids = []
    list_of_product_types = []
    for each_id in @list_of_event_ids   
      for designed_product in DesignedProduct.where(event_id: each_id)
        list_of_product_ids << designed_product.product_id
        list_of_product_types << designed_product.product.product_type
      end
    end
    @list_of_product_ids = list_of_product_ids.uniq
    @list_of_product_types = list_of_product_types.uniq.sort
    render(:wholesale_order_list) and return
  end

  
####GET Handler from event_edit.erb
  #Creates an order details summary for the individual event (to be used on the day of the design work).
  def design_day_details
    @event = Event.where(florist_id: session["found_florist_id"]).where(id: params["event_id"]).first
    @specifications = @event.specifications.where(exclude_from_quote: nil).order("id")
    
    @products = Product.joins(:designed_products).where("designed_products.florist_id" => session["found_florist_id"]).where("designed_products.event_id" => params["event_id"]).uniq
    @used_products = @products.order("name")
    @list_of_product_types = @products.uniq.pluck(:product_type).sort
    @list_of_product_ids = @products.uniq.pluck(:id)     
    if DesignedProduct.where(florist_id: session["found_florist_id"]).where(event_id: params["event_id"]).first == nil # || count < 0.0
      flash[:error] = "C. You need to create arrangements below and then design them in the Virtual Studio before viewing the Quote or Design Day Details."
      redirect_to "/event_edit/#{params["event_id"]}" and return
    end
    if Quote.where(florist_id: session["found_florist_id"]).where(event_id: params["event_id"]).first == nil
      flash[:error] = "D. You need to create a Quote before viewing the Design Day Details."
      redirect_to "/event_edit/#{params["event_id"]}" and return
    end
    render(:design_day_details) and return
  end



######### PRODUCTS

### GET Handler from link in header
  def products
    @products = Product.where(florist_id: session["found_florist_id"]).order("status", "product_type", "name").paginate(:page => params[:page], :per_page => 25) 
    @PRODUCT_UPDATE_MUST_HAVE = PRODUCT_UPDATE_MUST_HAVE
    render(:products) and return
  end
   
 
 #______________________  
  
### GET Handler from link in vstudio for "popup gallery"
  def image_gallery
    @products = Product.where(florist_id: session["found_florist_id"]).where("product_type not like '4. Labor'").where(status: "Active").order("status", "product_type", "name").paginate(:page => params[:page], :per_page => 25) 
    render(:image_gallery, layout:false) and return
  end 
  
### POST Handler from image.gallery.erb
  def image_gallery_post
    if params["clear"]
      redirect_to "/image_gallery" and return
    else
      @name = params["search_field"].gsub(" ", "_")
      redirect_to "/image_gallery/#{@name}" and return
    end
  end


### GET Handler from post above on the "search".  (Necessary because pagination doesn't work right w/ search criteria)
  def image_gallery_search_results
      @name = params["search_field"]
      @products = Product.where(florist_id: session["found_florist_id"]).where("product_type not like '4. Labor'").where(status: "Active").where("name ilike ?", "%#{@name}%").order("status", "product_type", "name").paginate(:page => params[:page], :per_page => 25)
      render(:image_gallery_search_results, layout:false) and return
  end 

#_____________________
   

### POST Handler from products.erb
  def product_post
    if params["new"] 
      redirect_to "/product/new" and return
    elsif params["search"]
     # @products = Product.where(florist_id: session["found_florist_id"]).where("name ilike ?", "%#{params["search_field"]}%").order("status", "product_type", "name").paginate(:page => params[:page], :per_page => 25)
     # @PRODUCT_UPDATE_MUST_HAVE = PRODUCT_UPDATE_MUST_HAVE
      @name = params["search_field"].gsub(" ", "_")
      #render (:products) and return
      redirect_to "/products/#{@name}" and return
    elsif params["clear"]
    redirect_to "/products" and return
    else
      redirect_to "/product/#{params["edit"]}" and return
    end
  end
  
  
### GET Handler from post above on the "search".  (Necessary because pagination doesn't work right w/ search criteria)
  def products_search_results
    @name = params["search_field"]
    @products = Product.where(florist_id: session["found_florist_id"]).where("name ilike ?", "%#{@name}%").order("status", "product_type", "name").paginate(:page => params[:page], :per_page => 25)
    @PRODUCT_UPDATE_MUST_HAVE = PRODUCT_UPDATE_MUST_HAVE
    render(:products_search_results) and return
     # @name = params["search_field"]
     # @products = Product.where(florist_id: session["found_florist_id"]).where("product_type not like '4. Labor'").where(status: "Active").where("name ilike ?", "%#{@name}%").order("status", "product_type", "name").paginate(:page => params[:page], :per_page => 25)
     # render(:image_gallery_search) and return
  end 

### GET Handler from product_post function (above)
  def product
    if PRODUCT_UPDATE_MUST_HAVE.include?(Employee.where(id: session["found_user_id"]).first.admin_rights)
      id = params["product_id"]
      if id == "new"
        @product = Product.new
        @product.items_per_bunch = 100
        @product.markup = 100
      else
        @product = Product.where(florist_id: session["found_florist_id"]).where(id: id).first
      end
      render(:product_updates) and return
    else
      redirect_to "/products" and return
    end
  end

### POST Handler from new_product.erb
  def product_updates
    if params["product_id"] == "new"
      @product = Product.new
      @product.florist_id = session["found_florist_id"]      
    else
      @product = Product.where(id: params["product_id"]).first
    end
    @product.product_type= params["product_type"]
    @product.name = params["product_name"]
    if params["items_per_bunch"] && params["items_per_bunch"].to_f > 0
      @product.items_per_bunch = params["items_per_bunch"].to_f * 100
      if params["cost_per_bunch"] && params["cost_per_bunch"].to_f > 0
        @product.cost_per_bunch = params["cost_per_bunch"].to_f * 100.round(2)
        numerator = params["cost_per_bunch"].to_f * 100.0.round(2)
        denominator = params["items_per_bunch"].to_f * 100.0.round(2)
        
        @product.cost_for_one = (numerator / denominator).round(2)*100
      end
    end
    if params["markup"] && params["markup"].to_f >= 0   
      @product.markup = params["markup"].to_f * 100
    end
    @product.status = params["status"]
    if params["display_name"] == "" || params["display_name"] == nil
      @product.display_name = @product.name
    else
      @product.display_name = params["display_name"]
    end
    @product.updated_by = Employee.where(id: session["found_user_id"]).first.name
    @product.florist_id = session["found_florist_id"]
    if @product.save
      redirect_to "/product/#{@product.id}" and return
    else
      render(:product_updates) and return
    end    
  end



######### EMPLOYEES
### GET Handler from link in header
  def employees
    if EMPLOYEES_VIEW_MUST_HAVE.include?(Employee.where(id: session["found_user_id"]).first.admin_rights)
      @employees = Employee.where(florist_id: session["found_florist_id"]).order("primary_poc", "status",  "name")
      render(:employees) and return
    else
      redirect_to "/employee/#{session["found_user_id"]}" and return
    end
  end

### POST Handler from employees.erb
  def employee_post
    if params["new"] 
      redirect_to "/employee/new" and return
    else
      redirect_to "/employee/#{params["edit"]}" and return
    end
  end

### GET Handler from employee_post function above
  def employee
    if EMPLOYEES_VIEW_MUST_HAVE.include?(Employee.where(id: session["found_user_id"]).first.admin_rights)
      id = params["employee_id"]
    else
      id = session["found_user_id"]
    end
    @ADMIN_RIGHTS = ADMIN_RIGHTS
    @EMPLOYEES_VIEW_MUST_HAVE = EMPLOYEES_VIEW_MUST_HAVE 
    if id == "new"
      @employee = Employee.new
      @employee.view_pref = "all"
    else
      @employee = Employee.where(florist_id: session["found_florist_id"]).where(id: id).first
    end
    render(:employee_edit) and return
  end

### POST Handler from employee_updates.erb
  def employee_updates
    if params["employee_id"] == "new"
      @employee = Employee.new
      @employee.florist_id = session["found_florist_id"]
      @employee.view_pref = "all"
    else
      @employee = Employee.where(id: params["employee_id"]).first
    end
    @employee.name = params["name"]
    @employee.email = params["email"]
    @employee.w_phone = params["phone_w"]
    @employee.c_phone = params["phone_c"]
    @employee.username = params["username"]
    @employee.password = params["password"]        
    @employee.password_confirmation = params["password_confirmation"]
    # This step is done to keep the POC from inadvertantly changing their rights... the POC should always have "All Admin Rights"
    if @employee.primary_poc == "yes"
      @employee.admin_rights = "All Admin Rights"
      @employee.status = "Active"
    else
      @employee.status = params["status"]
      # if they are changing the "status" to Inactive, then go ahead and change the employees admin privielegs to "none".
      if params["status"] == "Inactive"
        @employee.admin_rights = "None"
      else
        # if they have room for more active users (per their plan) or they are past the number but the change is to change someone's privileges to "None, then let them set the userprivielegs.  Otherwise default to "None".  This will allow them to show up in the list but not access the system.
        if Florist.find(session["found_florist_id"]).employees.where(status: "Active").where("admin_rights not like 'None'").size < Florist.find(session["found_florist_id"]).plan.number_of_users || (Florist.find(session["found_florist_id"]).employees.where(status: "Active").where("admin_rights not like 'None'").size >= Florist.find(session["found_florist_id"]).plan.number_of_users  && params["admin_rights"] == "None")
          @employee.admin_rights = params["admin_rights"]
        else
          @employee.admin_rights = "None"
        end
      end
      
    end
    if @employee.save
      if EMPLOYEES_VIEW_MUST_HAVE.include?(Employee.where(id: session["found_user_id"]).first.admin_rights)
        redirect_to "/employees" and return
      else
        redirect_to home_path and return
      end
    else
    @ADMIN_RIGHTS = ADMIN_RIGHTS
    @EMPLOYEES_VIEW_MUST_HAVE = EMPLOYEES_VIEW_MUST_HAVE 
    render(:employee_edit) and return
    end
  end
end
