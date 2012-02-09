class RoomsController < ApplicationController
  def index
    @room = Room.find(current_user.company.rooms.first)
    config_opentok
    @tok_token = @opentok.generate_token :session_id => @room.session_id
  end

  private

  def config_opentok
    if @opentok.nil?
	      @opentok = OpenTok::OpenTokSDK.new(11739502, "75d020096690199bd0fd54522a66cd0bd5a2a145", :api_url =>'https://api.opentok.com/hl')
    end
  end

end
