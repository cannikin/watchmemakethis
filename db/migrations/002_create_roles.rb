Sequel.migration do
  up do
    create_table(:roles) do
      primary_key :id
      String      :name
    end
  end

  down do
    drop_table(:roles)
  end
end
