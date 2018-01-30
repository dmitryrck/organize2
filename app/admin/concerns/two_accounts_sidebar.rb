module TwoAccountsSidebar
  def self.extended(base)
    base.instance_eval do
      sidebar "Account (Source)", only: :show do
        para "#{Account.human_attribute_name(:name)}: #{resource.source.to_s}"
        para "#{Account.human_attribute_name(:balance)}: #{resource.source.decorate.balance}"
      end

      sidebar "Account (Destination)", only: :show do
        para "#{Account.human_attribute_name(:name)}: #{resource.destination.to_s}"
        para "#{Account.human_attribute_name(:balance)}: #{resource.destination.decorate.balance}"
      end
    end
  end
end
