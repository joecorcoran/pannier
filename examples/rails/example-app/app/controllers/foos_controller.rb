class FoosController < ApplicationController
  def show
    render :inline => '<h1>Pannier example app</h1>', :layout => 'application'
  end
end
