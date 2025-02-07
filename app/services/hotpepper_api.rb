require "faraday"
require "json"

class HotpepperAPI
  BASE_URL = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"

  def self.search_shops(keyword, count = 10) # これでAPIにリクエストを送信
    response = Faraday.get(BASE_URL, {
      key: ENV["HOTPEPPER_API_KEY"],
      keyword: keyword, # 検索に使うキーワード
      format: "json", # 受け取るデータの形式
      count: count # データの取得件数
    })

    if response.status == 200 # これで取得したデータをハッシュ形式に変換
      JSON.parse(response.body)["results"]["shop"]
    else
      []
    end
  end
end
