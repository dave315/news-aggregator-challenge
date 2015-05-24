require "sinatra"
require "pg"
require "csv"

# articles = CSV.read("articles.csv", headers: true)

get "/articles" do
  @articles = db_connection {|conn| conn.exec("SELECT * FROM articles")}

  erb :index
end

get "/articles/new" do
  erb :newarticles, locals: { error_message: "",
                              url_resubmit: "",
                              title_resubmit: "",
                              description_resubmit: "",
                              }

end

post "/articles/new" do
  article_url = params["article_url"]
  description = params["description"]
  title = params["title"]
  submission = [article_url, title, description]

  if url_check(article_url)
    erb :newarticles, locals: { error_message: "That article has already submitted :(",
                                url_resubmit: article_url,
                                title_resubmit: title,
                                description_resubmit: description,
                                }
  else
    db_connection do |data|
      data.exec_params("INSERT INTO articles (url, title, description)
      VALUES($1, $2, $3)",
      submission)
    end


  redirect "/articles"
  end
end

def url_check(website)
  # dupes = CSV.read("articles.csv", headers: true)
  dupes = db_connection {|conn| conn.exec("SELECT url FROM articles")}
  dupes.each do |data|
    if website == data["url"]
      return true
    end
  end

  false
end

def db_connection
  begin
    connection = PG.connect(dbname: "news_aggregator_development")
    yield(connection)
  ensure
    connection.close
  end
end
