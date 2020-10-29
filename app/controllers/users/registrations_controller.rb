# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :session_has_not_user_data, only: [:new_address_preset, :create_address_preset]

  def create
    session["devise.regist_data"] ||= {}
    if session["devise.regist_data"]["sns"]
      password = Devise.friendly_token[8,12] + "1a"
      params[:user][:password] = password
      params[:user][:password_confirmation] = password
    end
    @user = User.new(sign_up_params)
    ## @userがバリデーションに引っかかるなら入力させなおす
    unless @user.valid?
      render :new and return
    end
    ## @userがバリデーションをパスするならsessionに入れてお
    ## attributesメソッドは、@userの属性値をハッシュで取得するメソッド
    session["devise.regist_data"] ||= {}
    session["devise.regist_data"][:user] = @user.attributes
    ## passwordは@user.attributesに含まれないのでparamsから別途取得する
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    ## newaddress_presetのビューで使用する@addressを定義（@userに紐づけておく）
    @address_preset = @user.build_address_preset
    ## newaddress_presetのビューを表示させる
    render :new_address_preset
  end

  def create_address_preset
    ## sessionに入っているuserの情報を元に@userを定義しなおす
    @user = User.new(session["devise.regist_data"]["user"])
    @address_preset = AddressPreset.new(address_preset_params)
    @sns = SnsCredential.new(session["devise.regist_data"]["sns"])
    ## @userに@address_presetを紐づける
    @user.build_address_preset(@address_preset.attributes)
    @user.sns_credentials.new(@sns.attributes)
    ## @userがバリデーションに引っかかるなら入力させなおす
    unless @user.valid?
      render :new_address_preset and return
    end
    @user.save
    session["devise.regist_data"]["user"].clear
    session["devise.regist_data"]["sns"]&.clear
    ## ログイン状態にする
    sign_in(:user, @user)
  end

  private

  def address_preset_params
    params.require(:address_preset).permit(:postal_code, :prefecture, :city, :addresses, :building, :phone_number)
  end

  ## URL直打ちではusers/registrations#new_address_preset等にアクセスできないようにする
  def session_has_not_user_data
    redirect_to root_path, alert: "ユーザー情報がありません" unless session["devise.regist_data"]
  end
end
