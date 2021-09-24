class OwnershipsController < ApplicationController
  def create
    @item = Item.find_or_initialize_by(code: params[:item_code])

    unless @item.persisted?
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)

      @item = Item.new(read(results.first))
      @item.save
    end

    # Want 関係として保存
    if params[:type] == 'Want'
      current_user.want(@item)
    elsif params[:type] == 'Have'
      current_user.have(@item)
    end
    flash[:success] = "商品を #{params[:type]} しました。" unless params[:type].nil?

    redirect_back(fallback_location: root_path)    
  end

  def destroy
    @item = Item.find(params[:item_id])

    if params[:type] == 'Want'
      current_user.unwant(@item) 
    elsif params[:type] == 'Have'
      current_user.unhave(@item)
    end
    flash[:success] = "商品の #{params[:type]} を解除しました。" unless params[:type].nil?

    redirect_back(fallback_location: root_path)    
  end
end
