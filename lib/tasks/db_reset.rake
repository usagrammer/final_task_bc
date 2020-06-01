desc "This task is database reset"
task :reset_database => :environment do
  Address.destroy_all
  ItemTransaction.destroy_all
  Item.destroy_all
  User.destroy_all
end
