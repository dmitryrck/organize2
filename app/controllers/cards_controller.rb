class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :confirm, :unconfirm]

  respond_to :html

  def index
    @cards = Card.ordered
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    @card.save

    respond_with @card
  end

  def update
    @card.update(card_params)
    respond_with @card
  end

  def show
    @movements = @card.movements.unpaid.ordered
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params
      .require(:card)
      .permit(:active, :name, :limit, :payment_day)
  end
end
