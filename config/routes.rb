App::Application.routes.draw do
  get "/"                                     => "main#login"
  post "/login"                               => "main#logged_in"
  get "/home"                                 => "main#home"
  post "/homepage"                            => "main#homepage"  
  get "/logout"                               => "main#logout"
  get "/search/:customer"                     => "main#search_results"
  
  get "/cust_new"                             => "main#cust_new"
  post "/create_new_customer"                 => "main#create_new_customer"
  get "/cust_edit/:customer_id"               => "main#edit_customer"
  post "/cust_edit"                           => "main#cust_edit"

  get "/event_new/:cust_id"                   => "main#event_new"
  post "/event_new"                           => "main#create_new_event"
  get "/event_edit/:event_id"                 => "main#event_edit"
  post "/event_edit"                          => "main#event_and_specs_edit"

  get "/virtual_studio/:event_id"             => "main#virtual_studio"
  post "/virtual_studio_add_new"              => "main#virtual_studio_add_new_product"
  post "/virtual_studio_update"               => "main#virtual_studio_update"
  get "/popup_specs/:event_id"                => "main#popup_specs"
  
  get "/generate_quote/:event_id"             => "main#quote_generation"
  post "/save_quote"                          => "main#save_quote"
  get "/generate_cust_facing_quote/:event_id" => "main#generate_cust_facing_quote"
  
  get "/schedule_order_date"                  => "main#schedule_order_date"
  post "/assign_order_date"                   => "main#assign_order_date"
  get "/wholesale_order_list/:place_order_on" => "main#wholesale_order_list"
  get "/design_day_details/:event_id"         => "main#design_day_details"
  
  get "/products"                             => "main#products"
  post "/products_update"                     => "main#products_update"
  get "/new_product"                          => "main#new_product"
  post "/save_new_product"                    => "main#save_new_product"
  get "/employees"                            => "main#employees"
  post "/employee_post"                       => "main#employee_post"
  get "/employee/:employee_id"                => "main#employee"
  post "/employee_updates/:employee_id"       => "main#employee_updates"
end


=begin
App::Application.routes.draw do
  get  "/"              => redirect("/credit_card")
  get  "/credit_card"   => "cart#edit_credit_card"
  post "/credit_card"   => "cart#update_credit_card"
  get  "/thank_you"     => "cart#thank_you"
end
=end