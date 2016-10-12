class PendingsController < ApplicationController
  respond_to :html

  def index
    @pendings = {}

    [Outgo, Income, Transfer, Trade].each do |model|
      @pendings[model.name.underscore] = model.pending
    end
  end
end
