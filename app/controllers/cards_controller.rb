class CardsController < ApplicationController
  respond_to :html

  def index
    @cards = Card.ordered.decorate
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    @card.save

    respond_with @card
  end

  def edit
    @card = Card.find(params[:id])
  end

  def update
    @card = find_card
    @card.update(card_params)
    respond_with @card
  end

  def show
    @card = find_card
    @movements = @card.movements.unpaid.ordered
  end

  private

  def find_card
    Card.find(params[:id]).decorate
  end

  def card_params
    params
      .require(:card)
      .permit(:active, :name, :limit, :payment_day, :precision)
  end
end
