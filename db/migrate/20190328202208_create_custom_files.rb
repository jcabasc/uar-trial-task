class CreateCustomFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_files, id: :uuid, default: 'gen_random_uuid()', null: false do |t|
      t.string :name
      t.text :tags, array: true, default: []
    end

    add_index :custom_files, :tags, using: :gin
  end
end
