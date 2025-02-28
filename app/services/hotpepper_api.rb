require "net/http"
require "json"
require "uri"

class HotpepperApi
  BASE_URL = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"

  def self.search_shops(keyword:, record_start_index:, free_drink:, free_food:, private_room:, course:, midnight:, non_smoking:)
    uri = URI(BASE_URL)
    params = {
      key: ENV["HOTPEPPER_API_KEY"],
      keyword:, # 検索に使うキーワード
      format: "json", # 受け取るデータの形式
      start: record_start_index,
      free_drink: free_drink.to_i,
      free_food: free_food.to_i,
      private_room: private_room.to_i,
      course: course.to_i,
      midnight: midnight.to_i,
      non_smoking: non_smoking.to_i,
      count: count = 100
    }
    binding.pry
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri) # APIにリクエストを送信

    if response.is_a?(Net::HTTPSuccess) # これで取得したデータをハッシュ形式に変換
      JSON.parse(response.body)["results"]["shop"]
    else
      []
    end
  end
end
