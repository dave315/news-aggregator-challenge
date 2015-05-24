require "sinatra"
require "csv"

articles = CSV.read("articles.csv", headers: true)

get "/articles" do
  erb :index, locals: { articles: articles }
end

get "/articles/new" do
  erb :newarticles, locals: { articles: articles,
                              error_message: "",
                              url_resubmit: "",
                              title_resubmit: "",
                              description_resubmit: "",
                              }
end

post "/articles/new" do
  article_url = params["article_url"]
  description = params["description"]
  title = params["title"]

  if url_check(article_url)
    erb :newarticles, locals: { error_message: "That article has already submitted :(",
                                url_resubmit: article_url,
                                title_resubmit: title,
                                description_resubmit: description,
                                }
  else
    CSV.open("articles.csv", "a") do |csv|
    csv << [article_url, title, description]
    end
  redirect "/articles"
  end
end

def url_check(url)
  dupes = CSV.read("articles.csv", headers: true)

  dupes.each do |row|
    if url == row["url"]
      return true
    end
  end

  false
end
