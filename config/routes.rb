App::Application.routes.draw do
  
  
  get "/about_us"                             => "main#about_us", as: "about_us"
  get "/marketing"                            => "main#marketing"
  get "/"                                     => "main#webpage"
  get "/login"                                => "main#login"
  post "/login"                               => "main#logged_in", as: "login"
  get "/home"                                 => "main#home", as: "home"
  post "/homepage"                            => "main#homepage", as: "homepage"
  get "/logout"                               => "main#webpage", as: "webpage"
  get "/search/:customer"                     => "main#search_results"
  
  get "/cust_new"                             => "main#cust_new"
  post "/create_new_customer"                 => "main#create_new_customer"
  get "/cust_edit/:customer_id"               => "main#edit_customer"
  post "/cust_edit"                           => "main#cust_edit"

  get "/event_new/:cust_id"                   => "main#event_new"
  post "/create_new_event/:customer_id"       => "main#create_new_event"
  get "/event_edit/:event_id"                 => "main#event_edit"
  post "/event_edit"                          => "main#event_and_specs_edit"

  get "/images/:specification_id"             => "main#add_images", as: "form"
  post "/upload"                              => "main#upload", as: "upload"
  get "/imaged:id.:ext"                       => "main#image_data", as: "image_data"
  
  get "/virtual_studio/:event_id"             => "main#virtual_studio"
  post "/virtual_studio_update"               => "main#virtual_studio_update"
  get "/popup_specs/:event_id"                => "main#popup_specs"
  
  get "/generate_quote/:event_id"             => "main#quote_generation"
  post "/save_quote"                          => "main#save_quote"
  get "/quote/:cust_id/:event_id"             => "main#generate_cust_facing_quote"
  
  get "/schedule_order_date"                  => "main#schedule_order_date"
  post "/assign_order_date"                   => "main#assign_order_date"
  get "/wholesale_order_list/:place_order_on" => "main#wholesale_order_list"
  get "/design_day_details/:event_id"         => "main#design_day_details"
  
  get "/products"                             => "main#products"
  post "/product_post"                        => "main#product_post"
  get "/product/:product_id"                  => "main#product"
  post "product_updates/:product_id"          => "main#product_updates"
  
  get "/employees"                            => "main#employees"
  post "/employee_post"                       => "main#employee_post"
  get "/employee/:employee_id"                => "main#employee"
  post "/employee_updates/:employee_id"       => "main#employee_updates"
  
  get "/florists"                             => "admin#florists"
  post "/florists_post"                       => "admin#florists_post"
  get "/florists/:florist_id"                 => "admin#florist"
  post "florist_updates/:florist_id"          => "admin#florist_updates"
  
  
end


