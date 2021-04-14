class PostsController < ApplicationController
  def index
    #Slackのトークンを設定します
    Slack.configure do |config|
      config.token = "slackapiで取得したtokenを記述する"
    end
    
    # SlackのAPIクライアントを新規で生成します
    client = Slack::Web::Client.new
    
    # 「#」を先頭につけてチャンネル名を記述します
    channel = '#slackのチャンネル名を記述する'

    # config.jsonを使ってGoogleDriveに接続します
    @session = GoogleDrive::Session.from_config("config.json")

    # 操作するシートのID、シート名を定義します
    @sheets = @session.spreadsheet_by_key("スプレッドシートのIDを記述する").worksheet_by_title("シート名を記載する")
    
    # 動作を確認するため、左上のセルに値を入れるようにします
    @sheets[1, 1] = "Hello World"

    #変数の定義
    @content = @sheets[5, 16]
  

    # 投稿するメッセージを記述します
    text = "スプレッドシートの値は#{@content}です。"
    
    response = client.chat_postMessage(channel: channel, text: text)
    
    # シートを上書き保存します(Hello Worldを保存する必要はないため、記述しなくてもOKです)
    @sheets.save
  end
end
