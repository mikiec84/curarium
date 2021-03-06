class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def welcome
    @name = current_user.present? ? current_user.name : 'anonymous'
    render template: 'user_mailer/welcome', layout: false
  end

  # GET /users
  # GET /users.json
  def index
    redirect_to( root_path ) unless current_user.present? && current_user.super
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    response.headers[ 'Access-Control-Allow-Origin' ] = Waku::CORS_URL

    if @user == current_user
      @spotlights = @user.spotlights.user_only
    else
      @spotlights = @user.spotlights.user_only.where( privacy: 'public' )
    end
  end

  # GET /users/new
  def new
    render text: '400 Bad Request', status: 400
    # not allowed
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    # not allowed
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # not allowed
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.friendly.find(params[:id])
    if current_user.present?
      @circles = Circle.for_user_by_current @user, current_user
    else
      @circles = Circle.for_user_by_anon @user
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :bio) unless params[ :user ].nil?
  end
end
