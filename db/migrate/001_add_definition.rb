class AddDefinition < ActiveRecord::Migration
  def self.up
    create_table :definitions do |t|
      t.column :word, :string, :null => false
      t.column :meaning, :string, :null => false
      t.timestamps :null => true
    end
  end

  def self.down
    drop_table :definitions
  end
end
