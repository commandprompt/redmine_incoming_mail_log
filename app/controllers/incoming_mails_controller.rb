class IncomingMailsController < ApplicationController
  unloadable

  layout 'admin'
  before_filter :require_admin
  before_filter :find_incoming_mail, :only => [:show, :destroy]

  def index
    # TODO: search & pagination
    @mails = IncomingMail.all
  end

  def show
  end

  def destroy
    @mail.destroy
    redirect_to :back
  rescue RedirectBackError
    redirect_to :action => 'index'
  end

  private

  def find_incoming_mail
    @mail = IncomingMail.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end