class AddIndexToUserpages < ActiveRecord::Migration
  def change
      add_index(:userpages, :filename)
  end
end
