class RoomsController < ApplicationController
  #def index
    #@room = Room.find(current_user.company.rooms.first)
    #config_opentok
    #@tok_token = @opentok.generate_token :session_id => @room.session_id
  #end

  def index
    @my_rooms = get_rooms(current_user)
    @rooms_with_me = get_rooms_with_me(current_user)
    @groups = Group.where(:company_id => current_user.company.id).where(:parent_id => nil)
  end

  def show
    @my_rooms = get_rooms(current_user)
    @rooms_with_me = get_rooms_with_me(current_user)
    @room = Room.find(params[:id])
    @groups = Group.where(:company_id => current_user.company.id).where(:parent_id => nil)

    config_opentok
    @tok_token = @opentok.generate_token :session_id => @room.session_id
  end

  def new
    if !params[:add_user].nil?
      add_user_to_conference(params[:id], params[:user_id])
    elsif !params[:add_group].nil?
      add_group_to_conference(params[:id], params[:group_id])
    else
      if !params[:room_id].nil?
       @room = Room.find(!params[:room_id].nil?)
      else
      if (!params[:user_id].nil?)
        if get_user_permission?(params[:user_id])
          @conference = Conference.where(:owner_id => current_user).where(:user_id => params[:user_id]).first
          if @conference.nil?
            @room = Room.new
            @room.owner_id = current_user.id
            config_opentok
            #session = @opentok.create_session request.remote_addr
            #@room.session_id = session.session_id
            @room.public=true
            @room.save

            @new_conference = Conference.new
            @new_conference.room = @room
            @new_conference.company = current_user.company
            @new_conference.user_id = params[:user_id]
            @new_conference.owner_id = current_user.id
            @new_conference.save
          else
            @room = @conference.room
          end
        else
          redirect_to rooms_path
        end
      else
        if get_group_permission?(params[:group_id])
          @conferences = Conference.where(:owner_id => current_user).where(:group_id => params[:group_id]).all
          if @conferences.empty?
            @room = Room.new
            @room.owner_id = current_user.id

            config_opentok
            #session = @opentok.create_session request.remote_addr
            #@room.session_id = session.session_id
            @room.public=true
            @room.save

            @new_conference = Conference.new
            @new_conference.room = @room
            @new_conference.company = current_user.company
            @new_conference.group_id = params[:group_id]
            @new_conference.owner_id = current_user.id
            @new_conference.save
          else
            @room = Room.find(@conference.room_id)
          end
        else
          redirect_to rooms_path
        end
      end
      end
      redirect_to room_path(@room)
    end
  end

  def edit
    if (!params[:user_id].nil?)
      @conference = Conference.where(:owner_id => current_user).where(:user_id => params[:user_id]).first
      if @conference.nil?
        @new_conference = Conference.new
        @new_conference.room = Room.find(params[:room_id])
        @new_conference.company = current_user.company
        @new_conference.user_id = params[:user_id]
        @new_conference.save
      end
    else
      @conferences = Conference.where(:owner_id => current_user).where(:group_id => params[:group_id]).all
      if @conference.nil?
        @conference = Conference.new
        @conference.room = Room.find(params[:room_id])
        @conference.company = current_user.company
        @conference.group_id = params[:group_id]
        @conference.save
      end
    end
  end

  def destroy
    @room = Room.find(params[:id])
    Conference.delete_all(:room_id => @room)
    @room.delete
    redirect_to rooms_path
  end

  private

  def config_opentok
    if @opentok.nil?
	      @opentok = OpenTok::OpenTokSDK.new(11739502, "75d020096690199bd0fd54522a66cd0bd5a2a145", :api_url =>'https://api.opentok.com/hl')
    end
  end

  def get_rooms(user)
    @rooms =  Room.where(:owner_id => user).all
    @my_rooms = []

    @rooms.each do |room|
       room.name = get_room_name(room.id)
       @my_rooms << room
    end
    @my_rooms
  end

  def get_rooms_with_me(user)
    @conferences =  Conference.where(:user_id => user).all
    @rooms_with_me = []

    @conferences.each do |conference|
       @room = conference.room
       @room.name = get_room_name(@room.id)
       @rooms_with_me << @room
    end

    @conferences =  Conference.where(:group_id => user.group).all

    @conferences.each do |conference|
       @room = conference.room
       @room.name = get_room_name(@room.id)
       @rooms_with_me << @room
    end
  end

  def get_room_name(room_id)
    @conferences = Conference.where(:room_id => room_id)

    @name = ""
    @conferences.each do |conference|
      if !conference.user_id.nil?
        @name << User.find(conference.user_id).name + "  "
      else
        @name << Group.find(conference.group_id).group_name + "  "
      end
    end
    @name
  end

  def get_user_permission?(user_id)
    @user = User.find(user)
    if @user.company == current_user.company
      true
    else
      false
    end
  end

  def get_group_permission?(group)
    @group = Group.find(group)
    if @group.company == current_user.company
      true
    else
      false
    end
  end

  def add_user_to_conference(room_id, user_id)
    @conferences = Conference.where(:room_id => room_id).where(:user_id => user_id).all
    if @conferences.empty?
      @new_conference = Conference.new
      @new_conference.room = Room.find(room_id)
      @new_conference.company = current_user.company
      @new_conference.user_id = user_id
      @new_conference.owner_id = current_user.id
      @new_conference.save
    end
  end

  def add_group_to_conference(room_id, group_id)
    @conferences = Conference.where(:room_id => room_id).where(:group_id => group_id).all
    if @conferences.empty?
      @new_conference = Conference.new
      @new_conference.room = Room.find(room_id)
      @new_conference.company = current_user.company
      @new_conference.group_id = group_id
      @new_conference.owner_id = current_user.id
      @new_conference.save
    end
  end

end
