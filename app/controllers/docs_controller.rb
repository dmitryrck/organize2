class DocsController < ApplicationController
  layout "docs"

  def index
    @docs = Doc.all
    @description = ""
  end

  def show
    @doc = Doc.new(params[:id])

    @title = @doc.title
    @description = @doc.description

    if @doc.invalid?
      render "show", status: 404
    end
  end
end
