# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.datetime :date_of_birth
      t.string :comment

      t.timestamps
    end
  end
end
