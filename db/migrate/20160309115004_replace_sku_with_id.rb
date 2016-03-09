class ReplaceSkuWithId < ActiveRecord::Migration
  def up
    execute 'UPDATE books SET sku = id'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
