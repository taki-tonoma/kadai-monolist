class RankingsController < ApplicationController
  def want
    get_ranking(Want)
  end

  def have
    get_ranking(Have)
  end

  private
  def get_ranking(type)
    @ranking_counts = type.ranking
    @items = Item.find(@ranking_counts.keys)
  end
end