class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  # GET /purchases
  # GET /purchases.json
  def index
    @purchases = Purchase.all
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchases_url, notice: 'Purchase was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pay
    product = Product.find(params[:product_id])
    buyer = Buyer.find(params[:buyer_id])
    purchase = Purchase.create(product: product, buyer: buyer)
    application_fee = (product.price.to_f * 10).to_i

    charge_attrs = {
      amount: (product.price.to_f * 100).to_i,
      currency: 'usd',
      source: params[:token],
      description: product.name,
      application_fee: application_fee
    }

    charge = Stripe::Charge.create(charge_attrs, product.seller.secret_key)
    Charge.create(purchase: purchase, application_fee_cents: application_fee, stripe_response: charge.to_h) #TODO: store the charge response

    @pay = OpenStruct.new(
      product_name: product.name,
      charge_id: charge.id,
      amount: product.price,
      application_fee: application_fee
    )
  rescue Stripe::CardError => e
    error = e.json_body[:error][:message]
    flash[:error] = "Charge failed! #{error}"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def purchase_params
    params.require(:purchase).permit(:product_id, :buyer_id, :token)
  end
end
