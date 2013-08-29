App::Application.routes.draw do
  
  
  get "/about_us"                             => "main#about_us", as: "about_us"
  get "/marketing"                            => "main#marketing"
  get "/"                                     => "main#webpage"
  get "/login"                                => "main#login"
  post "/login"                               => "main#logged_in", as: "login"
  get "/home"                                 => "main#home", as: "home"
  post "/homepage"                            => "main#homepage", as: "homepage"
  get "/home/:beg_date"                       => "main#homepage_search_results"
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
  post "/update_image"                        => "main#update_image", as: "update_image"
  
  get "/virtual_studio/:event_id"             => "main#virtual_studio"
  post "/virtual_studio_update"               => "main#virtual_studio_update"
  get "/popup_specs/:event_id"                => "main#popup_specs"
  get "/vs_spec_update/:spec_id"              => "main#vs_spec_update"
  post "/vs_spec_save"                        => "main#vs_spec_save"
  
  get "/generate_quote/:event_id"             => "main#quote_generation"
  post "/save_quote"                          => "main#save_quote"
  get "/quote/:event_id"                      => "main#generate_cust_facing_quote"
  
  get "/schedule_order_date"                  => "main#schedule_order_date"
  post "/assign_order_date"                   => "main#assign_order_date"
  get "/wholesale_order_list/:place_order_on" => "main#wholesale_order_list"
  get "/design_day_details/:event_id"         => "main#design_day_details"
  
  get "/products"                             => "main#products"
  post "/product_post"                        => "main#product_post"
  get "/products/:search_field"               => "main#products_search_results"
  get "/product/:product_id"                  => "main#product"
  post "product_updates/:product_id"          => "main#product_updates"
  get "/image_gallery"                        => "main#image_gallery"
  post "/image_gallery_post"                  => "main#image_gallery_post"
  get "/image_gallery/:search_field"          => "main#image_gallery_search_results"
  
  get "/employees"                            => "main#employees"
  post "/employee_post"                       => "main#employee_post"
  get "/employee/:employee_id"                => "main#employee"
  post "/employee_updates/:employee_id"       => "main#employee_updates"
  
  get "/florists"                             => "admin#florists"
  post "/florists_post"                       => "admin#florists_post"
  get "/florists/:florist_id"                 => "admin#florist"
  post "florist_updates/:florist_id"          => "admin#florist_updates"
  
  get "/setup"                                => "main#setup"
  post "/setup_update"                        => "main#setup_update"
  
  get "/plans"                                => "admin#plans"
  post "/plans_post"                          => "admin#plans_post"
  get "/plans/:plan_id"                       => "admin#plan"
  post "plan_updates/:plan_id"                => "admin#plan_updates"
end


