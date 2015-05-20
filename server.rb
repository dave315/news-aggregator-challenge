require "sinatra"
require "csv"

articles = CSV.read("articles.csv")

get "/articles" do
  erb :index, locals: { articles: articles }
end

get "/articles/new" do
  erb :newarticles, locals: { articles: articles }
end

post "/articles/new" do
  new_article = params["new_article"]
  description = params["description"]
  title = params["title"]

  CSV.open("articles.csv", "a") do |csv|
    csv << [new_article, title, description]
  end
  
  redirect "/articles"
end
