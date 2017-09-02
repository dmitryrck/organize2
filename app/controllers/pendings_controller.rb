class PendingsController < ApplicationController
  respond_to :html

  def index
    @pendings = {}

    [Outgo, Income].each do |model|
      @pendings[model.name.underscore] = model.pending.decorate
    end
  end
end
