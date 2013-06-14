# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


florists = Florist.create([
    {name: "Fundingsland Flowers", company_logo: "bouquet.jpeg", company_id: "funland"},
    {name: "April's Flowers", company_logo: "aprils_flowers.jpeg", company_id: "april"},
    {name: "Perfect Petal", company_logo: "perfect_petal.jpeg", company_id: "perfect"}, 
    {name: "Wild Orchid", company_logo: "wild_orchid.jpeg", company_id: "orchid"},
    {name: "Bloom", company_logo: "bloom.jpeg", company_id: "bloom"}
    ])
    
    
    
employees = Employee.create([
    {name: "Jenny Geyer", status: "Active", username: "jenny", password: "jenny", florist_id: 1, admin_rights: ""},
    {name: "Debbie Downer", status: "Active", username: "debbie", password: "debbie", florist_id: 1, admin_rights: ""},
    {name: "Lisa Smith", status: "Active", username: "lisa", password: "lisa", florist_id: 2, admin_rights: ""},
    ])
    
customers = Customer.create([
  {name: "Sara Bolle", florist_id: 1},
  {name: "Emily Furgeson", florist_id: 1},
  {name: "Jenny Fundingsland", florist_id: 1},
  {name: "Sally Smith", florist_id: 2},
  {name: "Heather Leslie", florist_id: 2}
  ])
  
products = Product.create([
{product_type: "Labor", name: "Dandelions", items_per_bunch: 25.0, cost_per_bunch: 45.0, cost_for_one: 1.8, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "freshies", name: nil, items_per_bunch: 30.0, cost_per_bunch: 30.0, cost_for_one: 1.0, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "freshies", name: nil, items_per_bunch: 30.0, cost_per_bunch: 30.0, cost_for_one: 1.0, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Berzilia Berry", items_per_bunch: 10.0, cost_per_bunch: 12.95, cost_for_one: 1.295, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Heather French", items_per_bunch: 10.0, cost_per_bunch: 9.75, cost_for_one: 0.975, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Kochia", items_per_bunch: 10.0, cost_per_bunch: 7.95, cost_for_one: 0.795, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Larkspur", items_per_bunch: 10.0, cost_per_bunch: 8.5, cost_for_one: 0.85, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Peonies", items_per_bunch: 10.0, cost_per_bunch: 12.95, cost_for_one: 1.295, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Rose 60 CM", items_per_bunch: 25.0, cost_per_bunch: 18.5, cost_for_one: 0.74, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Daffodil", items_per_bunch: 10.0, cost_per_bunch: 0.68, cost_for_one: 0.068, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Delph Cali", items_per_bunch: 10.0, cost_per_bunch: 9.75, cost_for_one: 0.975, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Eryngium", items_per_bunch: 10.0, cost_per_bunch: 8.75, cost_for_one: 0.875, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "GYP Overtime", items_per_bunch: 10.0, cost_per_bunch: 7.95, cost_for_one: 0.795, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Garden Roses CAL", items_per_bunch: 12.0, cost_per_bunch: 35.4, cost_for_one: 2.95, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Anemone", items_per_bunch: 10.0, cost_per_bunch: 14.95, cost_for_one: 1.495, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Fresh", name: "Green Mist", items_per_bunch: 10.0, cost_per_bunch: 8.95, cost_for_one: 0.895, markup: 3.0, status: "Active", florist_id: 1},
{product_type: "Labor", name: "Dandelions", items_per_bunch: 25.0, cost_per_bunch: 45.0, cost_for_one: 1.8, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "freshies", name: nil, items_per_bunch: 30.0, cost_per_bunch: 30.0, cost_for_one: 1.0, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "freshies", name: nil, items_per_bunch: 30.0, cost_per_bunch: 30.0, cost_for_one: 1.0, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Berzilia Berry", items_per_bunch: 10.0, cost_per_bunch: 12.95, cost_for_one: 1.295, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Heather French", items_per_bunch: 10.0, cost_per_bunch: 9.75, cost_for_one: 0.975, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Kochia", items_per_bunch: 10.0, cost_per_bunch: 7.95, cost_for_one: 0.795, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Larkspur", items_per_bunch: 10.0, cost_per_bunch: 8.5, cost_for_one: 0.85, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Peonies", items_per_bunch: 10.0, cost_per_bunch: 12.95, cost_for_one: 1.295, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Rose 60 CM", items_per_bunch: 25.0, cost_per_bunch: 18.5, cost_for_one: 0.74, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Daffodil", items_per_bunch: 10.0, cost_per_bunch: 0.68, cost_for_one: 0.068, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Delph Cali", items_per_bunch: 10.0, cost_per_bunch: 9.75, cost_for_one: 0.975, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Eryngium", items_per_bunch: 10.0, cost_per_bunch: 8.75, cost_for_one: 0.875, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "GYP Overtime", items_per_bunch: 10.0, cost_per_bunch: 7.95, cost_for_one: 0.795, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Garden Roses CAL", items_per_bunch: 12.0, cost_per_bunch: 35.4, cost_for_one: 2.95, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Anemone", items_per_bunch: 10.0, cost_per_bunch: 14.95, cost_for_one: 1.495, markup: 3.0, status: "Active", florist_id: 2},
{product_type: "Fresh", name: "Green Mist", items_per_bunch: 10.0, cost_per_bunch: 8.95, cost_for_one: 0.895, markup: 3.0, status: "Active", florist_id: 2}
])