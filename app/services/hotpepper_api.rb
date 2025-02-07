require "net/http"
require "json"
require "uri"

class HotpepperApi
  BASE_URL = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"

  def self.search_shops(keyword, count = 100)
    uri = URI(BASE_URL)
    params = {
      key: ENV["HOTPEPPER_API_KEY"],
      keyword: keyword, # 検索に使うキーワード
      format: "json", # 受け取るデータの形式
      count: count # データの取得件数
    }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri) # APIにリクエストを送信

    if response.is_a?(Net::HTTPSuccess) # これで取得したデータをハッシュ形式に変換
      JSON.parse(response.body)["results"]["shop"]
    else
      []
    end
  end
end
