class MainController < ApplicationController
use Rack::Session::Cookie, secret: SecureRandom.hex 

###

######### LOGIN
  def login
    render(:login) and return    
  end

  def logged_in
    found_florist = Florist.where(company_id: params["company_id"]).first
    if found_florist != nil
      found_user = Employee.where(username: params["username"]).where(florist_id: found_florist.id).first
      if found_user && params["password"] == found_user.password
        session["found_user_id"] = found_user.id
        session["found_florist_id"] = found_florist.id
        redirect_to "/home" and return
      else
      end
    end
    render(:login) and return
  end

######### DISPLAY HOMEPAGE
  def home
    if session["found_user_id"] != nil
      @events = Event.where(florist_id: session["found_florist_id"]).where("event_status not like 'Lost'").where("event_status not like 'Completed'").order("date_of_event")
      render(:homepage) and return
    else
      render(:login) and return
    end
  end
  

######### SEARCH OR LOGOUT BUTTONS ON HOMEPAGE
  def homepage
    if params["search"] #if they push the search button
      if params["search_field"] != ""
        customer = params["search_field"]
      else
        customer = "add_new_customer"
      end
      redirect_to "/search/#{customer}" and return
    else 
      redirect_to "/logout" and return
    end
  end

  def logout
    session.clear
    render(:login) and return
  end  
  
  
######### SEARCH RESULTS  
  def search_results
    @customers = Customer.where("name ilike ?","%#{params["customer"]}%")
    render(:search_results) and return
  end  

######### NEW CUSTOMER

###GET Request from search_results.erb
  def cust_new   
    render(:cust_new) and return  
  end

  def create_new_customer   #Post Request from cust_new.erb
    new_customer = Customer.new
    new_customer.name = params["new_contact_name"]
    new_customer.company_name = params["company_name"]
    new_customer.phone1 = params["phone1"]
    new_customer.phone2 = params["phone2"]
    new_customer.email = params["contact_email"]
    new_customer.groom_name = params["groom_name"]
    new_customer.groom_phone = params["groom_phone"]
    new_customer.groom_email = params["groom_email"]
    new_customer.address = params["address"]
    new_customer.city = params["city"]
    new_customer.state = params["state"]
    new_customer.notes = params["notes"]
    new_customer.florist_id = 1 #NEEDS TO BE TIED TO LOGIN INFO"
    new_customer.save!
    redirect_to "/cust_edit/#{new_customer.id}" and return
  end

######### EDIT CUSTOMER

###GET Handler from cust_new.erb, search_results.erb, or homepage.erb
  def edit_customer          
    cust_id = params["customer_id"]
    @customer = Customer.where(id: cust_id).first
    render(:cust_edit) and return
  end
  
###POST Handler from cust_edit.erb  
  def cust_edit             
    if params["save"]
      cust_id = params["contact_id"]
      existing_customer = Customer.where(id: cust_id).first  #NEEDS TO BE TIED TO LOGIN INFO
      existing_customer.name = params["contact_name"]
      existing_customer.company_name = params["company_name"]
      existing_customer.phone1 = params["phone1"]
      existing_customer.phone2 = params["phone2"]
      existing_customer.email = params["contact_email"]
      existing_customer.groom_name = params["groom_name"]
      existing_customer.groom_phone = params["groom_phone"]
      existing_customer.groom_email = params["groom_email"]
      existing_customer.address = params["address"]
      existing_customer.city = params["city"]
      existing_customer.state = params["state"]
      existing_customer.notes = params["notes"]
      existing_customer.save!
    elsif params["delete"]
      event = Event.where(id: params["delete"]).first
      event.destroy
      for each in DesignedProduct.where(event_id: params["delete"])
        each.destroy
      end  
      for specification in Specification.where(event_id: params["delete"])
        specification.destroy    
      end
      deleted_quote = Quote.where(event_id: params["delete"]).first
      if deleted_quote != nil
        deleted_quote.destroy
      else
      end    
    end
    redirect_to "/cust_edit/#{params["contact_id"]}" and return
  end
  
######### EVENT NEW

### GET Handler from cust_edit.erb
  def event_new
    cust_id = params["cust_id"]
    @customer = Customer.where(id: cust_id).first
    @employee_list = [""]
    for employee in Employee.order("name")
      @employee_list[@employee_list.size] = employee.name
    end
    render(:event_new) and return
  end

### POST Handler from event_new.erb
  def create_new_event
    new_event = Event.new
    new_event.event_type = params["event_type"]
    new_event.name = params["event_name"]
    new_event.date_of_event = params["event_date"]
    new_event.time = params["event_time"]
    new_event.delivery_setup_time = params["setup_time"]
    new_event.feel_of_day = params["feel_of_day"]
    new_event.color_palette = params["color_palette"]
    new_event.flower_types = params["flower_types"]
    new_event.attire = params["attire"]
    new_event.employee_id = Employee.where(name: params["lead_designer"]).first.id                                                   
    new_event.florist_id = session["found_florist_id"]                                                                        #As well, you need to resolve the 3rd party and Site info
    new_event.budget = params["budget"]
    new_event.notes = params["notes"]
    new_event.customer_id = params["customer_id"]  # How Do I make non-editable elements of a form. IE:  Shouldn't be able to edit ID #s
    new_event.event_status = "Open Proposal"
    new_event.save!
    redirect_to "/event_edit/#{new_event.id}" and return
  end

########## EDIT EVENT
###GET Handler from event_new.erb
  def event_edit
    event_id = params["event_id"]
    @event = Event.where(id: event_id).first
    @specifications = @event.specifications.order("id")
    @employee_list = []
    for employee in Employee.order("name")
      @employee_list[@employee_list.size] = employee.name
    end
    render(:event_edit) and return
  end
  
###POST Handler from event_edit.erb
  def event_and_specs_edit
    #Updates to Event Section
    if params["save"]
      edit_event = Event.where(id: params["event_id"]).first
      edit_event.event_type = params["event_type"]
      edit_event.name = params["event_name"]
      edit_event.date_of_event = params["event_date"]
      edit_event.time = params["event_time"]
      edit_event.delivery_setup_time = params["setup_time"]
      edit_event.feel_of_day = params["feel_of_day"]
      edit_event.color_palette = params["color_palette"]
      edit_event.flower_types = params["flower_types"]
      edit_event.attire = params["attire"]
      edit_event.employee_id = Employee.where(name: params["lead_designer"]).first.id                                                   
                                                                            #As well, you need to resolve the 3rd party and Site info
      edit_event.notes = params["notes"]
      edit_event.budget = params["budget"]
      edit_event.customer_id = params["customer_id"]  
      edit_event.save!
  
    #Updates to Event Specifications Section
      for each in Specification.where(event_id: params["event_id"])  
        each.item_name = params["spec_item-#{each.id}"]
        each.item_quantity = params["spec_qty-#{each.id}"]
        each.item_specs = params["spec_notes-#{each.id}"]
        each.save!      
      end
    elsif params["delete"]
        spec_id = params["delete"]
        spec = Specification.where(id: spec_id).first
        spec.destroy
        designed_products = DesignedProduct.where(specification_id: spec_id)
      for each in designed_products
        each.destroy
      end  
    elsif params["add"]
      new_spec = Specification.new
      new_spec.event_id = params["ev_id"]
      new_spec.item_name = ""
      new_spec.item_quantity = 1
      new_spec.item_specs = ""
      new_spec.florist_id = session["found_florist_id"] 
      new_spec.save!
    end
    redirect_to "/event_edit/#{params["event_id"]}"
 
    end
  
  
########## VIRTUAL STUDIO

###GET Handler from event_edit.erb
  def virtual_studio
    event_id = params["event_id"]    
    @event= Event.where(id: event_id).first  
    @specifications = @event.specifications.order("id")
  
  #Creates a list of used products for the specification 
    designedproducts = DesignedProduct.where(event_id: event_id)
    used_products = []
    for each in designedproducts
      used_products << each.product.name
    end
    @list_of_products = used_products.uniq.sort

  #Creates a new designed_product for each specification for each product identified for the particular specification
  #This addresses the issue associated specifications added at the end of the design process.
   for each in @list_of_products
      id = Product.where(name: each).first.id
      for specification in @specifications
          x = DesignedProduct.where(product_id: id).where(specification_id: specification.id).first
          if x == nil
            new_dp = DesignedProduct.new
            new_dp.specification_id = specification.id
            new_dp.product_id = id
            new_dp.event_id = @event.id
            new_dp.product_qty = 0
            new_dp.florist_id = session["found_florist_id"]
            new_dp.product_type = Product.where(name: each).first.product_type
            new_dp.save!
          else
          end
      end
    end
  
  ## Generate dropdown list for adding new products to the Virtual Studio Page
    products = Product.order("name")
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
  # Creates a new designed_product for each specification based on the product selected.  
  def virtual_studio_add_new_product
    event_id = params["event_id"]
    new_item = params["new_item"]
    specifications = Specification.where(event_id: event_id)
    for specification in specifications
      new_dp = DesignedProduct.new
      new_dp.specification_id = specification.id
      new_dp.product_qty = 0
      new_dp.product_type = Product.where(name: new_item).first.product_type
      new_dp.florist_id = session["found_florist_id"]
      new_dp.product_id = Product.where(name: new_item).first.id
      new_dp.event_id = event_id
      new_dp.save!
    end  
    redirect_to "/virtual_studio/#{event_id}" and return
  end
  
  
### POST Handler from virtual_studio.erb
  # Updates Virtual Studio Page based on updates made by user. 
  def virtual_studio_update
    event_id = params["event_id"]
    specifications = Specification.where(event_id: event_id).order("id")
    designedproducts = DesignedProduct.where(event_id: event_id)
    if params["remove"]
      removed_product_id = params["remove"]
      removed_items = DesignedProduct.where(event_id: event_id).where(product_id: removed_product_id)
      for each_item in removed_items
        each_item.destroy
      end
    else
    end
    for each in designedproducts
      for specification in specifications
        if DesignedProduct.where(product_id: each.product_id).where(specification_id: specification.id).first == nil
          new = DesignedProduct.new
          new.specification_id = specification.id
          new.product_qty = 0
          new.product_type = Product.where(id: each.product_id).first.product_type
          new.florist_id = session["found_florist_id"]
          new.product_id = each.product_id
          new.event_id = event_id
          new.save! 
        else
          update = DesignedProduct.where(id: each.id).first     
          update.product_qty = params["stemcount_#{each.id}"]
          update.product_type = Product.where(id: each.product_id).first.product_type  
          update.save!
        end
      end
    end  
    redirect_to "/virtual_studio/#{event_id}" and return
  end
  
  
### GET Handler from virtual_studio.erb 
  def popup_specs
    event_id = params["event_id"]
    @event_id = event_id
    @specifications = Specification.where(event_id: event_id).order("id")
    render(:popup_specs) and return
  end 
  
######### QUOTE GENERATION

### GET handler from event_edit.erb
  def quote_generation
    event_id = params["event_id"]
    @event = Event.where(id: event_id).first
    @specifications = @event.specifications.order("id")
    count = 0
    for each in DesignedProduct.where(event_id: event_id)
      count = count + each.product_qty
    end
    if DesignedProduct.where(event_id: event_id).first == nil || count < 1.0
      redirect_to "/virtual_studio/#{event_id}" and return
    else
    end
    if Quote.where(event_id: event_id).first == nil
      new_quote = Quote.new
      new_quote.event_id = event_id
      new_quote.status = "Open Proposal"
      new_quote.florist_id = session["found_florist_id"] 
      new_quote.save!
      event = Event.where(id: event_id).first
      event.event_status = "Open Proposal"
      event.save!
    else
    end
    @quote = Quote.where(event_id: event_id).first
    render(:gen_quote) and return
  end

### POST handler from gen_quote.erb
  def save_quote
    event_id = params["event_id"]
    for each in Specification.where(event_id: event_id)
      if params["quoted_price-#{each.id}"] == nil
        each.quoted_price = 0
      else
        each.quoted_price = params["quoted_price-#{each.id}"]
      end
      each.per_item_cost = params["per_item_cost-#{each.id}"]
      each.per_item_list_price = params["per_item_list_price-#{each.id}"]
      each.extended_list_price = params["extended_list_price-#{each.id}"]
      each.save!
    end
    quote = Quote.where(event_id: event_id).first
    quote.quote_name = params["quote_name"]
    quoted_total_price = 0
    total_cost = 0
    for each in Specification.where(event_id: event_id)
      if each.quoted_price == nil
        each.quoted_price = 0
      else
      end
      quoted_total_price = quoted_total_price + each.quoted_price
      total_cost = total_cost + (each.per_item_cost * each.item_quantity).round(2)
    end 
    quote.total_price = quoted_total_price.round(2)
    quote.markup = (quote.total_price / total_cost).round(2)
    quote.status = params["status"]
    if params["status"] != "Completed"  && params["status"] != "Ordered"
      quote.wholesale_order_date = nil
    else
    end
    quote.save!
    event = Event.where(id: event_id).first
    event.event_status = params["status"]
    event.save!
    redirect_to "/generate_quote/#{event_id}" and return
    end

### GET Handler from gen_quote.erb
  def generate_cust_facing_quote
    event_id = params["event_id"]
    @event = Event.where(id: event_id).first
    @specifications = @event.specifications.order("id")
    if DesignedProduct.where(event_id: event_id).first == nil
      redirect_to "/virtual_studio/#{event_id}" and return
    else
    end
    if Quote.where(event_id: event_id).first == nil
      new_quote = Quote.new
      new_quote.event_id = event_id
      new_quote.status = "Open Proposal"
      new_quote.florist_id = session["found_florist_id"] 
      new_quote.save!
      event = Event.where(id: event_id).first
      event.event_status = "Open Proposal"
      event.save!
    else
    end
    @quote = Quote.where(event_id: event_id).first
    render(:cust_facing_quote) and return
  end
  
######### WHOLESALE ORDERS & DESIGN DAY DETAILS
###GET Handler from homepage.erb
  def schedule_order_date
    @booked_quotes = Quote.where(status: "Booked")
    render(:schedule_order_date) and return
  end
  
###POST Handler from schedule_order_date.erb
  def assign_order_date
    @booked_quotes = Quote.where(status: "Booked")
    for booked_quote in @booked_quotes
      if params["place_order-#{booked_quote.id}"]
        booked_quote.status = "Ordered"
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
    @orders = Quote.where(status: "Ordered").where(wholesale_order_date: params["place_order_on"])
    @list_of_event_ids = []
    for order in @orders
      @list_of_event_ids << order.event_id
    end

    list_of_product_ids = []
    for each_id in @list_of_event_ids   
      for designed_product in DesignedProduct.where(event_id: each_id).order("product_type")
        list_of_product_ids << designed_product.product_id
      end
    end
    @list_of_product_ids = list_of_product_ids.uniq
    render(:wholesale_order_list) and return
  end
  
####GET Handler from event_edit.erb
  #Creates an order details summary for the individual event (to be used on the day of the design work).
  def design_day_details
    @event = Event.where(id: params["event_id"]).first
    @quote = Quote.where(event_id: params["event_id"]).first
    @specifications = Specification.where(event_id: params["event_id"])
    @designed_products = DesignedProduct.where(event_id: params["event_id"])
    @list_of_product_ids = @designed_products.uniq.pluck(:product_id)
    @list_of_product_types = @designed_products.uniq.pluck(:product_type)

    count = 0
    for each in @designed_products
      count = count + each.product_qty
    end

    if DesignedProduct.where(event_id: params["event_id"]).first == nil || count < 1.0
      redirect "/virtual_studio/#{params["event_id"]}"
    end

    if Quote.where(event_id: params["event_id"]).first == nil
      redirect "/generate_quote/#{params["event_id"]}"
    end
    render(:design_day_details) and return
  end

######### PRODUCTS
### GET Handler from homepage.erb
  def products
    @products = Product.order("status", "product_type", "name") 
    render(:products) and return
  end
  
### POST Handler from products.erb
  def products_update
    #if params["action"] == "save"
    for product in Product.all
      product.items_per_bunch = params["items_per_bunch_#{product.id}"].to_f
      product.cost_per_bunch = params["cost_per_bunch_#{product.id}"].to_f
      if params["items_per_bunch_#{product.id}"].to_f > 0.0
        product.cost_for_one = (params["cost_per_bunch_#{product.id}"].to_f) / (params["items_per_bunch_#{product.id}"].to_f)
      else
      end
      product.markup = params["markup_#{product.id}"].to_f
      product.status = params["status_#{product.id}"]
      product.save!
    end
    redirect_to "/products" and return
  end

### GET Handler from products.erb
  def new_product
    @florist = Florist.where(id: session["found_florist_id"]).first
    render(:new_product) and return
  end  
  
### POST Handler from new_product.erb
  def save_new_product
    newbie = Product.new
    newbie.product_type= params["product_type_new"]
    newbie.name = params["product_name_new"]
    newbie.items_per_bunch = params["items_per_bunch_new"].to_f
    newbie.cost_per_bunch = params["cost_per_bunch_new"].to_f
    newbie.cost_for_one =(params["cost_per_bunch_new"].to_f) / (params["items_per_bunch_new"].to_f)
    newbie.markup = params["markup_new"].to_f
    newbie.status = params["status_new"]
    newbie.florist_id = session["found_florist_id"]
    newbie.save!
    redirect_to "/products" and return
  end

######### EMPLOYEES
### GET Handler from homepage.erb
  def employees
    @employees = Employee.order("status",  "name")
    @florist = Florist.where(id: session["found_florist_id"]).first 
    render(:employees) and return
  end

### POST Handler from employees.erb
  def employee_post
    if params["new"] 
      redirect_to "/employee/new" and return
    else
      redirect_to "/employee/#{params["edit"]}" and return
    end
  end

### GET Handler from employees.erb
  def employee
    id = params["employee_id"]
    if id == "new"
      @employee = Employee.new
    else
      @employee = Employee.where(id: id).first
    end
    render(:employee_edit) and return
  end

### POST Handler from employee_edit.erb
  def employee_updates
    if params["employee_id"] == "new"
      employee = Employee.new
      employee.florist_id = session["found_florist_id"]
    else
      employee = Employee.where(id: params["id"]).first
    end
    employee.name = params["name"]
    employee.status = params["status"]
    employee.email = params["email"]
    employee.w_phone = params["phone_w"]
    employee.c_phone = params["phone_c"]
    employee.employee_type = params["employee_type"]
    employee.username = params["username"]
    employee.admin_rights = params["admin_rights"]
    employee.save!
    redirect_to "/employees" and return
  end

end
