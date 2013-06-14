class CreateInitialSchema < ActiveRecord::Migration
  def up
    create_table :customers do |t|
      t.string :name
      t.string :phone1
      t.string :phone2
      t.string :email
      t.string :groom_name
      t.string :groom_phone
      t.string :groom_email
      t.string :company_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :notes, limit:500
      t.integer :florist_id
      t.timestamps :updated_at
      t.timestamps :created_at
      t.string :updated_by
    end
  
    create_table :florists do |t|
      t.string :name
      t.string :company_logo
      t.string :company_id
      t.timestamps :updated_at
      t.timestamps :created_at
      t.string :updated_by
    end
  
    create_table :employees do |t|
      t.string :name
      t.string :status
      t.string :email
      t.string :w_phone
      t.string :c_phone
      t.string :employee_type
      t.string :username
      t.string :password_digest
      t.integer :florist_id
      t.string :admin_rights
      t.string :password
      t.timestamps :updated_at
      t.timestamps :created_at
      t.string :updated_by
    end
  
    create_table :products do |t|
      t.string :product_type
      t.string :name
      t.float :items_per_bunch
      t.float :cost_per_bunch
      t.float :cost_for_one
      t.float :markup
      t.string :status
      t.integer :florist_id
      t.timestamps :updated_at
      t.timestamps :created_at
      t.string :updated_by
    end
  
    create_table :events do |t|
      t.string :event_type
      t.string :name
      t.date :date_of_event
      t.string :time
      t.string :delivery_setup_time
      t.string :notes
      t.string :feel_of_day
      t.string :color_palette
      t.string :flower_types
      t.string :attire
      t.integer :employee_id
      t.integer :customer_id
      t.string :photographer
      t.string :coordinator
      t.string :locations
      t.string :budget
      t.string :event_status
      t.timestamps :updated_at
      t.timestamps :created_at
      t.string :updated_by
    end
  
    create_table :quotes do |t|
      t.string :quote_name
      t.integer :event_id
      t.float :total_price
      t.float :markup
      t.string :status
      t.date :wholesale_order_date
      t.timestamps :updated_at
      t.timestamps :created_at
      t.string :updated_by
    end
    
    create_table :specifications do |t|
      t.integer :event_id
      t.string :item_name
      t.float :item_quantity
      t.string :item_specs, limit:1000
      t.boolean :in_quote
      t.float :per_item_cost
      t.float :per_item_list_price
      t.float :extended_list_price
      t.float :quoted_price
      t.string :image
      t.timestamps :updated_at
      t.timestamps :created_at
      t.string :updated_by
    end
  
    create_table :designed_products do |t|
      t.integer :event_id
      t.integer :specification_id
      t.integer :product_id
      t.float :product_qty
      t.string :product_type
      t.timestamps :updated_at
      t.timestamps :created_at
      t.string :updated_by
    end  
end

  def down
  drop_table :customers
  drop_table :florists
  drop_table :employees
  drop_table :products
  drop_table :events
  drop_table :quotes
  drop_table :specifications
  drop_table :designed_products
  end

end
