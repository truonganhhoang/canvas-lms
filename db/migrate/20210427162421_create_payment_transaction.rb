class CreatePaymentTransaction < ActiveRecord::Migration[5.2]
  tag :predeploy

  def change
    create_table :payment_transactions do |t|
      t.integer :payment_type
      t.string :amount
      t.string :bank_code
      t.string :bank_tran_no
      t.string :card_type
      t.string :order_info
      t.string :pay_date
      t.references :user
      t.references :course

      t.timestamps
    end
  end
end
