# frozen_string_literal: true

# app/controllers/leaderboard_controller.rb
class LeaderboardController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!
  layout 'authenticated_layout'

  def index
    session[:user_count] ||= 1

    @show_all_users = params[:show_all].present?
    # user_count is the number of users displayed on the leaderboard
    @user_count = params[:user_count].to_i

    @users = User.order(total_points: :desc)

    # set current user's rank to the session value if it exists
    @current_user_rank = session[:current_user_rank]

    # for testing purposes, only the #1 user is displayed at first and 1 user is added each time "View Next Users" is clicked
    # in production, this may be changed to display a larger number of users (show top 10 and load 5 more each time "View Next Users" is clicked)
    if @show_all_users
      session[:user_count] = nil

    elsif @user_count.positive? # Check if user_count is provided
      session[:user_count] = @user_count # Update user_count in session
      @users = User.order(total_points: :desc).limit(session[:user_count])

    else
      # determin user's rank the when this page loads without params
      calculate_ranks
      @current_user_rank = @users.find { |user| user == current_user }&.rank
      session[:current_user_rank] = @current_user_rank

      session[:user_count] = 1 # adjust to change the number of users displayed when leaderboard is first loaded
      @user_count = session[:user_count]
      @users = User.order(total_points: :desc).limit(session[:user_count])
    end

    @all_displayed = User.count == @users.count
    calculate_ranks
  end

  def calculate_ranks
    # Calculate rank for each user
    rank = 1
    prev_points = nil
    @users.each do |user|
      # If the user has the same points as the previous user, they should have the same rank
      if !prev_points
        prev_points = user.total_points
      elsif prev_points != user.total_points
        rank += 1
      end
      u_rank = rank
      user.define_singleton_method(:rank) { u_rank }
      prev_points = user.total_points
    end
  end

  private
  
  def set_user
    @user = current_user
  end
end
