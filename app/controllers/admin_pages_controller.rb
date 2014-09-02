class AdminPagesController < ApplicationController
  def adm_login_form
      render 'adm_login'
  end

  # params[:admpwd] contains password
  def adm_login
      # authenticate. We first do only static comparision. Later, we allow
      #   a password to be stored encrypted in the database.
      # set session to admin or reject; display error message on reject
      # render admin home or adm_login
      flash.now[:error]='Ungültiges Administratorpasswort'
  end

  def adm_logout
  end
end
