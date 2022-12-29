module OneAccountSidebar
  def self.extended(base)
    base.instance_eval do
      sidebar "Account", only: :show do
        para "#{resource.class.human_attribute_name(:name)}: #{resource.chargeable.to_s}"

        para "#{resource.chargeable.class.human_attribute_name(:balance)}: #{resource.chargeable.decorate.balance}"
      end
    end
  end
end
