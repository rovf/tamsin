class AdminPagesController < ApplicationController
  def adm_login_form
      render 'adm_login'
  end

  # params[:admpwd] contains password
  def adm_login
      # We first do only static comparision. Later, we allow
      #   a password to be stored encrypted in the database.
      if [Figaro.env.admpwd_a, Figaro.env.admpwd_7].any? { |pw| pw == params[:admpwd] }
          begin_adm_session
          render admin_pages_home_path
      else
        flash.now[:error]='Ungültiges Administratorpasswort'
      end
  end

  def adm_logout
      end_adm_session
      redirect_to root_path
  end

  def adm_upload_selected
      render admin_pages_home_path
  end

end
