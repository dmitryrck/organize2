module OneAccountSidebar
  def self.extended(base)
    base.instance_eval do
      sidebar "Account/Card", only: :show do
        para "#{resource.class.human_attribute_name(:name)}: #{resource.chargeable.to_s}"

        case resource.chargeable
        when Account
          para "#{resource.chargeable.class.human_attribute_name(:balance)}: #{resource.chargeable.decorate.balance}"
        when Card
          para "#{resource.chargeable.class.human_attribute_name(:payment_day)}: #{resource.chargeable.payment_day}"
        end
      end
    end
  end
end
