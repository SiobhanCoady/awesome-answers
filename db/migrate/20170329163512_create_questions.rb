# The migration file gives instructions to Rails to change the structure of
# the database. By structure, we mean things like tables (creating/deleting),
# indexes, constraints, etc.
# Note that the migration itself is not the database. It's an instruction set to
# change the database. It will execute a query once you run:
# rails db:migrate
# or
# rails db:rollback

class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    # 'create_table' will create a table when you run 'rails db:migrate'
    # every created table will have a primary key called 'id' (integer
    # autoincrement)
    create_table :questions do |t|
      t.string :title
      t.text :body

      # 't.timestamps' will create two datetime fields 'created_at' and 'updated_at'
      # ActiveRecord will automatically set those fields for you when you create
      # a record or when you update a record.
      t.timestamps
    end
  end
end


# you can use 'rails db:rollback' to revert a migration. Rails will automatically
# guess what reverting the migration is. For example: if you did 'create_table',
# Rails will do 'drop_table'. If you did 'add_column', then Rails will do
# 'remove_column'.

# Note that rollback is likely going to be a destructive command. So if you
# drop a table, all the data in the table will be gone.
# You should only use 'rails db:rollback' if you discover the error right away.
# You shouldn't use 'rails db:rollback' if you already pushed to production
# or if you shared your code with other developers on Git. Instead, you can
# create another migration that fixes the mistake you made in the previous
# migration.
