class BytesController < ApplicationController
  before_action :find_byte, only: [:show, :edit, :update, :destroy]
  def index
    @bytes = Byte.all
  end
  def new
    @byte = Byte.new
  end
  def edit
  end
  def redirect
    byte = Byte.where(:byte => params[:byte]).first
    redirect_to byte.full_url and return if byte.present?
    redirect_to FALL_BACK_URL
  end
  def create
    @byte = Byte.new(byte_params)
    respond_to do |format|
      if @byte.save
        format.html { redirect_to @byte, notice: 'Byte was successfully created.' }
        format.json { render action: 'show', status: :created, location: @byte }
      else
        format.html { render action: 'new' }
        format.json { render json: @byte.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    respond_to do |format|
      if @byte.update(byte_params)
        format.html { redirect_to @byte, notice: 'Byte was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @byte.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @byte.destroy
    respond_to do |format|
      format.html { redirect_to bytes_url }
      format.json { head :no_content }
    end
  end
  private
  def find_byte
    @byte = Byte.find(params[:id])
  end
  def byte_params
    params.require(:byte).permit(:full_url, :byte)
  end
end
