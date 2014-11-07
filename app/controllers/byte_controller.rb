class ByteController < ApplicationController
  def new
    @byte = Byte.new
  end
  def redirect
    byte = Byte.where(:byte => params[:byte]).first
    redirect_to byte.full_url if byte.present?
  end
end
