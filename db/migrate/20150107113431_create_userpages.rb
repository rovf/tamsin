class CreateUserpages < ActiveRecord::Migration
  def change
    create_table :userpages do |t|
      t.string :filename
      t.string :linkname
      t.integer :seqno
      t.datetime :valid_from
      t.datetime :valid_to

      t.timestamps
    end
  end
end
